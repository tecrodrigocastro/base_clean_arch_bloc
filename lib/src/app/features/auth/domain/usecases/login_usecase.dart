import 'package:base_clean_arch_bloc/src/app/features/auth/domain/dtos/login_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/core/interfaces/usecase_interface.dart';
import 'package:base_clean_arch_bloc/src/core/services/session_service.dart';
import 'package:result_dart/result_dart.dart';

class LoginUsecase implements UseCase<AuthResponseEntity, LoginParams> {
  final IAuthRepository _authRepository;
  final SessionService _sessionService;

  LoginUsecase({required IAuthRepository authRepository, required SessionService sessionService})
      : _authRepository = authRepository,
        _sessionService = sessionService;

  @override
  AsyncResult<AuthResponseEntity> call(LoginParams params) async {
    final result = await _authRepository.login(params);

    final response = result.getOrNull();
    if (response != null) {
      await _sessionService.saveSession(response.token);
    }

    return result;
  }
}
