import 'package:result_dart/result_dart.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/dtos/{{action_name}}_params.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/entities/{{entity_name}}_entity.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/repositories/{{feature_name}}_repository_interface.dart';
import 'package:{{package_name}}/src/core/interfaces/usecase_interface.dart';

class {{#pascalCase}}{{action_name}}{{/pascalCase}}Usecase implements UseCase<{{#pascalCase}}{{entity_name}}{{/pascalCase}}Entity, {{#pascalCase}}{{action_name}}{{/pascalCase}}Params> {
  final I{{#pascalCase}}{{feature_name}}{{/pascalCase}}Repository _{{#camelCase}}{{feature_name}}{{/camelCase}}Repository;

  {{#pascalCase}}{{action_name}}{{/pascalCase}}Usecase({required I{{#pascalCase}}{{feature_name}}{{/pascalCase}}Repository {{#camelCase}}{{feature_name}}{{/camelCase}}Repository})
      : _{{#camelCase}}{{feature_name}}{{/camelCase}}Repository = {{#camelCase}}{{feature_name}}{{/camelCase}}Repository;

  @override
  AsyncResult<{{#pascalCase}}{{entity_name}}{{/pascalCase}}Entity> call({{#pascalCase}}{{action_name}}{{/pascalCase}}Params params) {
    return _{{#camelCase}}{{feature_name}}{{/camelCase}}Repository.{{#camelCase}}{{action_name}}{{/camelCase}}(params);
  }
}
