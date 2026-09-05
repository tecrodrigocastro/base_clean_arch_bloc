# SOLID in This Codebase

Concrete, not theoretical - how each principle actually shows up here.

**Single Responsibility**
A datasource only makes HTTP calls; it doesn't parse business rules. A validator only validates. A usecase only orchestrates one action. If a class's steps have more than one reason to change independently, split it.

**Open/Closed**
New behavior is added by creating a new usecase/repository/bloc, not by piling `if`/`switch` branches for a new scenario into an existing one (see `AuthRepositoryImpl.login`'s status-code mapping for the shape to extend, not the shape to keep growing indefinitely).

**Liskov Substitution**
`{Entity}Model` extends `{Entity}Entity` and must be usable everywhere the entity is expected - no overridden field changes behavior in a way that breaks callers holding an `{Entity}Entity` reference. Any `I{Feature}Repository` implementation must satisfy the same contract (return `Success`/`Failure`, never throw) as every other implementation of that interface.

**Interface Segregation**
Repository interfaces are scoped per feature (`IAuthRepository`, not one giant `IRepository`). Don't add a method to an interface for a caller that could instead depend on a narrower interface.

**Dependency Inversion**
`presentation/` and `data/` depend on the abstract `I{Feature}Repository`, never on `{Feature}RepositoryImpl` directly. Wiring the concrete implementation to the interface happens in one place: `lib/src/core/DI/dependency_injector.dart` (get_it). This is also why `domain/` can have zero external dependencies - everything it needs from outer layers is expressed as an interface it defines and an outer layer implements.
