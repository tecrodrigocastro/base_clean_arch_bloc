import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import '../client_http.dart';

const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

class ClientInterceptorLoggerImpl implements IClientInterceptor {
  @override
  FutureOr<RestClientHttpMessage> onError(RestClientException err) {
    final loggerString = <String>[
      '\n🛑 [ERROR] ${err.statusCode}',
      '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
      if (err.response != null)
        '🔹 Request: ${err.response?.request.method.toUpperCase()} ${_formatUrl(err.response!.request)}',
      if (err.response != null &&
          err.response!.request.queryParameters!.isNotEmpty)
        '🔹 Query: ${prettyJson(err.response!.request.queryParameters!)}',
      if (err.response != null && err.response!.request.headers!.isNotEmpty)
        '🔹 Headers: ${prettyJson(err.response!.request.headers!)}',
      '🔹 Response Status Code: ${err.response?.statusCode}',
      if (err.message.isNotEmpty) '🔹 Message Error: ${err.message}',
      if (err.response != null && err.response!.message!.isNotEmpty)
        '🔹 Response Message: ${err.response!.message}',
      if (err.response?.data != null)
        '🔹 Response Data: ${prettyJson(err.response?.data)}',
      '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
    ].join('\n');

    log(loggerString);
    return err;
  }

  @override
  FutureOr<RestClientHttpMessage> onRequest(RestClientRequest request) {
    final loggerString = [
      '\n📤 [REQUEST]',
      '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
      '🔹 ${request.method.toUpperCase()} ${_formatUrl(request)}',
      if (request.queryParameters!.isNotEmpty)
        '🔹 Query: ${prettyJson(request.queryParameters!)}',
      if (request.headers!.isNotEmpty)
        '🔹 Headers: ${prettyJson(request.headers!)}',
      if (request.data != null) '🔹 Body: ${prettyJson(request.data)}',
      '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
    ].join('\n');

    log(loggerString);
    return request;
  }

  @override
  FutureOr<RestClientHttpMessage> onResponse(RestClientResponse response) {
    final loggerString = [
      '\n📥 [RESPONSE] Status ${response.statusCode}',
      '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
      '🔹 ${response.request.method.toUpperCase()} ${_formatUrl(response.request)}',
      '🔹 Status Code: ${response.statusCode}',
      if (response.data != null) '🔹 Body: ${prettyJson(response.data)}',
      '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
    ].join('\n');

    log(loggerString);
    return response;
  }

  Object? prettyJson(Object? data) {
    try {
      return _encoder.convert(data);
    } catch (_) {
      return data;
    }
  }

  String _formatUrl(RestClientRequest request) {
    String baseUrl = request.baseUrl;
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }
    return '$baseUrl${request.path}';
  }
}
