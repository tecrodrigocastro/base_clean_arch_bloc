import 'dart:async';

import 'package:base_clean_arch_bloc/src/core/client_http/client_http.dart';
import 'package:base_clean_arch_bloc/src/core/services/session_service.dart';
import 'package:result_dart/result_dart.dart';

class AuthInterceptor implements IClientInterceptor {
  final SessionService _sessionService;

  AuthInterceptor({
    required SessionService sessionService,
  }) : _sessionService = sessionService;

  @override
  FutureOr<RestClientHttpMessage> onError(RestClientException error) async {
    return error;
  }

  @override
  FutureOr<RestClientHttpMessage> onRequest(RestClientRequest request) async {
    final token = await _sessionService.getToken();

    if (token != null && token.isNotEmpty) {
      return Success(token) //
          .map((token) => 'Bearer $token')
          .map((str) => request..headers?.addAll({'Authorization': str}))
          .getOrDefault(request);
    }

    return request;
  }

  @override
  FutureOr<RestClientHttpMessage> onResponse(RestClientResponse response) {
    return response;
  }
}
