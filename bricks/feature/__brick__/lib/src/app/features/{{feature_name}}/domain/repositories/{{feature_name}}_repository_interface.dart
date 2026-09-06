import 'package:result_dart/result_dart.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/dtos/{{action_name}}_params.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/entities/{{entity_name}}_entity.dart';

abstract interface class I{{#pascalCase}}{{feature_name}}{{/pascalCase}}Repository {
  AsyncResult<{{#pascalCase}}{{entity_name}}{{/pascalCase}}Entity> {{#camelCase}}{{action_name}}{{/camelCase}}({{#pascalCase}}{{action_name}}{{/pascalCase}}Params params);
}
