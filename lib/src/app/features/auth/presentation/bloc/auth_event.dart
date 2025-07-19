part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final LoginParams params;

  const AuthLoginRequested({
    required this.params,
  });

  @override
  List<Object> get props => [params];
}
