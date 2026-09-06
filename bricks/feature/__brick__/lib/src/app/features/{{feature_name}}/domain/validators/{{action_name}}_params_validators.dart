import 'package:lucid_validation/lucid_validation.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/dtos/{{action_name}}_params.dart';

class {{#pascalCase}}{{action_name}}{{/pascalCase}}ParamsValidators extends LucidValidator<{{#pascalCase}}{{action_name}}{{/pascalCase}}Params> {
  {{#pascalCase}}{{action_name}}{{/pascalCase}}ParamsValidators() {
{{#fields}}
{{#isString}}
    ruleFor((params) => params.{{name}}, key: '{{name}}').notEmpty(message: 'Campo {{name}} é obrigatório');
{{/isString}}
{{/fields}}
  }
}
