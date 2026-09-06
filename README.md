# base_clean_arch_bloc

[Versão em português](README.pt-BR.md)

A Flutter **template** for Clean Architecture (Robert C. Martin) with BLoC for state management, following SOLID and clear separation of concerns.

This repo is meant to be cloned/copied as the starting point for a new app, not extended into a product itself. The `auth` feature is the fully-implemented reference every new feature should imitate; `home` and `base` are minimal placeholders.

> **Working with AI assistants**: this project ships a `CLAUDE.md`, `.claude/rules/` and a `.claude/skills/new-feature/` scaffolding skill so Claude Code (or any assistant that reads `CLAUDE.md`) already knows the architecture, naming conventions and how to generate a new feature end-to-end.

### Feature scaffolding

New features follow the same domain/data/presentation shape as `auth`. Instead of copying files by hand, generate one with [Mason](https://pub.dev/packages/mason_cli):

```bash
dart pub global activate mason_cli
mason get   # once per clone, registers bricks/feature/ from mason.yaml
mason make feature --feature_name product --action_name create --fields "id:String,name:String,price:double" -o .
```

This generates the entity, DTO, repository interface/impl, usecase, validator, model, datasource, BLoC (+event/state) and matching tests for that one action. Add `--generate_page` to also generate a page. Wiring the new feature into `lib/src/core/DI/dependency_injector.dart` is still a manual step - see the `auth` block there for the shape to follow.

## Architecture

```
lib/
├── src/
│   ├── app/
│   │   └── features/                # One folder per feature/module
│   │       └── auth/                # Reference feature - copy this shape for new features
│   │           ├── data/            # Models, datasources, repository implementations
│   │           ├── domain/          # Entities, DTOs, repository interfaces, usecases, validators
│   │           ├── infrastructure/  # Feature-specific interceptors/services
│   │           └── presentation/    # BLoC, pages, widgets
│   └── core/                        # Shared, feature-agnostic code
│       ├── DI/                      # Dependency injection setup (get_it)
│       ├── cache/                   # Cache abstraction
│       ├── client_http/             # Dio wrapper with interceptors
│       ├── errors/                  # Exception hierarchy
│       ├── extensions/
│       ├── interfaces/              # UseCase contract
│       ├── services/                # Cross-feature services (e.g. SessionService)
│       └── utils/
├── app_widget.dart
├── main.dart
└── routes.dart
```

### Layers

- **Domain**: entities, usecases, repository interfaces, validators. No dependency on any other layer.
- **Data**: models (extend entities), datasources, repository implementations. Depends only on domain.
- **Presentation**: BLoC, pages, widgets. Depends only on domain (usecases), never on datasources/repositories directly.
- **Infrastructure**: interceptors and services specific to one feature.

### Data flow

```
UI -> BLoC -> Use Case -> Repository (interface) -> Repository (impl) -> Data Source -> API / local storage
```

Full conventions (naming table, SOLID mapping, dependency rule) live in `.claude/rules/`.

## Main dependencies

**State and architecture**
- `flutter_bloc` - reactive state management
- `get_it` - dependency injection / service locator
- `equatable` - value equality for BLoC states/events

**Navigation**
- `go_router` - declarative, type-safe routing

**Networking**
- `dio` - HTTP client with interceptors
- `logger` - structured logging

**Persistence**
- `shared_preferences` - local key-value storage

**Utilities**
- `result_dart` - `Success`/`Failure` result pattern instead of throwing across layers
- `lucid_validation` - declarative field validation
- `intl` - i18n and formatting

**UI**
- `gap`, `shimmer`

## Key patterns

- **Result pattern**: repository and usecase methods return `AsyncResult<T>` (`result_dart`); only the data layer catches exceptions and converts them into `BaseException` subclasses.
- **Dependency injection**: all bindings are centralized in `lib/src/core/DI/dependency_injector.dart` (get_it), which makes swapping implementations (e.g. mock vs real repository) and unit testing straightforward.
- **Structured error handling**: an exception hierarchy under `lib/src/core/errors/` maps HTTP failures to domain-meaningful errors.

## Tests

The `auth` feature has full-layer test coverage as the reference to follow: unit tests for entities, DTOs, usecases, repositories and datasources; a BLoC test suite covering states/events/transitions; and a widget test for the login page.

```bash
flutter test                    # all tests
flutter test test/unit/         # unit tests only
flutter test test/widget/       # widget tests only
flutter test --coverage
```

## Getting started

Requirements: Flutter SDK `^3.5.1`.

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

`.github/workflows/integration.yaml` runs tests on every push/PR and builds, signs, and ships (GitHub Release + Play Store + TestFlight) on `v*.*.*` tags. Setup instructions and required secrets are in `.github/README_CICD.md`.

## Using this template for a new project

1. Clone/copy the repo and rename the package (`pubspec.yaml`, `applicationId`/`namespace` in `android/app/build.gradle`, iOS bundle identifier).
2. Delete or replace the `auth` feature's content with your own first feature, keeping the same folder/file shape.
3. Update `CLAUDE.md` with anything project-specific once it diverges from this template.
4. Configure the secrets described in `.github/README_CICD.md` if you intend to use the CI/CD pipeline.

## Contributing

1. Fork the project
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## License

MIT - see [LICENSE](LICENSE).
