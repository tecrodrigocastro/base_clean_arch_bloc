---
name: new-feature
description: Scaffold a complete feature (domain, data, presentation, DI wiring, tests) following this project's Clean Architecture + BLoC conventions. Use whenever the user asks to add a new feature/module/screen backed by an API, not just a standalone widget.
---

# New Feature Scaffold

Generates every layer of a feature the same way `auth` is built - use `auth` (`lib/src/app/features/auth/`) as the live reference whenever a template below is ambiguous. Naming and modifier rules are in `.claude/rules/naming-conventions.md`; layer boundaries are in `.claude/rules/architecture.md`. Read both before generating files if this is the first feature you're scaffolding in a session.

## Step 0: run the Mason brick first

Don't hand-write the boilerplate below from scratch - `bricks/feature/` is a Mason brick that generates it in one shot (entity, DTO, repository interface/impl, usecase, validator, model, datasource, bloc+event+state, matching tests, and optionally a page). Run:

```bash
mason get   # once per clone, registers bricks/feature/ from mason.yaml
mason make feature \
  --feature_name product \
  --action_name create \
  --fields "id:String,name:String,price:double" \
  --generate_page \
  -o .
```

Notes:
- `entity_name` defaults to `feature_name` - only pass `--entity_name` when the entity is named differently (e.g. feature `auth`, entity `user`/`auth_response`).
- `fields` is `name:type,name:type`; supported types get sensible empty/sample values in the generated tests (`String`, `int`, `double`, `num`, `bool` - anything else falls back to `null`, which only works for nullable fields).
- Booleans need an explicit value on the CLI: pass `--generate_page` to include a page, or `--generate_page false` to skip it (omitting the flag entirely triggers an interactive prompt, which fails in non-interactive shells).
- The brick's validator only adds `.notEmpty()` rules for `String` fields - add custom rules for numeric/bool fields by hand afterward.
- The generated repository interface/usecase/bloc cover exactly one action. For a second action on the same feature (e.g. `getAll` alongside `create`), re-run `mason make feature` with the new `--action_name` and answer "skip" when prompted about conflicts on `{feature}_entity.dart`/`{feature}_repository_interface.dart`/`{feature}_bloc.dart` - then manually add the new method to the repository interface/impl and the new event/state to the bloc, following the shape the brick already generated for the first action.
- `flutter analyze` and `flutter test` are guaranteed clean for the field types above - this was verified end-to-end before the brick was committed.

Everything from here down documents what the brick generates (and how to extend it by hand) - read it when the brick's output needs adjusting, when scaffolding a second action, or when the feature doesn't fit the brick's shape (e.g. no HTTP datasource).

## Before writing anything

Ask (or infer from context) if unclear:
1. Feature name (e.g. `product`, `order`) - drives folder name and class prefixes.
2. Which actions it needs (`create`, `getAll`, `getById`, `update`, `delete`, or a custom one like `login`) - don't scaffold CRUD methods nobody asked for.
3. The entity's fields.
4. Whether it needs a dedicated page/widget now, or just the domain+data+bloc layer.

Only build what's asked - a feature that only lists items doesn't need `create`/`update`/`delete` stubs.

## Steps

### 1. Create the folder structure

```bash
mkdir -p lib/src/app/features/{feature}/domain/{entities,dtos,repositories,usecases,validators}
mkdir -p lib/src/app/features/{feature}/data/{models,datasources,repositories}
mkdir -p lib/src/app/features/{feature}/infrastructure
mkdir -p lib/src/app/features/{feature}/presentation/{bloc,pages,widgets}
mkdir -p test/unit/{feature}/{domain/{entities,usecases,validators},data/{models,datasources,repositories},presentation/bloc}
mkdir -p test/widget/{feature}
```

Skip `infrastructure/` and its contents if the feature doesn't need a custom interceptor/service.

### 2. Domain layer

**Entity** (`domain/entities/{name}_entity.dart`) - immutable, extends `Equatable`:

```dart
import 'package:equatable/equatable.dart';

class {Entity}Entity extends Equatable {
  final String id;
  final String name; // replace with real fields

  const {Entity}Entity({
    required this.id,
    required this.name,
  });

  @override
  String toString() => '{Entity}Entity(id: $id, name: $name)';

  @override
  List<Object?> get props => [id, name];
}
```

**DTO / params** (`domain/dtos/{action}_params.dart`) - mutable, setters, `empty()`, manual equality (matches `LoginParams`, not a `copyWith` style):

