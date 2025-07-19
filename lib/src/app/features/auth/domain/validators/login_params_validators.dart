import 'package:base_clean_arch_bloc/src/app/features/auth/domain/dtos/login_params.dart';
import 'package:base_clean_arch_bloc/src/core/extensions/lucid_validator_extensions.dart';
import 'package:lucid_validation/lucid_validation.dart';

class LoginParamsValidators extends LucidValidator<LoginParams> {
  LoginParamsValidators() {
    ruleFor((params) => params.email, key: 'email') //
        .notEmpty(message: 'Email não pode ser vazio')
        .validEmail(message: 'Email inválido');
    ruleFor((params) => params.password, key: 'password') //
        .customValidPassword();
  }
}
