import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/dtos/{{action_name}}_params.dart';
import 'package:{{package_name}}/src/core/client_http/client_http.dart';

class {{#pascalCase}}{{feature_name}}{{/pascalCase}}RemoteDatasource {
  final IRestClient _restClient;

  {{#pascalCase}}{{feature_name}}{{/pascalCase}}RemoteDatasource({required IRestClient restClient}) : _restClient = restClient;

  Future<RestClientResponse> {{#camelCase}}{{action_name}}{{/camelCase}}({{#pascalCase}}{{action_name}}{{/pascalCase}}Params params) {
    return _restClient.post(
      RestClientRequest(
        path: '/{{#snakeCase}}{{feature_name}}{{/snakeCase}}',
        data: params.toJson(),
      ),
    );
  }
}
