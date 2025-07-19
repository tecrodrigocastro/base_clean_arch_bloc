import 'package:base_clean_arch_bloc/src/app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/usecases/login_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/infrastructure/auth_interceptor.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:base_clean_arch_bloc/src/core/cache/shared_preferences/shared_preferences_impl.dart';
import 'package:base_clean_arch_bloc/src/core/client_http/dio/rest_client_dio_impl.dart';
import 'package:base_clean_arch_bloc/src/core/client_http/logger/client_interceptor_logger_impl.dart';
import 'package:base_clean_arch_bloc/src/core/services/session_service.dart';
import 'package:get_it/get_it.dart';

final injector = GetIt.instance;

void setupDependencyInjector({bool loggerApi = false}) {
  injector.registerFactory<RestClientDioImpl>(() {
    final instance = RestClientDioImpl(
      dio: DioFactory.dio(),
    );

    instance.addInterceptors(AuthInterceptor(
      sessionService: injector<SessionService>(),
    ));

    if (loggerApi) {
      instance.addInterceptors(ClientInterceptorLoggerImpl());
    }

    return instance;
  });

  injector.registerLazySingleton<SessionService>(() {
    return SessionService(
      sharedPreferencesImpl: SharedPreferencesImpl(),
    );
  });

  injector.registerLazySingleton<AuthRemoteDatasource>(() {
    return AuthRemoteDatasource(
      restClient: injector<RestClientDioImpl>(),
    );
  });

  injector.registerLazySingleton<IAuthRepository>(() => AuthRepositoryImpl(authRemoteDatasource: injector<AuthRemoteDatasource>()));

  injector.registerLazySingleton(() => AuthBloc(loginUsecase: LoginUsecase(authRepository: injector<IAuthRepository>())));
}
