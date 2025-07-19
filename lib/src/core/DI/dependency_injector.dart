import 'package:base_clean_arch_bloc/src/core/client_http/dio/rest_client_dio_impl.dart';
import 'package:base_clean_arch_bloc/src/core/client_http/logger/client_interceptor_logger_impl.dart';
import 'package:get_it/get_it.dart';

final injector = GetIt.instance;

void setupDependencyInjector({bool loggerApi = false}) {
  injector.registerFactory<RestClientDioImpl>(() {
    final instance = RestClientDioImpl(
      dio: DioFactory.dio(),
    );

    if (loggerApi) {
      instance.addInterceptors(ClientInterceptorLoggerImpl());
    }

    return instance;
  });
}
