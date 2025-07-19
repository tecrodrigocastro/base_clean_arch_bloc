import 'package:base_clean_arch_bloc/src/core/errors/credentials_validation_exception.dart';
import 'package:lucid_validation/lucid_validation.dart';
import 'package:result_dart/result_dart.dart';

extension LucidValidatorExtensions<T extends Object> on LucidValidator<T> {
  AsyncResult<T> validateResult(T object) async {
    final result = validate(object);
    if (result.isValid) {
      return Success(object);
    }

    return Failure(
      CredentialsValidationException(message: result.exceptions.first.message),
    );
  }
}

extension CustomValidPasswordValidator on SimpleValidationBuilder<String> {
  SimpleValidationBuilder<String> customValidPassword() {
    return notEmpty(message: 'O campo senha é obrigatório')
        .minLength(8, message: 'A senha deve ter no mínimo 8 caracteres')
        .mustHaveLowercase(message: 'A senha deve ter no mínimo uma letra minúscula')
        .mustHaveUppercase(message: 'A senha deve ter no mínimo uma letra maiúscula')
        .mustHaveNumber(message: 'A senha deve ter no mínimo um número')
        .mustHaveSpecialCharacter(message: 'A senha deve ter no mínimo um caractere especial');
  }
}
