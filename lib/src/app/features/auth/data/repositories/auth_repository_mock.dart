import 'package:base_clean_arch_bloc/src/app/features/auth/domain/dtos/login_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/entities/user_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/core/errors/errors.dart';
import 'package:result_dart/result_dart.dart';

/// Mock de [IAuthRepository] para uso em desenvolvimento e testes de UI.
///
/// Credenciais válidas:
/// - Email: `teste@teste.com`
/// - Senha: `123456Aa!`
///
/// Qualquer outra combinação retorna [DefaultException] com mensagem "Credenciais inválidas".
class AuthRepositoryMock implements IAuthRepository {
  static const _validEmail = 'teste@teste.com';
  static const _validPassword = '123456Aa!';

  @override
  AsyncResult<AuthResponseEntity> login(LoginParams params) async {
    await Future.delayed(const Duration(milliseconds: 500)); // simula latência

    if (params.email == _validEmail && params.password == _validPassword) {
      return const Success(
        AuthResponseEntity(
          token: 'mock-token-abc123',
          user: UserEntity(
            id: '1',
            email: _validEmail,
            name: 'Usuário Teste',
          ),
        ),
      );
    }

    return const Failure(DefaultException(message: 'Credenciais inválidas'));
  }
}