```dart
class {Action}Params {
  String field1;
  String field2;

  {Action}Params({
    required this.field1,
    required this.field2,
  });

  Map<String, dynamic> toJson() => {
        'field1': field1,
        'field2': field2,
      };

  void setField1(String value) => field1 = value;
  void setField2(String value) => field2 = value;

  static {Action}Params empty() => {Action}Params(field1: '', field2: '');

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is {Action}Params && other.field1 == field1 && other.field2 == field2;
  }

  @override
  int get hashCode => field1.hashCode ^ field2.hashCode;

  @override
  String toString() => '{Action}Params(field1: $field1, field2: $field2)';
}
```

**Repository interface** (`domain/repositories/{feature}_repository_interface.dart`):

```dart
import 'package:result_dart/result_dart.dart';
import '../entities/{name}_entity.dart';
import '../dtos/{action}_params.dart';

abstract interface class I{Feature}Repository {
  AsyncResult<{Entity}Entity> {action}({Action}Params params);
}
```

**Usecase** (`domain/usecases/{action}_usecase.dart`) - implements `UseCase<Output, Input>` from `lib/src/core/interfaces/usecase_interface.dart`; only add extra logic (like `LoginUsecase` saving the session) if the feature actually needs it:

```dart
import 'package:result_dart/result_dart.dart';
import '../../../../core/interfaces/usecase_interface.dart';
import '../entities/{name}_entity.dart';
import '../dtos/{action}_params.dart';
import '../repositories/{feature}_repository_interface.dart';

class {Action}Usecase implements UseCase<{Entity}Entity, {Action}Params> {
  final I{Feature}Repository _{feature}Repository;

  {Action}Usecase({required I{Feature}Repository {feature}Repository})
      : _{feature}Repository = {feature}Repository;

  @override
  AsyncResult<{Entity}Entity> call({Action}Params params) {
    return _{feature}Repository.{action}(params);
  }
}
```

**Validator** (`domain/validators/{action}_params_validators.dart`) - extends `LucidValidator`; reuse extensions from `lib/src/core/extensions/lucid_validator_extensions.dart` (e.g. `customValidPassword()`) instead of duplicating rules:

```dart
import 'package:lucid_validation/lucid_validation.dart';
import '../dtos/{action}_params.dart';

class {Action}ParamsValidators extends LucidValidator<{Action}Params> {
  {Action}ParamsValidators() {
    ruleFor((p) => p.field1, key: 'field1').notEmpty(message: 'Campo obrigatório');
  }
}
```

### 3. Data layer

**Model** (`data/models/{name}_model.dart`) - extends the entity, adds (de)serialization:

```dart
import 'dart:convert';
import '../../domain/entities/{name}_entity.dart';

class {Entity}Model extends {Entity}Entity {
  {Entity}Model({required super.id, required super.name});

  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  factory {Entity}Model.fromMap(Map<String, dynamic> map) {
    return {Entity}Model(id: map['id'] as String, name: map['name'] as String);
  }

  String toJson() => json.encode(toMap());

  factory {Entity}Model.fromJson(String source) =>
      {Entity}Model.fromMap(json.decode(source) as Map<String, dynamic>);
}
```

**Remote datasource** (`data/datasources/{feature}_remote_datasource.dart`) - only talks HTTP, returns the raw response, no error mapping:

```dart
import '../../../../core/client_http/client_http.dart';
import '../../domain/dtos/{action}_params.dart';

class {Feature}RemoteDatasource {
  final IRestClient _restClient;

  {Feature}RemoteDatasource({required IRestClient restClient}) : _restClient = restClient;

  Future<RestClientResponse> {action}({Action}Params params) {
    return _restClient.post(RestClientRequest(path: '/{feature}', data: params.toJson()));
  }
}
```

**Repository implementation** (`data/repositories/{feature}_repository_impl.dart`) - the only place that catches exceptions and maps them to `BaseException` subclasses (`lib/src/core/errors/`); follow `AuthRepositoryImpl`'s shape exactly, don't invent a different error-handling style:

```dart
import 'package:result_dart/result_dart.dart';
import '../../domain/dtos/{action}_params.dart';
import '../../domain/entities/{name}_entity.dart';
import '../../domain/repositories/{feature}_repository_interface.dart';
import '../datasources/{feature}_remote_datasource.dart';
import '../models/{name}_model.dart';
import '../../../../core/client_http/client_http.dart';
import '../../../../core/errors/errors.dart';

class {Feature}RepositoryImpl implements I{Feature}Repository {
  final {Feature}RemoteDatasource _{feature}RemoteDatasource;

  {Feature}RepositoryImpl({required {Feature}RemoteDatasource {feature}RemoteDatasource})
      : _{feature}RemoteDatasource = {feature}RemoteDatasource;

  @override
  AsyncResult<{Entity}Entity> {action}({Action}Params params) async {
    try {
      final response = await _{feature}RemoteDatasource.{action}(params);
      return Success({Entity}Model.fromMap(response.data as Map<String, dynamic>));
    } on RestClientException catch (e) {
      return Failure(DefaultException(message: e.message));
    } catch (e) {
      return Failure(DefaultException(message: 'Erro inesperado: ${e.toString()}'));
    }
  }
}
```

