import 'package:base_clean_arch_bloc/src/app/features/auth/domain/dtos/login_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/entities/user_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/usecases/login_usecase.dart';
import 'package:base_clean_arch_bloc/src/core/errors/default_exception.dart';
import 'package:base_clean_arch_bloc/src/core/errors/unauthorized_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  group('LoginUsecase', () {
    late LoginUsecase usecase;
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      usecase = LoginUsecase(authRepository: mockAuthRepository);
    });

    group('call', () {
      final loginParams = LoginParams(
        email: 'test@example.com',
        password: 'password123',
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

      test('should return AuthResponseEntity when repository call succeeds', () async {
        // Arrange
        when(() => mockAuthRepository.login(loginParams)).thenAnswer((_) async => Success(authResponse));

        // Act
        final result = await usecase.call(loginParams);

        // Assert
        expect(result.isSuccess(), isTrue);
        expect(result.getOrNull(), equals(authResponse));
        verify(() => mockAuthRepository.login(loginParams)).called(1);
      });

      test('should return Failure when repository call fails', () async {
        // Arrange
        const exception = DefaultException(message: 'Login failed');
        when(() => mockAuthRepository.login(loginParams)).thenAnswer((_) async => const Failure(exception));

        // Act
        final result = await usecase.call(loginParams);

        // Assert
        expect(result.isError(), isTrue);
        expect(result.exceptionOrNull(), equals(exception));
        verify(() => mockAuthRepository.login(loginParams)).called(1);
      });

      test('should return UnauthorizedException when credentials are invalid', () async {
        // Arrange
        final exception = UnauthorizedException(message: 'Invalid credentials');
        when(() => mockAuthRepository.login(loginParams)).thenAnswer((_) async => Failure(exception));

        // Act
        final result = await usecase.call(loginParams);

        // Assert
        expect(result.isError(), isTrue);
        expect(result.exceptionOrNull(), isA<UnauthorizedException>());
        //final exceptions = result.exceptionOrNull() as UnauthorizedException;
        expect(exception.message, equals('Invalid credentials'));
        verify(() => mockAuthRepository.login(loginParams)).called(1);
      });

      test('should call repository with correct parameters', () async {
        // Arrange
        when(() => mockAuthRepository.login(any())).thenAnswer((_) async => Success(authResponse));

        // Act
        await usecase.call(loginParams);

        // Assert
        final captured = verify(() => mockAuthRepository.login(captureAny())).captured;
        final capturedParams = captured.first as LoginParams;
        expect(capturedParams.email, equals(loginParams.email));
        expect(capturedParams.password, equals(loginParams.password));
      });
    });
  });
}
