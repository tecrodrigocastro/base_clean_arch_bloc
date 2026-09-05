import 'package:base_clean_arch_bloc/src/core/errors/errors.dart';

class ServerException extends BaseException {
  final String error;

  ServerException({
    required super.message,
    required this.error,
    super.stackTracing,
  });
}
