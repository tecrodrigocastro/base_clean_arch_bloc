import 'package:result_dart/result_dart.dart';

/// `UseCase` é uma classe abstrata que define uma interface para um caso de uso.
/// Ela é genérica, o que significa que pode trabalhar com qualquer tipo de objeto (`Type` e `Params`).
abstract interface class UseCase<Type extends Object, Params> {
  /// O método `call` é uma operação assíncrona que recebe um parâmetro do tipo `Params`
  /// e retorna um objeto `Future<Either<Failure, Type>>`.
  ///
  /// `Future` é uma maneira de Dart lidar com operações assíncronas. Ele representa um valor potencial
  /// ou erro que estará disponível em algum momento no futuro.
  ///
  /// `Either` é um tipo que pode conter um valor de dois tipos possíveis. Neste caso, `Failure` ou `Type`.
  /// É comumente usado em programação funcional para lidar com operações que podem falhar.
  /// Aqui, `Failure` representa um erro, enquanto `Type` seria o tipo de resultado esperado se a operação for bem-sucedida.
  AsyncResult<Type> call(Params params);
}

class NoParams {}
