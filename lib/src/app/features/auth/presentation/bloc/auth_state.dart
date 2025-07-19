part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {
  final AuthResponseEntity authResponse;

  const AuthLoginSuccess(this.authResponse);

  @override
  List<Object> get props => [authResponse];
}

class AuthLoginFailure extends AuthState {
  final BaseException exception;

  const AuthLoginFailure({required this.exception});

  @override
  List<Object> get props => [exception];
}
