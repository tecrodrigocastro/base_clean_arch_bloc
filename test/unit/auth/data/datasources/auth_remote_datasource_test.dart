import 'package:base_clean_arch_bloc/src/app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/dtos/login_params.dart';
import 'package:base_clean_arch_bloc/src/core/client_http/rest_client_exception.dart';
import 'package:base_clean_arch_bloc/src/core/client_http/rest_client_interface.dart';
import 'package:base_clean_arch_bloc/src/core/client_http/rest_client_request.dart';
import 'package:base_clean_arch_bloc/src/core/client_http/rest_client_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRestClient extends Mock implements IRestClient {}

void main() {
  group('AuthRemoteDatasource', () {
    late AuthRemoteDatasource datasource;
    late MockRestClient mockRestClient;

    setUp(() {
      mockRestClient = MockRestClient();
      datasource = AuthRemoteDatasource(restClient: mockRestClient);
    });

    setUpAll(() {
      registerFallbackValue(RestClientRequest(path: ''));
    });

    group('login', () {
      final loginParams = LoginParams(
        email: 'test@example.com',
        password: 'password123',
      );

      final expectedResponseData = {
        'user': {
          'id': '1',
          'email': 'test@example.com',
          'name': 'Test User',
        },
        'token': 'test_token_123',
      };

      final successResponse = RestClientResponse(
        data: expectedResponseData,
        statusCode: 200,
        message: 'OK',
        request: RestClientRequest(path: '/test'),
      );

      test('should call rest client with correct parameters', () async {
        // Arrange
        when(() => mockRestClient.post(any())).thenAnswer((_) async => successResponse);

        // Act
        await datasource.login(loginParams);

        // Assert
        final captured = verify(() => mockRestClient.post(captureAny())).captured;
        final request = captured.first as RestClientRequest;

        expect(request.path, equals('https://127.0.0.1:8000/api/auth/login'));
        expect(request.data, equals(loginParams.toJson()));
      });

      test('should return RestClientResponse when login succeeds', () async {
        // Arrange
        when(() => mockRestClient.post(any())).thenAnswer((_) async => successResponse);

        // Act
        final result = await datasource.login(loginParams);

        // Assert
        expect(result, isA<RestClientResponse>());
        expect(result.data, equals(expectedResponseData));
        expect(result.statusCode, equals(200));
      });

      test('should throw RestClientException when login fails', () async {
        // Arrange
        final exception = RestClientException(
          message: 'Login failed',
          statusCode: 401,
          error: 'Unauthorized',
        );

        when(() => mockRestClient.post(any())).thenThrow(exception);

        // Act & Assert
        expect(
          () => datasource.login(loginParams),
          throwsA(isA<RestClientException>()),
        );
      });

      test('should handle different HTTP status codes', () async {
        // Arrange
        final responses = [
          RestClientResponse(data: {}, statusCode: 200, message: 'OK', request: RestClientRequest(path: '/test')),
          RestClientResponse(data: {}, statusCode: 201, message: 'Created', request: RestClientRequest(path: '/test')),
        ];

        for (final response in responses) {
          when(() => mockRestClient.post(any())).thenAnswer((_) async => response);

          // Act
          final result = await datasource.login(loginParams);

          // Assert
          expect(result.statusCode, equals(response.statusCode));
        }
      });

      test('should handle network errors', () async {
        // Arrange
        when(() => mockRestClient.post(any())).thenThrow(RestClientException(
          message: 'Network error',
          statusCode: 0,
          error: 'Network error',
        ));

        // Act & Assert
        expect(
          () => datasource.login(loginParams),
          throwsA(
            predicate((e) => e is RestClientException && e.message == 'Network error' && e.statusCode == 0),
          ),
        );
      });

      test('should handle server errors', () async {
        // Arrange
        when(() => mockRestClient.post(any())).thenThrow(RestClientException(
          message: 'Internal server error',
          statusCode: 500,
          error: 'Internal server error',
        ));

        // Act & Assert
        expect(
          () => datasource.login(loginParams),
          throwsA(
            predicate((e) => e is RestClientException && e.statusCode == 500),
          ),
        );
      });

      test('should serialize login params correctly', () async {
        // Arrange
        when(() => mockRestClient.post(any())).thenAnswer((_) async => successResponse);

        final params = LoginParams(
          email: 'user@test.com',
          password: 'secure_password',
        );

        // Act
        await datasource.login(params);

        // Assert
        final captured = verify(() => mockRestClient.post(captureAny())).captured;
        final request = captured.first as RestClientRequest;

        expect(
            request.data,
            equals({
              'email': 'user@test.com',
              'password': 'secure_password',
            }));
      });

      test('should verify rest client is called exactly once', () async {
        // Arrange
        when(() => mockRestClient.post(any())).thenAnswer((_) async => successResponse);

        // Act
        await datasource.login(loginParams);

        // Assert
        verify(() => mockRestClient.post(any())).called(1);
        verifyNoMoreInteractions(mockRestClient);
      });

      test('should handle empty response data', () async {
        // Arrange
        final emptyResponse = RestClientResponse(
          data: {},
          statusCode: 200,
          message: 'OK',
          request: RestClientRequest(path: '/test'),
        );

        when(() => mockRestClient.post(any())).thenAnswer((_) async => emptyResponse);

        // Act
        final result = await datasource.login(loginParams);

        // Assert
        expect(result.data, equals({}));
        expect(result.statusCode, equals(200));
      });

      test('should handle null response data', () async {
        // Arrange
        final nullResponse = RestClientResponse(
          data: null,
          statusCode: 204,
          message: 'No Content',
          request: RestClientRequest(path: '/test'),
        );

        when(() => mockRestClient.post(any())).thenAnswer((_) async => nullResponse);

        // Act
        final result = await datasource.login(loginParams);

        // Assert
        expect(result.data, isNull);
        expect(result.statusCode, equals(204));
      });
    });
  });
}
