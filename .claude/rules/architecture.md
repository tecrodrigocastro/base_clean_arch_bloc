# Architecture

Clean Architecture, four layers per feature, plus a shared `core/`.

## Dependency Rule

```
presentation --> domain <-- data <-- infrastructure
```

- `domain/` depends on nothing else in the app (no Flutter, no `dio`, no other layer). It is pure Dart.
- `data/` depends only on `domain/` (implements its repository interfaces, extends its entities into models).
- `presentation/` depends only on `domain/` (calls usecases, never talks to a datasource or repository implementation directly).
- `infrastructure/` may depend on `domain/` and `data/` (interceptors, feature-scoped services).

If a file in `domain/` needs to import something from `data/`, `presentation/`, `flutter/material.dart`, or a package like `dio`, that's a violation - move the logic to the layer that's allowed to depend on it, or invert the dependency behind an interface in `domain/`.

## Layer responsibilities

**Domain** (`domain/`)
- `entities/`: immutable business objects (`final` fields, `const` constructor, extend `Equatable`).
- `dtos/`: mutable input parameters for usecases (e.g. `LoginParams` - plain fields + `set{Field}()` methods, not `copyWith`), with a static `empty()` factory and `toJson()`.
- `repositories/`: abstract interfaces only (`abstract interface class I{Feature}Repository`), methods return `AsyncResult<T>`.
- `usecases/`: one class per action, implements `UseCase<Output, Input>` (`lib/src/core/interfaces/usecase_interface.dart`), holds business rules that don't belong in the BLoC or the repository.
- `validators/`: `LucidValidator<Params>` subclasses, one rule per field.

**Data** (`data/`)
- `models/`: extend the matching entity, add `fromMap`/`toMap`/`fromJson`/`toJson`. This is the only place JSON parsing happens.
- `datasources/`: talk to `IRestClient` (or local storage) and return raw responses. No business logic, no error mapping.
- `repositories/`: implement the domain interface, catch `RestClientException`/other exceptions, map them to `BaseException` subclasses, return `Success`/`Failure`.

**Presentation** (`presentation/`)
- `bloc/`: one bloc per feature; events and states are `part of` the bloc file, both extend `Equatable`.
- `pages/`: `BlocListener` for side effects (snackbars, navigation), `BlocBuilder` for rebuilding UI - keep them separate, don't mix into one `BlocConsumer` unless the widget genuinely needs both in the same spot.
- `widgets/`: reusable UI pulled out of pages once it's used more than once.

**Infrastructure** (`infrastructure/`)
- Interceptors and services that are specific to one feature (e.g. `auth_interceptor.dart` attaching the session token). Cross-feature infrastructure belongs in `core/`.

## Core (`lib/src/core/`)

Shared, feature-agnostic code: `DI/` (get_it setup), `cache/`, `client_http/` (Dio wrapper + interceptors), `errors/` (`BaseException` hierarchy), `extensions/`, `interfaces/` (`UseCase`), `services/` (e.g. `SessionService`), `utils/`.

Never import a feature from `core/`. If `core/` needs feature-specific behavior, that's a sign the code belongs in the feature's `infrastructure/` instead.

## Data flow

```
UI -> BLoC -> UseCase -> Repository (interface) -> Repository (impl) -> DataSource -> API / local storage
```

Errors flow back up the same chain as `Failure(BaseException)`, never as a thrown exception crossing a layer boundary.
