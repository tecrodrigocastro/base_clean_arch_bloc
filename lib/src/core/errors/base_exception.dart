abstract class BaseException implements Exception {
  const BaseException({
    required this.message,
    this.data,
    this.statusCode,
    this.stackTracing,
  });

  final dynamic data;
  final String message;
  final int? statusCode;
  final dynamic stackTracing;
}
