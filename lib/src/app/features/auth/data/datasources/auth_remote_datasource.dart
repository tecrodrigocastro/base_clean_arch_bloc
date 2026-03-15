import 'package:base_clean_arch_bloc/src/app/features/auth/domain/dtos/login_params.dart';
import 'package:base_clean_arch_bloc/src/core/client_http/client_http.dart';
import 'package:base_clean_arch_bloc/src/core/utils/endpoints.dart';

class AuthRemoteDatasource {
  final IRestClient _restClient;

  AuthRemoteDatasource({required IRestClient restClient}) : _restClient = restClient;

  Future<RestClientResponse> login(LoginParams params) => //
      _restClient.post(
        RestClientRequest(
          path: Endpoints.login,
          data: params.toJson(),
        ),
      );
}
