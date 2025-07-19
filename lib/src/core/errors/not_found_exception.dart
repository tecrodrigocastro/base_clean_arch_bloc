import 'package:base_clean_arch_bloc/src/core/errors/errors.dart';

class NotFoundException extends BaseException {
  NotFoundException({
    required super.message,
    super.statusCode = 404,
  });
}
