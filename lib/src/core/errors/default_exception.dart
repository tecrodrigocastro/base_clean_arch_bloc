import 'base_exception.dart';

class DefaultException extends BaseException {
  const DefaultException({
    required super.message,
    super.data,
    super.statusCode,
    super.stackTracing,
  });
}
