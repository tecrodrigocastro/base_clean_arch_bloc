import 'package:base_clean_arch_bloc/src/app/features/auth/domain/dtos/login_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class IAuthRepository {
  AsyncResult<AuthResponseEntity> login(LoginParams login);
}
