# base_clean_arch_bloc

Flutter template implementing Clean Architecture (Robert C. Martin) with BLoC for state management. It exists to be cloned/copied as a starting point for new apps, not to grow into a product itself - the `auth` feature is the reference implementation every new feature should imitate.

Detailed conventions live in `.claude/rules/` and are loaded automatically. The `new-feature` skill (`.claude/skills/new-feature/`) scaffolds a complete feature end-to-end - prefer it over writing a feature by hand.

## Stack

- State management: `flutter_bloc` + `equatable`
- DI: `get_it` (`lib/src/core/DI/dependency_injector.dart`)
- Routing: `go_router` (`lib/routes.dart`)
- HTTP: `dio`, wrapped behind `lib/src/core/client_http/` so features never import `dio` directly
- Error handling: `result_dart` (`Success`/`Failure`, no throwing across layer boundaries)
- Validation: `lucid_validation`
- Local storage: `shared_preferences`, behind `lib/src/core/cache/`

## Structure

```
lib/src/
├── app/features/{feature}/
│   ├── domain/          # entities, dtos, repository interfaces, usecases, validators - no Flutter/dio imports
│   ├── data/             # models (extend entities), datasources, repository implementations
│   ├── infrastructure/    # interceptors, feature-specific services
│   └── presentation/
│       ├── bloc/          # {feature}_bloc.dart, _event.dart, _state.dart (event/state are `part of`)
│       ├── pages/
│       └── widgets/
└── core/                  # DI, cache, client_http, errors, extensions, interfaces, services, utils
```

`auth` is the fully-implemented reference feature (all layers + unit/widget tests). `home` and `base` are minimal - presentation-only, no backing feature yet.

## Commands

```bash
flutter pub get
flutter analyze
flutter test --coverage
flutter test test/unit/auth/domain/usecases/login_usecase_test.dart   # single test file
flutter run
```

CI/CD is documented in `.github/README_CICD.md`. Tests run on every push/PR; build+release+deploy only run on `v*.*.*` tags.

## Non-negotiables

- **Dependency Rule**: `presentation -> domain <- data <- infrastructure`. `domain/` never imports Flutter, `dio`, or any other layer.
- **Result pattern everywhere**: repository and usecase signatures return `AsyncResult<T>` (`result_dart`), never throw. Only `data/` catches exceptions and converts them to `BaseException` subclasses (`lib/src/core/errors/`).
- **Entities are immutable**: `final` fields, `const` constructor, extend `Equatable`. **DTOs/params are plain mutable classes** (non-final fields, `set{Field}()` methods, manual `==`/`hashCode`/`toString`, a static `empty()` factory) - see `LoginParams`, don't invent a `copyWith`-based DTO instead. Models extend entities and add `fromMap`/`toMap`/`fromJson`/`toJson`. Classes are plain `class` (not `final class`) throughout - only repository interfaces use `abstract interface class`.
- **BLoC**: events/states extend `Equatable`; the bloc file chains `validator.validateResult(params).flatMap(usecase.call).fold(...)` rather than nested try/catch.
- See `.claude/rules/naming-conventions.md` for the full naming table (`{Entity}Entity`, `I{Feature}Repository`, `{Action}Usecase`, etc.) before creating new files.
