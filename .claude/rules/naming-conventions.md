# Naming Conventions

Match these exactly - they're taken from the `auth` feature, which is the reference implementation for everything else in this template.

| Kind | File name | Class name | Example |
|---|---|---|---|
| Entity | `{entity}_entity.dart` | `{Entity}Entity` | `user_entity.dart` -> `UserEntity` |
| DTO / params | `{action}_params.dart` | `{Action}Params` | `login_params.dart` -> `LoginParams` |
| Repository interface | `{feature}_repository_interface.dart` | `I{Feature}Repository` | `auth_repository_interface.dart` -> `IAuthRepository` |
| Repository impl | `{feature}_repository_impl.dart` | `{Feature}RepositoryImpl` | `auth_repository_impl.dart` -> `AuthRepositoryImpl` |
| Usecase | `{action}_usecase.dart` | `{Action}Usecase` | `login_usecase.dart` -> `LoginUsecase` |
| Validator | `{params}_validators.dart` | `{Params}Validators` | `login_params_validators.dart` -> `LoginParamsValidators` |
| Model | `{entity}_model.dart` | `{Entity}Model` (extends `{Entity}Entity`) | `user_model.dart` -> `UserModel` |
| Remote datasource | `{feature}_remote_datasource.dart` | `{Feature}RemoteDatasource` | `auth_remote_datasource.dart` -> `AuthRemoteDatasource` |
| Local datasource | `{feature}_local_datasource.dart` | `{Feature}LocalDatasource` | |
| Bloc | `{feature}_bloc.dart` | `{Feature}Bloc` | `auth_bloc.dart` -> `AuthBloc` |
| Bloc events | `{feature}_event.dart` (`part of`) | `{Feature}{Action}Requested` | `AuthLoginRequested` |
| Bloc states | `{feature}_state.dart` (`part of`) | `{Feature}{Status}` | `AuthLoading`, `AuthLoginSuccess`, `AuthFailure` |
| Page | `{page}_page.dart` | `{Page}Page` | `login_page.dart` -> `LoginPage` |
| Widget | `{component}_widget.dart` | `{Component}Widget` | |

## Class modifiers

- Everything is a plain `class` (entities, DTOs, models, repository impls, usecases, blocs, events, states) - this codebase does not use `final class`, even for types nothing currently extends.
- Repository interfaces are the one exception: `abstract interface class I{Feature}Repository`.
- Events/states base classes are `abstract class` (`AuthEvent`, `AuthState`); concrete subclasses are plain `class`.
- Prefer `const` constructors wherever the fields allow it, but don't force it where the existing feature doesn't (e.g. `LoginUsecase`'s constructor isn't `const`).

## Tests

Mirror the `lib/` path under `test/unit/` or `test/widget/`:

```
lib/src/app/features/auth/domain/usecases/login_usecase.dart
test/unit/auth/domain/usecases/login_usecase_test.dart
```

Mock classes: `Mock{ClassName}` using `mocktail` (`class MockAuthRepository extends Mock implements IAuthRepository {}`). BLoC tests use `bloc_test`'s `blocTest`.
