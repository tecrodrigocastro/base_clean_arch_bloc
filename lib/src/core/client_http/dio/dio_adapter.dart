import 'package:base_clean_arch_bloc/src/core/client_http/client_http.dart';
import 'package:dio/dio.dart';

class DioAdapter {
  static RestClientException toClientException(DioException dioException) {
    return RestClientException(
      error: dioException.error,
      message: dioException.message ?? '',
      data: dioException.response?.data ?? {},
      response: dioException.response == null ? null : toClientResponse(dioException.response!),
      statusCode: dioException.response?.statusCode,
    );
  }

  static DioException toDioException(RestClientException restClientException) {
    return DioException(
      requestOptions: RequestOptions(),
      error: restClientException.error,
      message: restClientException.message,
      response: restClientException.response == null ? null : toResponse(restClientException.response!),
    );
  }

  static RestClientRequest toClientRequest(RequestOptions request) {
    return RestClientRequest(
      path: request.path,
      method: request.method,
      headers: request.headers,
      queryParameters: request.queryParameters,
      data: request.data,
      baseUrl: request.baseUrl,
    );
  }

  static RequestOptions toRequestOptions(RestClientRequest restClientRequest) {
    return RequestOptions(
      path: restClientRequest.path,
      data: restClientRequest.data,
      method: restClientRequest.method,
      queryParameters: restClientRequest.queryParameters,
      headers: restClientRequest.headers,
      baseUrl: restClientRequest.baseUrl,
    );
  }

  static RestClientResponse toClientResponse(Response response) {
    return RestClientResponse(
      request: toClientRequest(response.requestOptions),
      message: response.statusMessage,
      data: response.data,
      statusCode: response.statusCode,
    );
  }

  static Response toResponse(RestClientResponse restClientResponse) {
    final headers = restClientResponse.request.headers ?? {};
    final dioHeaders = <String, List<String>>{};

    for (var key in headers.keys) {
      dioHeaders[key] = [headers[key]];
    }

    return Response(
      requestOptions: toRequestOptions(restClientResponse.request),
      data: restClientResponse.data,
      headers: Headers.fromMap(dioHeaders),
      statusCode: restClientResponse.statusCode,
      statusMessage: restClientResponse.message,
    );
  }
}
