# 🚀 CI/CD Pipeline Configuration

Este documento explica **passo a passo** como configurar o pipeline de CI/CD para deploy automático no Google Play Store e geração de artefatos.

## 📋 Visão Geral

O pipeline possui os seguintes jobs:

1. **🧪 Test**: Executa análise de código e testes unitários com coverage
2. **🤖 Build Android**: Gera APKs (Debug/Release) e App Bundle
3. **🚀 Deploy Play Store**: Faz upload automático para Google Play (Internal Testing)
4. **🍎 Build iOS**: Gera arquivo iOS (apenas na branch main)
5. **📦 Release**: Cria release automático no GitHub com APK anexado

---

## ✅ Checklist Completo de Configuração

### **Secrets Necessários para Android + Google Play**

Configure no GitHub: `Settings → Secrets and variables → Actions → New repository secret`

| Secret | Descrição | Exemplo |
|--------|-----------|---------|
| `API_BASE_URL` | URL base da sua API | `https://api.seuapp.com` |
| `APP_NAME` | Nome da aplicação | `MyApp` |
| `PACKAGE_NAME` | Package name do Android | `com.example.base_clean_arch_bloc` |
| `KEYSTORE_BASE64` | Keystore em base64 | (gerado no passo 1) |
| `KEY_ALIAS` | Alias da chave no keystore | `upload` |
| `KEYSTORE_PASSWORD` | Senha do keystore | (definida por você) |
| `KEY_PASSWORD` | Senha da chave específica | (definida por você) |
| `SERVICE_ACCOUNT_JSON` | JSON da service account | (gerado no passo 3) |

### **Secrets Opcionais para iOS**

| Secret | Descrição |
|--------|-----------|
| `BUILD_CERTIFICATE_BASE64` | Certificado de distribuição em base64 |
| `IOS_BUILD_CERTIFICATE_PASSWORD` | Senha do certificado .p12 |
| `MOBILEPROVISION_BASE64` | Provisioning profile em base64 |
| `KEYCHAIN_PASSWORD` | Senha para keychain temporário |

---

## 🔑 Passo a Passo Completo

### **PASSO 1: Criar e Configurar Android Keystore**

#### 1.1 Gerar o Keystore (se não tiver)

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload
```

**O comando vai perguntar:**
- **Senha do keystore**: Crie uma senha forte → Isso será `KEYSTORE_PASSWORD`
- **Senha da chave**: Pode ser a mesma ou diferente → Isso será `KEY_PASSWORD`
- **Nome, organização, etc.**: Preencha conforme solicitado
- **Alias**: O padrão é `upload` → Isso será `KEY_ALIAS`

⚠️ **IMPORTANTE**: Anote as senhas em um local seguro. Se perder, não conseguirá mais atualizar seu app!

#### 1.2 Converter Keystore para Base64

```bash
# macOS/Linux
base64 -i ~/upload-keystore.jks | pbcopy

