import 'package:{{package_name}}/src/app/features/{{feature_name}}/data/datasources/{{feature_name}}_remote_datasource.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/dtos/{{action_name}}_params.dart';
import 'package:{{package_name}}/src/core/client_http/rest_client_interface.dart';
import 'package:{{package_name}}/src/core/client_http/rest_client_request.dart';
import 'package:{{package_name}}/src/core/client_http/rest_client_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRestClient extends Mock implements IRestClient {}

void main() {
  group('{{#pascalCase}}{{feature_name}}{{/pascalCase}}RemoteDatasource', () {
    late {{#pascalCase}}{{feature_name}}{{/pascalCase}}RemoteDatasource datasource;
    late MockRestClient mockRestClient;

    setUpAll(() {
      registerFallbackValue(RestClientRequest(path: ''));
    });

    setUp(() {
      mockRestClient = MockRestClient();
      datasource = {{#pascalCase}}{{feature_name}}{{/pascalCase}}RemoteDatasource(restClient: mockRestClient);
    });

    final params = {{#pascalCase}}{{action_name}}{{/pascalCase}}Params(
{{#fields}}
      {{name}}: {{{sampleValue}}},
{{/fields}}
    );

    final response = RestClientResponse(
      data: <String, dynamic>{},
      statusCode: 200,
      message: 'OK',
      request: RestClientRequest(path: '/{{#snakeCase}}{{feature_name}}{{/snakeCase}}'),
    );

    test('should call rest client with correct parameters', () async {
      when(() => mockRestClient.post(any())).thenAnswer((_) async => response);

      await datasource.{{#camelCase}}{{action_name}}{{/camelCase}}(params);

      final captured = verify(() => mockRestClient.post(captureAny())).captured;
      final request = captured.first as RestClientRequest;

      expect(request.path, equals('/{{#snakeCase}}{{feature_name}}{{/snakeCase}}'));
      expect(request.data, equals(params.toJson()));
    });
  });
}
