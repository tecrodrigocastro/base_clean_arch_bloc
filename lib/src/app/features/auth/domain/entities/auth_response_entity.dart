import 'package:base_clean_arch_bloc/src/app/features/auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

class AuthResponseEntity extends Equatable {
  final UserEntity user;
  final String token;

  const AuthResponseEntity({
    required this.user,
    required this.token,
  });

  @override
  String toString() {
    return 'AuthResponseEntity(user: $user, token: $token)';
  }

  @override
  List<Object?> get props => [user, token];
}