# Windows (PowerShell)
[Convert]::ToBase64String([IO.File]::ReadAllBytes("$HOME\upload-keystore.jks")) | Set-Clipboard
```

Isso copia o base64 para o clipboard. Cole no secret `KEYSTORE_BASE64`.

#### 1.3 Adicionar Secrets do Keystore no GitHub

```
KEYSTORE_BASE64=<valor copiado acima>
KEY_ALIAS=upload
KEYSTORE_PASSWORD=<senha que você criou>
KEY_PASSWORD=<senha da chave que você criou>
```

---

### **PASSO 2: Configurar Google Play Console**

#### 2.1 Criar o App

1. Acesse [Google Play Console](https://play.google.com/console)
2. Clique em **"Criar app"**
3. Preencha:
   - Nome do app
   - Idioma padrão
   - Tipo (App ou Jogo)
   - Gratuito ou Pago
4. Aceite os termos e crie

⚠️ **Anote o Package Name**: Geralmente é `com.example.base_clean_arch_bloc`

#### 2.2 Fazer Upload Inicial Manual (OBRIGATÓRIO)

O Google Play **exige** que o primeiro upload seja manual:

```bash
# Build local do App Bundle
flutter build appbundle --release
```

Depois:
1. No Play Console, vá em **"Internal testing"** → **"Create new release"**
2. Faça upload do arquivo: `build/app/outputs/bundle/release/app-release.aab`
3. Preencha todas as informações obrigatórias:
   - Screenshots
   - Descrição
   - Ícone
   - Privacy Policy
4. **Não precisa publicar**, só salvar o rascunho

✅ Após isso, o CI/CD poderá fazer uploads automáticos.

---

### **PASSO 3: Criar Google Cloud Service Account**

#### 3.1 Criar Projeto no Google Cloud

1. Acesse [Google Cloud Console](https://console.cloud.google.com)
2. Crie um novo projeto (ou use existente)
3. Anote o nome do projeto

#### 3.2 Criar Service Account

1. No Google Cloud Console, vá em **"IAM & Admin"** → **"Service Accounts"**
2. Clique em **"Create Service Account"**
3. Preencha:
   - Nome: `github-actions-deploy`
   - Descrição: `Service account para CI/CD deploy no Google Play`
4. Clique em **"Create and Continue"**
5. **Não adicione roles aqui**, clique em **"Done"**

#### 3.3 Gerar JSON Key

1. Clique na service account recém-criada
2. Vá na aba **"Keys"**
3. Clique em **"Add Key"** → **"Create new key"**
4. Escolha tipo: **JSON**
5. Clique em **"Create"** (arquivo baixa automaticamente)

#### 3.4 Configurar Secret no GitHub

1. Abra o arquivo `.json` baixado em um editor de texto
2. **Copie TODO o conteúdo** (é um JSON com várias linhas)
3. Cole no GitHub secret `SERVICE_ACCOUNT_JSON`

⚠️ O JSON deve estar completo, incluindo chaves `{}` e todas as propriedades.

---

### **PASSO 4: Dar Permissões no Google Play Console**

#### 4.1 Vincular Projeto do Google Cloud

1. Volte ao [Google Play Console](https://play.google.com/console)
2. Vá em **"Setup"** → **"API access"**
3. Se for a primeira vez:
   - Clique em **"Link a Google Cloud project"**
   - Selecione o projeto criado no Passo 3
   - Clique em **"Link"**

#### 4.2 Dar Permissões à Service Account

1. Em **"Service accounts"**, você verá a service account criada
2. Clique em **"Grant access"** (ou "Manage Play Console permissions")
3. Na seção **"Account permissions"**, marque:
   - ✅ **View app information and download bulk reports (read-only)**
4. Na seção **"App permissions"**, selecione seu app e marque:
   - ✅ **Create and edit draft releases**
   - ✅ **Release to testing tracks** (Internal, Closed, Open testing)
   - ✅ **Release apps to production**
5. Clique em **"Invite user"** → **"Send invitation"**

✅ Agora a service account pode fazer uploads via CI/CD!

---

### **PASSO 5: Adicionar Secrets de Configuração**

Adicione os últimos secrets no GitHub:

```
API_BASE_URL=https://sua-api.com
APP_NAME=SeuApp
PACKAGE_NAME=com.example.base_clean_arch_bloc
```

---

## 🔑 Resumo dos Secrets (Copy-Paste)

Para facilitar, aqui está a lista completa para você preencher:

```bash
# Configuração da Aplicação
API_BASE_URL=https://sua-api.com
APP_NAME=SeuApp
PACKAGE_NAME=com.example.base_clean_arch_bloc

# Android Keystore
KEYSTORE_BASE64=<resultado do: base64 -i ~/upload-keystore.jks>
KEY_ALIAS=upload
KEYSTORE_PASSWORD=<senha do keystore>
KEY_PASSWORD=<senha da chave>

