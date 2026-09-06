import 'package:result_dart/result_dart.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/data/datasources/{{feature_name}}_remote_datasource.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/data/models/{{entity_name}}_model.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/dtos/{{action_name}}_params.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/entities/{{entity_name}}_entity.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/repositories/{{feature_name}}_repository_interface.dart';
import 'package:{{package_name}}/src/core/client_http/client_http.dart';
import 'package:{{package_name}}/src/core/errors/errors.dart';

class {{#pascalCase}}{{feature_name}}{{/pascalCase}}RepositoryImpl implements I{{#pascalCase}}{{feature_name}}{{/pascalCase}}Repository {
  final {{#pascalCase}}{{feature_name}}{{/pascalCase}}RemoteDatasource _{{#camelCase}}{{feature_name}}{{/camelCase}}RemoteDatasource;

  {{#pascalCase}}{{feature_name}}{{/pascalCase}}RepositoryImpl({required {{#pascalCase}}{{feature_name}}{{/pascalCase}}RemoteDatasource {{#camelCase}}{{feature_name}}{{/camelCase}}RemoteDatasource})
      : _{{#camelCase}}{{feature_name}}{{/camelCase}}RemoteDatasource = {{#camelCase}}{{feature_name}}{{/camelCase}}RemoteDatasource;

  @override
  AsyncResult<{{#pascalCase}}{{entity_name}}{{/pascalCase}}Entity> {{#camelCase}}{{action_name}}{{/camelCase}}({{#pascalCase}}{{action_name}}{{/pascalCase}}Params params) async {
    try {
      final response = await _{{#camelCase}}{{feature_name}}{{/camelCase}}RemoteDatasource.{{#camelCase}}{{action_name}}{{/camelCase}}(params);
      return Success({{#pascalCase}}{{entity_name}}{{/pascalCase}}Model.fromMap(response.data as Map<String, dynamic>));
    } on RestClientException catch (e) {
      return Failure(DefaultException(message: e.message));
    } catch (e) {
      return Failure(DefaultException(message: 'Erro inesperado: ${e.toString()}'));
    }
  }
}
