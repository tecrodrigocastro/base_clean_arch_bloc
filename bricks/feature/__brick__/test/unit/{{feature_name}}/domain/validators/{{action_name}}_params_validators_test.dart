import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/dtos/{{action_name}}_params.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/validators/{{action_name}}_params_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('{{#pascalCase}}{{action_name}}{{/pascalCase}}ParamsValidators', () {
    late {{#pascalCase}}{{action_name}}{{/pascalCase}}ParamsValidators validator;

    setUp(() {
      validator = {{#pascalCase}}{{action_name}}{{/pascalCase}}ParamsValidators();
    });

    test('should return invalid when required fields are empty', () {
      final params = {{#pascalCase}}{{action_name}}{{/pascalCase}}Params.empty();

      final result = validator.validate(params);

      expect(result.isValid, isFalse);
    });

    test('should return valid when all fields are filled', () {
      final params = {{#pascalCase}}{{action_name}}{{/pascalCase}}Params(
{{#fields}}
        {{name}}: {{{sampleValue}}},
{{/fields}}
      );

      final result = validator.validate(params);

      expect(result.isValid, isTrue);
    });
  });
}
