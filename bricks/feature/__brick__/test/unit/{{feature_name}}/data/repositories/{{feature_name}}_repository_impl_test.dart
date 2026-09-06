import 'package:{{package_name}}/src/app/features/{{feature_name}}/data/datasources/{{feature_name}}_remote_datasource.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/data/repositories/{{feature_name}}_repository_impl.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/dtos/{{action_name}}_params.dart';
import 'package:{{package_name}}/src/core/client_http/rest_client_exception.dart';
import 'package:{{package_name}}/src/core/client_http/rest_client_request.dart';
import 'package:{{package_name}}/src/core/client_http/rest_client_response.dart';
import 'package:{{package_name}}/src/core/errors/default_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class Mock{{#pascalCase}}{{feature_name}}{{/pascalCase}}RemoteDatasource extends Mock implements {{#pascalCase}}{{feature_name}}{{/pascalCase}}RemoteDatasource {}

void main() {
  group('{{#pascalCase}}{{feature_name}}{{/pascalCase}}RepositoryImpl', () {
    late {{#pascalCase}}{{feature_name}}{{/pascalCase}}RepositoryImpl repository;
    late Mock{{#pascalCase}}{{feature_name}}{{/pascalCase}}RemoteDatasource mockDatasource;

    setUpAll(() {
      registerFallbackValue({{#pascalCase}}{{action_name}}{{/pascalCase}}Params.empty());
    });

    setUp(() {
      mockDatasource = Mock{{#pascalCase}}{{feature_name}}{{/pascalCase}}RemoteDatasource();
      repository = {{#pascalCase}}{{feature_name}}{{/pascalCase}}RepositoryImpl({{#camelCase}}{{feature_name}}{{/camelCase}}RemoteDatasource: mockDatasource);
    });

    final params = {{#pascalCase}}{{action_name}}{{/pascalCase}}Params(
{{#fields}}
      {{name}}: {{{sampleValue}}},
{{/fields}}
    );

    test('should return Success when datasource call succeeds', () async {
      final response = RestClientResponse(
        data: <String, dynamic>{
{{#fields}}
          '{{name}}': {{{sampleValue}}},
{{/fields}}
        },
        statusCode: 200,
        message: 'OK',
        request: RestClientRequest(path: '/{{#snakeCase}}{{feature_name}}{{/snakeCase}}'),
      );

      when(() => mockDatasource.{{#camelCase}}{{action_name}}{{/camelCase}}(params)).thenAnswer((_) async => response);

      final result = await repository.{{#camelCase}}{{action_name}}{{/camelCase}}(params);

      expect(result.isSuccess(), isTrue);
    });

    test('should return Failure when datasource throws RestClientException', () async {
      when(() => mockDatasource.{{#camelCase}}{{action_name}}{{/camelCase}}(params)).thenThrow(
        RestClientException(message: 'Request failed', statusCode: 500, error: 'Internal server error'),
      );

      final result = await repository.{{#camelCase}}{{action_name}}{{/camelCase}}(params);

      expect(result.isError(), isTrue);
      expect(result.exceptionOrNull(), isA<DefaultException>());
    });
  });
}
