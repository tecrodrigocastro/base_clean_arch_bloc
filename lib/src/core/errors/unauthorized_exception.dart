import 'package:base_clean_arch_bloc/src/core/errors/base_exception.dart';

class UnauthorizedException extends BaseException {
  UnauthorizedException({
    required super.message,
  });
}
