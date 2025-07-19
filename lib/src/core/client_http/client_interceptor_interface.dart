import 'dart:async';

import 'package:base_clean_arch_bloc/src/core/client_http/client_http.dart';

abstract interface class IClientInterceptor {
  FutureOr<RestClientHttpMessage> onResponse(RestClientResponse response);
  FutureOr<RestClientHttpMessage> onRequest(RestClientRequest request);
  FutureOr<RestClientHttpMessage> onError(RestClientException error);
}
