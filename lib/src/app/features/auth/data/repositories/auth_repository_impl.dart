import 'package:base_clean_arch_bloc/src/app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/data/models/auth_response_model.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/dtos/login_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/core/client_http/client_http.dart';
import 'package:base_clean_arch_bloc/src/core/errors/errors.dart';
import 'package:base_clean_arch_bloc/src/core/errors/unauthorized_exception.dart';
import 'package:result_dart/result_dart.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteDatasource _authRemoteDatasource;

  AuthRepositoryImpl({required AuthRemoteDatasource authRemoteDatasource}) : _authRemoteDatasource = authRemoteDatasource;

  @override
  AsyncResult<AuthResponseEntity> login(LoginParams params) async {
    try {
      final response = await _authRemoteDatasource.login(params);
      final authResponse = AuthResponseModel.fromMap(response.data as Map<String, dynamic>);
      return Success(authResponse);
    } on RestClientException catch (e) {
      if (e.statusCode == 401) {
        return Failure(UnauthorizedException(message: e.message));
      }
      return Failure(DefaultException(message: e.message));
    } catch (e) {
      return Failure(DefaultException(message: 'Erro inesperado: ${e.toString()}'));
    }
  }
}
