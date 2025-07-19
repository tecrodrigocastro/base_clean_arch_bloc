import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/usecases/login_usecase.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/dtos/login_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/entities/user_entity.dart';
import 'package:base_clean_arch_bloc/src/core/errors/default_exception.dart';
import 'package:base_clean_arch_bloc/src/core/errors/unauthorized_exception.dart';
import 'package:base_clean_arch_bloc/src/core/errors/credentials_validation_exception.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockLoginUsecase mockLoginUsecase;

    setUpAll(() {
      registerFallbackValue(LoginParams(email: '', password: ''));
    });

    setUp(() {
      mockLoginUsecase = MockLoginUsecase();
      authBloc = AuthBloc(loginUsecase: mockLoginUsecase);
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state is AuthInitial', () {
      expect(authBloc.state, equals(AuthInitial()));
    });

    group('AuthLoginRequested', () {
      final loginParams = LoginParams(
        email: 'test@example.com',
        password: 'Password123!',
      );

      final user = UserEntity(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      final authResponse = AuthResponseEntity(
        user: user,
        token: 'test_token_123',
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthLoginSuccess] when login succeeds',
        build: () {
          when(() => mockLoginUsecase.call(any()))
              .thenAnswer((_) async => Success(authResponse));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthLoginRequested(params: loginParams)),
        expect: () => [
          AuthLoading(),
          AuthLoginSuccess(authResponse),
        ],
        verify: (_) {
          verify(() => mockLoginUsecase.call(loginParams)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthLoginFailure] when login fails with DefaultException',
        build: () {
          final exception = DefaultException(message: 'Login failed');
          when(() => mockLoginUsecase.call(any()))
              .thenAnswer((_) async => Failure(exception));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthLoginRequested(params: loginParams)),
        expect: () => [
          AuthLoading(),
          isA<AuthLoginFailure>().having(
            (state) => state.exception.message,
            'exception message',
            equals('Login failed'),
          ),
        ],
        verify: (_) {
          verify(() => mockLoginUsecase.call(loginParams)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthLoginFailure] when login fails with UnauthorizedException',
        build: () {
          final exception = UnauthorizedException(message: 'Invalid credentials');
          when(() => mockLoginUsecase.call(any()))
              .thenAnswer((_) async => Failure(exception));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthLoginRequested(params: loginParams)),
        expect: () => [
          AuthLoading(),
          isA<AuthLoginFailure>().having(
            (state) => state.exception,
            'exception type',
            isA<UnauthorizedException>(),
          ),
        ],
        verify: (_) {
          verify(() => mockLoginUsecase.call(loginParams)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthLoginFailure] when validation fails',
        build: () {
          final exception = CredentialsValidationException(message: 'Invalid email');
          when(() => mockLoginUsecase.call(any()))
              .thenAnswer((_) async => Failure(exception));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthLoginRequested(params: loginParams)),
        expect: () => [
          AuthLoading(),
          isA<AuthLoginFailure>().having(
            (state) => state.exception,
            'exception type',
            isA<CredentialsValidationException>(),
          ),
        ],
        verify: (_) {
          verify(() => mockLoginUsecase.call(loginParams)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'calls usecase with correct parameters',
        build: () {
          when(() => mockLoginUsecase.call(any()))
              .thenAnswer((_) async => Success(authResponse));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthLoginRequested(params: loginParams)),
        verify: (_) {
          final captured = verify(() => mockLoginUsecase.call(captureAny())).captured;
          final capturedParams = captured.first as LoginParams;
          expect(capturedParams.email, equals(loginParams.email));
          expect(capturedParams.password, equals(loginParams.password));
        },
      );

      blocTest<AuthBloc, AuthState>(
        'handles multiple login requests correctly',
        build: () {
          when(() => mockLoginUsecase.call(any()))
              .thenAnswer((_) async => Success(authResponse));
          return authBloc;
        },
        act: (bloc) async {
          bloc.add(AuthLoginRequested(params: loginParams));
          await Future.delayed(const Duration(milliseconds: 100));
          bloc.add(AuthLoginRequested(params: loginParams));
        },
        expect: () => [
          AuthLoading(),
          AuthLoginSuccess(authResponse),
          AuthLoading(),
          AuthLoginSuccess(authResponse),
        ],
        verify: (_) {
          verify(() => mockLoginUsecase.call(loginParams)).called(2);
        },
      );

      group('validation integration', () {
        blocTest<AuthBloc, AuthState>(
          'emits failure when email is invalid',
          build: () {
            final invalidParams = LoginParams(
              email: 'invalid-email',
              password: 'Password123!',
            );
            final exception = CredentialsValidationException(message: 'Email inválido');
            when(() => mockLoginUsecase.call(any()))
                .thenAnswer((_) async => Failure(exception));
            return authBloc;
          },
          act: (bloc) => bloc.add(AuthLoginRequested(
            params: LoginParams(
              email: 'invalid-email',
              password: 'Password123!',
            ),
          )),
          expect: () => [
            AuthLoading(),
            isA<AuthLoginFailure>().having(
              (state) => state.exception,
              'exception type',
              isA<CredentialsValidationException>(),
            ),
          ],
        );

        blocTest<AuthBloc, AuthState>(
          'emits failure when password is invalid',
          build: () {
            final invalidParams = LoginParams(
              email: 'test@example.com',
              password: '123',
            );
            final exception = CredentialsValidationException(message: 'Senha inválida');
            when(() => mockLoginUsecase.call(any()))
                .thenAnswer((_) async => Failure(exception));
            return authBloc;
          },
          act: (bloc) => bloc.add(AuthLoginRequested(
            params: LoginParams(
              email: 'test@example.com',
              password: '123',
            ),
          )),
          expect: () => [
            AuthLoading(),
            isA<AuthLoginFailure>().having(
              (state) => state.exception,
              'exception type',
              isA<CredentialsValidationException>(),
            ),
          ],
        );
      });

      group('state transitions', () {
        blocTest<AuthBloc, AuthState>(
          'transitions from AuthInitial to AuthLoading to AuthLoginSuccess',
          build: () {
            when(() => mockLoginUsecase.call(any()))
                .thenAnswer((_) async => Success(authResponse));
            return authBloc;
          },
          act: (bloc) => bloc.add(AuthLoginRequested(params: loginParams)),
          expect: () => [
            AuthLoading(),
            AuthLoginSuccess(authResponse),
          ],
          verify: (_) {
            // Verify state transitions are correct
            expect(authBloc.state, isA<AuthLoginSuccess>());
          },
        );

        blocTest<AuthBloc, AuthState>(
          'transitions from AuthLoginSuccess back to AuthLoading on new request',
          build: () {
            when(() => mockLoginUsecase.call(any()))
                .thenAnswer((_) async => Success(authResponse));
            return authBloc;
          },
          seed: () => AuthLoginSuccess(authResponse),
          act: (bloc) => bloc.add(AuthLoginRequested(params: loginParams)),
          expect: () => [
            AuthLoading(),
            AuthLoginSuccess(authResponse),
          ],
        );

        blocTest<AuthBloc, AuthState>(
          'transitions from AuthLoginFailure back to AuthLoading on new request',
          build: () {
            when(() => mockLoginUsecase.call(any()))
                .thenAnswer((_) async => Success(authResponse));
            return authBloc;
          },
          seed: () => AuthLoginFailure(
            exception: DefaultException(message: 'Previous error'),
          ),
          act: (bloc) => bloc.add(AuthLoginRequested(params: loginParams)),
          expect: () => [
            AuthLoading(),
            AuthLoginSuccess(authResponse),
          ],
        );
      });

      group('edge cases', () {
        blocTest<AuthBloc, AuthState>(
          'handles empty email and password',
          build: () {
            final exception = CredentialsValidationException(message: 'Campos obrigatórios');
            when(() => mockLoginUsecase.call(any()))
                .thenAnswer((_) async => Failure(exception));
            return authBloc;
          },
          act: (bloc) => bloc.add(AuthLoginRequested(
            params: LoginParams(email: '', password: ''),
          )),
          expect: () => [
            AuthLoading(),
            isA<AuthLoginFailure>(),
          ],
        );

        blocTest<AuthBloc, AuthState>(
          'handles network timeout errors',
          build: () {
            final exception = DefaultException(message: 'Network timeout');
            when(() => mockLoginUsecase.call(any()))
                .thenAnswer((_) async => Failure(exception));
            return authBloc;
          },
          act: (bloc) => bloc.add(AuthLoginRequested(params: loginParams)),
          expect: () => [
            AuthLoading(),
            isA<AuthLoginFailure>().having(
              (state) => state.exception.message,
              'exception message',
              equals('Network timeout'),
            ),
          ],
        );
      });
    });

    group('AuthEvent props', () {
      test('AuthLoginRequested should have correct props', () {
        final params1 = LoginParams(email: 'test@example.com', password: 'password');
        final params2 = LoginParams(email: 'test@example.com', password: 'password');
        final params3 = LoginParams(email: 'different@example.com', password: 'password');

        final event1 = AuthLoginRequested(params: params1);
        final event2 = AuthLoginRequested(params: params2);
        final event3 = AuthLoginRequested(params: params3);

        expect(event1.props, equals([params1]));
        expect(event1.props, equals(event2.props));
        expect(event1.props, isNot(equals(event3.props)));
      });
    });

    group('AuthState props', () {
      test('AuthLoginSuccess should have correct props', () {
        final user = UserEntity(id: '1', email: 'test@example.com', name: 'Test');
        final authResponse1 = AuthResponseEntity(user: user, token: 'token1');
        final authResponse2 = AuthResponseEntity(user: user, token: 'token2');

        final state1 = AuthLoginSuccess(authResponse1);
        final state2 = AuthLoginSuccess(authResponse2);

        expect(state1.props, equals([authResponse1]));
        expect(state1.props, isNot(equals(state2.props)));
      });

      test('AuthLoginFailure should have correct props', () {
        final exception1 = DefaultException(message: 'Error 1');
        final exception2 = DefaultException(message: 'Error 2');

        final state1 = AuthLoginFailure(exception: exception1);
        final state2 = AuthLoginFailure(exception: exception2);

        expect(state1.props, equals([exception1]));
        expect(state1.props, isNot(equals(state2.props)));
      });

      test('AuthInitial and AuthLoading should have empty props', () {
        final initial = AuthInitial();
        final loading = AuthLoading();

        expect(initial.props, equals([]));
        expect(loading.props, equals([]));
      });
    });
  });
}