Add a specific `BaseException` subclass under `lib/src/core/errors/` (and export it from `errors.dart`) only if the feature needs to distinguish an error case the UI reacts to differently - don't create one speculatively.

### 4. Presentation layer

**Bloc** (`presentation/bloc/{feature}_bloc.dart` + `_event.dart` + `_state.dart` as `part of`) - chain `validate -> flatMap -> fold`, mirroring `AuthBloc`:

`{feature}_event.dart`:
```dart
part of '{feature}_bloc.dart';

abstract class {Feature}Event extends Equatable {
  const {Feature}Event();
  @override
  List<Object?> get props => [];
}

class {Feature}{Action}Requested extends {Feature}Event {
  final {Action}Params params;
  const {Feature}{Action}Requested({required this.params});
  @override
  List<Object?> get props => [params];
}
```

`{feature}_state.dart`:
```dart
part of '{feature}_bloc.dart';

abstract class {Feature}State extends Equatable {
  const {Feature}State();
  @override
  List<Object?> get props => [];
}

class {Feature}Initial extends {Feature}State {}
class {Feature}Loading extends {Feature}State {}

class {Feature}{Action}Success extends {Feature}State {
  final {Entity}Entity entity;
  const {Feature}{Action}Success(this.entity);
  @override
  List<Object?> get props => [entity];
}

class {Feature}{Action}Failure extends {Feature}State {
  final BaseException exception;
  const {Feature}{Action}Failure({required this.exception});
  @override
  List<Object?> get props => [exception];
}
```

`{feature}_bloc.dart`:
```dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_dart/result_dart.dart';
import '../../domain/dtos/{action}_params.dart';
import '../../domain/entities/{name}_entity.dart';
import '../../domain/usecases/{action}_usecase.dart';
import '../../domain/validators/{action}_params_validators.dart';
import '../../../../core/errors/errors.dart';

part '{feature}_event.dart';
part '{feature}_state.dart';

class {Feature}Bloc extends Bloc<{Feature}Event, {Feature}State> {
  final {Action}Usecase _{action}Usecase;

  {Feature}Bloc({required {Action}Usecase {action}Usecase})
      : _{action}Usecase = {action}Usecase,
        super({Feature}Initial()) {
    on<{Feature}{Action}Requested>((event, emit) async {
      emit({Feature}Loading());

      final validator = {Action}ParamsValidators();

      final newState = await validator
          .validateResult(event.params)
          .flatMap(_{action}Usecase.call)
          .fold({Feature}{Action}Success.new, (e) => {Feature}{Action}Failure(exception: e as BaseException));

      emit(newState);
    });
  }
}
```

**Page** (`presentation/pages/{name}_page.dart`) - `BlocListener` for side effects (snackbars/navigation via `router.go`), `BlocBuilder` for rebuilding; get the bloc from `injector<{Feature}Bloc>()`, mutate the mutable DTO directly in `onChanged` (see `LoginPage`) rather than calling `setState` for every keystroke.

### 5. Dependency injection

Add a `setup{Feature}Dependencies()` function to `lib/src/core/DI/dependency_injector.dart` and call it from `setupDependencyInjector()`, following the existing `registerFactory`/`registerLazySingleton` pattern for the datasource, repository, and bloc - see the `auth` block already in that file for the exact shape (including the `useMocks` branch if the feature should support a mock repository for now).

### 6. Tests

Mirror `test/unit/auth/` and `test/widget/auth/` for structure. At minimum:
- `test/unit/{feature}/domain/usecases/{action}_usecase_test.dart` - mock the repository interface with `mocktail` (`class Mock{Feature}Repository extends Mock implements I{Feature}Repository {}`), assert `Success`/`Failure` paths.
- `test/unit/{feature}/presentation/bloc/{feature}_bloc_test.dart` - use `bloc_test`'s `blocTest`, assert the `[Loading, Success]` / `[Loading, Failure]` state sequences.
- `test/unit/{feature}/data/repositories/{feature}_repository_impl_test.dart` - mock the datasource, assert HTTP errors map to the right `BaseException`.

### 7. Verify

```bash
flutter analyze
flutter test test/unit/{feature}/ test/widget/{feature}/
```