# Google Play
SERVICE_ACCOUNT_JSON=<conteúdo completo do arquivo .json>
```

---

## 🚦 Triggers do Pipeline

### **Execução Automática**
- **Push para `main`**: Executa pipeline completo + deploy
- **Push para `develop`**: Executa apenas testes e build
- **Pull Request para `main`**: Executa testes

### **Execução Manual**
- No GitHub Actions, clique em "Run workflow"
- Escolha se deseja fazer deploy para Play Store
- Útil para testes ou deploys específicos

## 📱 Artefatos Gerados

### **Sempre Disponíveis**
- **APK Debug**: Para testes rápidos
- **APK Release**: Versão final para distribuição
- **App Bundle**: Para upload no Play Store

### **Na Branch Main**
- **iOS Archive**: Para distribuição iOS
- **GitHub Release**: Release automático com APK anexado

## 🎯 Fluxo de Deploy

### **Internal Testing (Automático)**
```
Push para main → Build → Sign → Upload to Play Store (Internal)
```

### **Production (Manual)**
1. Acesse Google Play Console
2. Promote from Internal → Production
3. Configure release notes
4. Publish

## 🛡️ Segurança

### **Proteção de Secrets**
- Secrets nunca aparecem nos logs
- Keystore e certificados são temporários
- Cleanup automático após execução

### **Branches Protegidas**
- Configure branch protection rules para `main`
- Exija status checks do CI
- Exija reviews para PRs

## 🐛 Troubleshooting

### **Erro: "No service account found"**
```
❌ Causa: Service account não está vinculada ao Google Play Console
✅ Solução:
   1. Volte ao Passo 4.1 e vincule o projeto do Google Cloud
   2. Execute o Passo 4.2 para dar permissões
```

### **Erro: "Unauthorized - 401"**
```
❌ Causa: JSON da service account inválido ou incompleto
✅ Solução:
   1. Verifique se copiou TODO o conteúdo do .json
   2. O JSON deve começar com { e terminar com }
   3. Não pode ter quebras de linha extras ou espaços
```

### **Erro: "Package not found"**
```
❌ Causa: App não foi criado no Play Console OU package name diferente
✅ Solução:
   1. Verifique se criou o app no Play Console (Passo 2.1)
   2. Confirme se PACKAGE_NAME no GitHub = applicationId no build.gradle
   3. Faça o upload manual inicial (Passo 2.2)
```

### **Erro de Signing: "Invalid keystore format"**
```
❌ Causa: KEYSTORE_BASE64 está incorreto
✅ Solução:
   1. Regere o base64: base64 -i ~/upload-keystore.jks | pbcopy
   2. Cole EXATAMENTE o output no secret (sem espaços/quebras)
```

### **Erro: "Version code X has already been used"**
```
❌ Causa: Tentando fazer upload de uma versão que já existe
✅ Solução:
   1. Incremente versionCode no pubspec.yaml
   2. Exemplo: 1.0.0+1 → 1.0.0+2
```

### **Erro de Build: "Flutter version not found"**
```
❌ Causa: Versão do Flutter no workflow está desatualizada
✅ Solução:
   1. Verifique sua versão local: flutter --version
   2. Atualize FLUTTER_VERSION no workflow
```

### **Erro: "First upload must be manual"**
```
❌ Causa: Você não fez o upload inicial manual
✅ Solução:
   1. Execute o Passo 2.2 completamente
   2. Não precisa publicar, apenas criar o draft
```

## 📊 Monitoring

### **GitHub Actions**
- Logs detalhados de cada step
- Tempo de execução por job
- Histórico de execuções

### **Play Console**
- Status do upload
- Validações do Google
- Métricas de release

## 🔄 Customização

### **Alterar Track de Deploy**
```yaml
track: internal  # Mude para: alpha, beta, production
```

### **Adicionar Notificações**
```yaml
- name: 📢 Notify Slack
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

### **Cache Personalizado**
```yaml
- name: 📦 Cache Dependencies
  uses: actions/cache@v3
  with:
    path: ~/.pub-cache
    key: ${{ runner.os }}-pub-cache-${{ hashFiles('pubspec.yaml') }}
```

## 📚 Referências

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Google Play Upload Action](https://github.com/r0adkll/upload-google-play)
- [Flutter Build Action](https://github.com/subosito/flutter-action)
- [Android Signing Action](https://github.com/r0adkll/sign-android-release)
- [Google Play Console](https://play.google.com/console)
- [Google Cloud Console](https://console.cloud.google.com)

---

## ⚡ Quick Start

Se você já tem tudo configurado e só quer um checklist rápido:

- [ ] Keystore criado e convertido para base64
- [ ] App criado no Google Play Console
- [ ] Upload inicial manual feito (Internal Testing)
- [ ] Service Account criada no Google Cloud
- [ ] Permissões concedidas no Play Console
- [ ] Todos os 8 secrets adicionados no GitHub
- [ ] Package name correto em todos os lugares
- [ ] Versão incrementada no pubspec.yaml

✅ **Tudo pronto?** Faça um push para `main` e veja a mágica acontecer! 🚀