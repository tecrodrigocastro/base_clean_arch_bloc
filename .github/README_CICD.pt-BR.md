# Configuração do Pipeline de CI/CD

[English version](README_CICD.md)

Este documento explica como configurar o pipeline de CI/CD para builds automatizados, releases no GitHub, deploy no Google Play e uploads para o TestFlight.

## Visão geral

O pipeline (`.github/workflows/integration.yaml`) tem dois modos de disparo:

- **Push para `main`/`develop` ou pull request para `main`**: roda apenas o job `test` (`flutter analyze` + `flutter test --coverage`). Barato e rápido, roda em todo commit.
- **Push de uma tag no formato `v*.*.*`** (ex: `v1.2.3`): roda `build_android`, `release`, `deploy_play_store` e `build_ios`. Build, assinatura e entrega só acontecem quando você decide deliberadamente cortar um release, não a cada merge.

Para lançar um release:

```bash
git tag v1.2.3
git push origin v1.2.3
```

### Jobs

| Job | Roda em | Disparo | Faz |
|---|---|---|---|
| `test` | ubuntu | push/PR (não tags) | `flutter analyze`, `flutter test --coverage`, envia cobertura ao Codecov |
| `build_android` | ubuntu | tag `v*.*.*` | Builda APKs assinados (split por ABI) + um App Bundle |
| `release` | ubuntu | tag `v*.*.*` | Publica um Release no GitHub com os APKs anexados |
| `deploy_play_store` | ubuntu | tag `v*.*.*` | Envia o App Bundle para a Play Store (track internal) |
| `build_ios` | macos | tag `v*.*.*` | Gera o archive, exporta e envia o IPA para o TestFlight |

---

## Secrets Necessários

Configure em `Settings -> Secrets and variables -> Actions -> New repository secret`.

### Configuração da aplicação

| Secret | Descrição | Exemplo |
|---|---|---|
| `API_BASE_URL` | URL base da sua API | `https://api.seuapp.com` |
| `APP_NAME` | Nome da aplicação | `MeuApp` |
| `PACKAGE_NAME` | Package name do Android | `com.example.base_clean_arch_bloc` |

### Assinatura Android + Google Play

| Secret | Descrição |
|---|---|
| `KEYSTORE_BASE64` | Keystore de upload, codificado em base64 |
| `KEY_ALIAS` | Alias da chave dentro do keystore |
| `KEYSTORE_PASSWORD` | Senha do keystore |
| `KEY_PASSWORD` | Senha da chave |
| `SERVICE_ACCOUNT_JSON` | JSON da service account do Google Cloud (uploads para a Play Store) |

Se `KEYSTORE_BASE64` não estiver configurado, o `build_android` ainda roda, mas usa a assinatura de debug como fallback (veja `android/app/build.gradle`) - útil para testar o pipeline antes de configurar os secrets, mas o APK/AAB gerado não pode ser enviado à Play Store.

### Assinatura iOS + App Store Connect

| Secret | Descrição |
|---|---|
| `APP_STORE_CONNECT_API_KEY_ID` | Key ID da API key da App Store Connect |
| `APP_STORE_CONNECT_API_KEY_BASE64` | Arquivo `.p8` da chave privada, codificado em base64 |
| `APP_STORE_CONNECT_API_ISSUER_ID` | Issuer ID da App Store Connect |

Nenhum secret de certificado ou provisioning profile é necessário: o `xcodebuild` recebe a API key diretamente com `-allowProvisioningUpdates`, e os servidores da Apple emitem o certificado de distribuição e o provisioning profile sob demanda, mesmo num runner limpo.

---

## Passo a Passo da Configuração

### 1. Keystore Android

Gere um, caso ainda não tenha:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Codifique em base64 e guarde o resultado em `KEYSTORE_BASE64`:

```bash
# macOS/Linux
base64 -i ~/upload-keystore.jks | pbcopy

# Windows (PowerShell)
[Convert]::ToBase64String([IO.File]::ReadAllBytes("$HOME\upload-keystore.jks")) | Set-Clipboard
```

Guarde o alias e as duas senhas usadas acima como `KEY_ALIAS`, `KEYSTORE_PASSWORD` e `KEY_PASSWORD`.

Mantenha o keystore e suas senhas em um local seguro fora do repositório - se perder, não será mais possível atualizar o app na Play Store.

### 2. Google Play Console

1. Crie o app no [Play Console](https://play.google.com/console) e anote o package name.
2. A Play Store exige que o **primeiro** upload seja manual:
   ```bash
   flutter build appbundle --release
   ```
   Faça upload de `build/app/outputs/bundle/release/app-release.aab` em Internal Testing, preencha as informações obrigatórias da ficha do app e salve como rascunho (não precisa publicar).
3. No [Google Cloud Console](https://console.cloud.google.com), crie uma service account (`IAM & Admin -> Service Accounts`) e gere uma chave JSON para ela (`Keys -> Add key -> JSON`).
4. De volta ao Play Console, vá em `Setup -> API access`, vincule o projeto do Google Cloud e conceda à service account:
   - **Visualizar informações do app** (somente leitura)
   - **Criar e editar rascunhos de release**
   - **Lançar para as tracks de teste**
5. Cole o conteúdo completo do JSON no secret `SERVICE_ACCOUNT_JSON`.

### 3. API Key da App Store Connect

1. Em [App Store Connect](https://appstoreconnect.apple.com), vá em `Users and Access -> Integrations -> App Store Connect API`.
2. Crie uma chave com o papel **App Manager** e baixe o arquivo `.p8` (a Apple só permite baixar uma vez).
3. Anote o **Key ID** e o **Issuer ID** mostrados na página.
4. Codifique a chave e preencha os secrets:
   ```bash
   base64 -i AuthKey_XXXXXXXXXX.p8 | pbcopy
   ```
   - `APP_STORE_CONNECT_API_KEY_ID` = o Key ID
   - `APP_STORE_CONNECT_API_KEY_BASE64` = o resultado do base64 acima
   - `APP_STORE_CONNECT_API_ISSUER_ID` = o Issuer ID
5. Abra `ios/ExportOptions.plist` e substitua `YOUR_TEAM_ID` pelo seu Apple Developer Team ID.

---

## Troubleshooting

**"No service account found" / Play Store 401** - a service account não está vinculada ou não tem permissões; refaça o passo de API access no Play Console.

**"Package not found"** - `PACKAGE_NAME` não corresponde ao app criado no Play Console, ou o upload manual inicial (passo 2 acima) ainda não foi feito.

**"Version code X has already been used"** - incremente a versão em `pubspec.yaml` (`1.0.0+1` -> `1.0.0+2`); note que o `build_android` já soma `1000 + github.run_number` ao `versionCode` para evitar colisão com uploads manuais anteriores.

**Archive do iOS falha com "No Accounts" / "No profiles found"** - os secrets da API key da App Store Connect estão ausentes ou incorretos; esse fluxo não usa um Apple ID local, então a assinatura depende inteiramente desses três secrets mais o `teamID` em `ios/ExportOptions.plist`.

**Formato de keystore inválido** - rode novamente o comando de base64 e cole o resultado exatamente, sem espaços ou quebras de linha extras.
