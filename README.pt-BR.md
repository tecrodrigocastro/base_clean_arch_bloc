# base_clean_arch_bloc

[English version](README.md)

Um **template** Flutter para Clean Architecture (Robert C. Martin) com BLoC para gerenciamento de estado, seguindo os princípios de SOLID e separação de responsabilidades.

Este repositório foi feito para ser clonado/copiado como ponto de partida de um novo app, não para ser expandido como um produto em si. A feature `auth` é a implementação de referência, totalmente construída, que qualquer feature nova deve imitar; `home` e `base` são placeholders mínimos.

> **Trabalhando com assistentes de IA**: este projeto já vem com um `CLAUDE.md`, `.claude/rules/` e uma skill de scaffolding em `.claude/skills/new-feature/`, para que o Claude Code (ou qualquer assistente que leia `CLAUDE.md`) já conheça a arquitetura, as convenções de nomenclatura e saiba gerar uma feature nova de ponta a ponta.

## Arquitetura

```
lib/
├── src/
│   ├── app/
│   │   └── features/                # Uma pasta por feature/módulo
│   │       └── auth/                # Feature de referência - copie essa estrutura para novas features
│   │           ├── data/            # Models, datasources, implementações de repositório
│   │           ├── domain/          # Entities, DTOs, interfaces de repositório, usecases, validators
│   │           ├── infrastructure/  # Interceptors/serviços específicos da feature
│   │           └── presentation/    # BLoC, pages, widgets
│   └── core/                        # Código compartilhado, agnóstico de feature
│       ├── DI/                      # Configuração de injeção de dependência (get_it)
│       ├── cache/                   # Abstração de cache
│       ├── client_http/             # Wrapper do Dio com interceptors
│       ├── errors/                  # Hierarquia de exceções
│       ├── extensions/
│       ├── interfaces/              # Contrato UseCase
│       ├── services/                # Serviços cross-feature (ex: SessionService)
│       └── utils/
├── app_widget.dart
├── main.dart
└── routes.dart
```

### Camadas

- **Domain**: entities, usecases, interfaces de repositório, validators. Não depende de nenhuma outra camada.
- **Data**: models (que estendem entities), datasources, implementações de repositório. Depende apenas do domain.
- **Presentation**: BLoC, pages, widgets. Depende apenas do domain (usecases), nunca de datasources/repositórios diretamente.
- **Infrastructure**: interceptors e serviços específicos de uma feature.

### Fluxo de dados

```
UI -> BLoC -> Use Case -> Repository (interface) -> Repository (impl) -> Data Source -> API / armazenamento local
```

As convenções completas (tabela de nomenclatura, mapeamento de SOLID, regra de dependência) estão em `.claude/rules/`.

## Principais dependências

**Estado e arquitetura**
- `flutter_bloc` - gerenciamento de estado reativo
- `get_it` - injeção de dependência / service locator
- `equatable` - comparação por valor para states/events do BLoC

**Navegação**
- `go_router` - roteamento declarativo e type-safe

**Networking**
- `dio` - cliente HTTP com interceptors
- `logger` - logging estruturado

**Persistência**
- `shared_preferences` - armazenamento local chave-valor

**Utilitários**
- `result_dart` - padrão `Success`/`Failure` em vez de lançar exceções entre camadas
- `lucid_validation` - validação declarativa de campos
- `intl` - internacionalização e formatação

**UI**
- `gap`, `shimmer`

## Padrões-chave

- **Result pattern**: métodos de repositório e usecase retornam `AsyncResult<T>` (`result_dart`); só a camada de dados captura exceções e as converte em subclasses de `BaseException`.
- **Injeção de dependência**: todas as ligações são centralizadas em `lib/src/core/DI/dependency_injector.dart` (get_it), o que facilita trocar implementações (ex: repositório mock vs real) e escrever testes unitários.
- **Tratamento de erros estruturado**: uma hierarquia de exceções em `lib/src/core/errors/` mapeia falhas HTTP para erros com significado de domínio.

## Testes

A feature `auth` tem cobertura de testes em todas as camadas, servindo como referência a ser seguida: testes unitários para entities, DTOs, usecases, repositórios e datasources; uma suíte de testes de BLoC cobrindo states/events/transições; e um teste de widget para a página de login.

```bash
flutter test                    # todos os testes
flutter test test/unit/         # apenas testes unitários
flutter test test/widget/       # apenas testes de widget
flutter test --coverage
```

## Começando

Requisitos: Flutter SDK `^3.5.1`.

```bash
git clone https://github.com/tecrodrigocastro/base_clean_arch_bloc.git
cd base_clean_arch_bloc
flutter pub get
flutter run
```

### Build

```bash
flutter build apk     # Android
flutter build ios      # iOS
flutter build web      # Web
```

### CI/CD

`.github/workflows/integration.yaml` roda os testes em todo push/PR e faz build, assinatura e entrega (GitHub Release + Play Store + TestFlight) em tags `v*.*.*`. As instruções de configuração e os secrets necessários estão em `.github/README_CICD.md` (em inglês) / `.github/README_CICD.pt-BR.md` (em português).

## Usando este template em um projeto novo

1. Clone/copie o repositório e renomeie o pacote (`pubspec.yaml`, `applicationId`/`namespace` em `android/app/build.gradle`, bundle identifier do iOS).
2. Apague ou substitua o conteúdo da feature `auth` pela sua primeira feature real, mantendo a mesma estrutura de pastas/arquivos.
3. Atualize o `CLAUDE.md` com o que for específico do seu projeto assim que ele divergir deste template.
4. Configure os secrets descritos em `.github/README_CICD.md` caso pretenda usar o pipeline de CI/CD.

## Contribuindo

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Faça commit das suas alterações
4. Faça push para a branch
5. Abra um Pull Request

## Licença

MIT - veja [LICENSE](LICENSE).
