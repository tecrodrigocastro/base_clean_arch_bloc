import 'package:base_clean_arch_bloc/src/app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/dtos/login_params.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:base_clean_arch_bloc/src/core/client_http/rest_client_exception.dart';
import 'package:base_clean_arch_bloc/src/core/client_http/rest_client_request.dart';
import 'package:base_clean_arch_bloc/src/core/client_http/rest_client_response.dart';
import 'package:base_clean_arch_bloc/src/core/errors/default_exception.dart';
import 'package:base_clean_arch_bloc/src/core/errors/unauthorized_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

void main() {
  group('AuthRepositoryImpl', () {
    late AuthRepositoryImpl repository;
    late MockAuthRemoteDatasource mockDatasource;

    setUpAll(() {
      registerFallbackValue(LoginParams(email: '', password: ''));
    });

    setUp(() {
      mockDatasource = MockAuthRemoteDatasource();
      repository = AuthRepositoryImpl(authRemoteDatasource: mockDatasource);
    });

    group('login', () {
      final loginParams = LoginParams(
        email: 'test@example.com',
        password: 'password123',
      );

      final successResponseData = {
        'user': {
          'id': '1',
          'email': 'test@example.com',
          'name': 'Test User',
        },
        'token': 'test_token_123',
      };

      final successResponse = RestClientResponse(
        data: successResponseData,
        statusCode: 200,
        message: 'OK',
        request: RestClientRequest(path: '/test'),
      );

      test('should return Success with AuthResponseEntity when datasource succeeds', () async {
        // Arrange
        when(() => mockDatasource.login(loginParams)).thenAnswer((_) async => successResponse);

        // Act
        final result = await repository.login(loginParams);

        // Assert
        expect(result.isSuccess(), isTrue);

        final authResponse = result.getOrNull()!;
        expect(authResponse, isA<AuthResponseEntity>());
        expect(authResponse.user.id, equals('1'));
        expect(authResponse.user.email, equals('test@example.com'));
        expect(authResponse.user.name, equals('Test User'));
        expect(authResponse.token, equals('test_token_123'));

        verify(() => mockDatasource.login(loginParams)).called(1);
      });

      test('should return Failure with UnauthorizedException when status code is 401', () async {
        // Arrange
        final exception = RestClientException(
          message: 'Invalid credentials',
          statusCode: 401,
          error: 'Unauthorized',
        );

        when(() => mockDatasource.login(loginParams)).thenThrow(exception);

        // Act
        final result = await repository.login(loginParams);

        // Assert
        expect(result.isError(), isTrue);

        final error = result.exceptionOrNull();
        expect(error, isA<UnauthorizedException>());
        final authError = error as UnauthorizedException;
        expect(authError.message, equals('Invalid credentials'));

        verify(() => mockDatasource.login(loginParams)).called(1);
      });

      test('should return Failure with DefaultException for other HTTP errors', () async {
        // Arrange
        final exception = RestClientException(
          message: 'Server error',
          statusCode: 500,
          error: 'Internal Server Error',
        );

        when(() => mockDatasource.login(loginParams)).thenThrow(exception);

        // Act
        final result = await repository.login(loginParams);

        // Assert
        expect(result.isError(), isTrue);

        final error = result.exceptionOrNull();
        expect(error, isA<DefaultException>());
        final defaultError = error as DefaultException;
        expect(defaultError.message, equals('Server error'));

        verify(() => mockDatasource.login(loginParams)).called(1);
      });

      test('should return Failure with DefaultException for generic exceptions', () async {
        // Arrange
        when(() => mockDatasource.login(loginParams)).thenThrow(Exception('Generic error'));

        // Act
        final result = await repository.login(loginParams);

        // Assert
        expect(result.isError(), isTrue);

        final error = result.exceptionOrNull();
        expect(error, isA<DefaultException>());
        final defaultError = error as DefaultException;
        expect(defaultError.message, contains('Erro inesperado'));

        verify(() => mockDatasource.login(loginParams)).called(1);
      });

      test('should handle different HTTP status codes correctly', () async {
        final testCases = [
          {
            'statusCode': 400,
            'message': 'Bad request',
            'expectedType': DefaultException,
          },
          {
            'statusCode': 404,
            'message': 'Not found',
            'expectedType': DefaultException,
          },
          {
            'statusCode': 403,
            'message': 'Forbidden',
            'expectedType': DefaultException,
          },
        ];

        for (final testCase in testCases) {
          // Arrange
          final exception = RestClientException(
            message: testCase['message'] as String,
            statusCode: testCase['statusCode'] as int,
            error: testCase['message'] as String,
          );

          when(() => mockDatasource.login(loginParams)).thenThrow(exception);

          // Act
          final result = await repository.login(loginParams);

          // Assert
          expect(result.isError(), isTrue);
          final error = result.exceptionOrNull();
          expect(error, isA<DefaultException>());
          final defaultError = error as DefaultException;
          expect(defaultError.message, equals(testCase['message']));
        }
      });

      test('should handle malformed response data', () async {
        // Arrange
        final malformedResponse = RestClientResponse(
          data: {
            'user': 'invalid_user_data', // should be Map
            'token': 'test_token_123',
          },
          statusCode: 200,
          message: 'OK',
          request: RestClientRequest(path: '/test'),
        );

        when(() => mockDatasource.login(loginParams)).thenAnswer((_) async => malformedResponse);

        // Act
        final result = await repository.login(loginParams);

        // Assert
        expect(result.isError(), isTrue);

        final error = result.exceptionOrNull();
        expect(error, isA<DefaultException>());
        final defaultError = error as DefaultException;
        expect(defaultError.message, contains('Erro inesperado'));
      });

      test('should handle missing user data in response', () async {
        // Arrange
        final incompleteResponse = RestClientResponse(
          data: {
            'token': 'test_token_123',
            // missing user data
          },
          statusCode: 200,
          message: 'OK',
          request: RestClientRequest(path: '/test'),
        );

        when(() => mockDatasource.login(loginParams)).thenAnswer((_) async => incompleteResponse);

        // Act
        final result = await repository.login(loginParams);

        // Assert
        expect(result.isError(), isTrue);
        expect(result.exceptionOrNull(), isA<DefaultException>());
      });

      test('should handle missing token in response', () async {
        // Arrange
        final incompleteResponse = RestClientResponse(
          data: {
            'user': {
              'id': '1',
              'email': 'test@example.com',
              'name': 'Test User',
            },
            // missing token
          },
          statusCode: 200,
          message: 'OK',
          request: RestClientRequest(path: '/test'),
        );

        when(() => mockDatasource.login(loginParams)).thenAnswer((_) async => incompleteResponse);

        // Act
        final result = await repository.login(loginParams);

        // Assert
        expect(result.isError(), isTrue);
        expect(result.exceptionOrNull(), isA<DefaultException>());
      });

      test('should verify datasource is called with correct parameters', () async {
        // Arrange
        when(() => mockDatasource.login(any())).thenAnswer((_) async => successResponse);

        // Act
        await repository.login(loginParams);

        // Assert
        final captured = verify(() => mockDatasource.login(captureAny())).captured;
        final capturedParams = captured.first as LoginParams;
        expect(capturedParams.email, equals(loginParams.email));
        expect(capturedParams.password, equals(loginParams.password));
      });

      test('should call datasource exactly once', () async {
        // Arrange
        when(() => mockDatasource.login(loginParams)).thenAnswer((_) async => successResponse);

        // Act
        await repository.login(loginParams);

        // Assert
        verify(() => mockDatasource.login(loginParams)).called(1);
        verifyNoMoreInteractions(mockDatasource);
      });

      test('should handle null response data', () async {
        // Arrange
        final nullResponse = RestClientResponse(
          data: null,
          statusCode: 200,
          message: 'OK',
          request: RestClientRequest(path: '/test'),
        );

        when(() => mockDatasource.login(loginParams)).thenAnswer((_) async => nullResponse);

        // Act
        final result = await repository.login(loginParams);

        // Assert
        expect(result.isError(), isTrue);
        expect(result.exceptionOrNull(), isA<DefaultException>());
      });
    });
  });
}
