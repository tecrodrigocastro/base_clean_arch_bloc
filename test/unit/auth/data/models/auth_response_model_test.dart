import 'package:flutter_test/flutter_test.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/data/models/auth_response_model.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/data/models/user_model.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/entities/auth_response_entity.dart';

void main() {
  group('AuthResponseModel', () {
    final userModel = UserModel(
      id: '1',
      email: 'test@example.com',
      name: 'Test User',
    );

    final authResponseModel = AuthResponseModel(
      user: userModel,
      token: 'test_token_123',
    );

    const authResponseMap = {
      'user': {
        'id': '1',
        'email': 'test@example.com',
        'name': 'Test User',
      },
      'token': 'test_token_123',
    };

    test('should be a subclass of AuthResponseEntity', () {
      expect(authResponseModel, isA<AuthResponseEntity>());
    });

    test('should create AuthResponseModel with correct properties', () {
      expect(authResponseModel.user, equals(userModel));
      expect(authResponseModel.token, equals('test_token_123'));
    });

    group('fromMap', () {
      test('should return a valid AuthResponseModel from Map', () {
        final result = AuthResponseModel.fromMap(authResponseMap);

        expect(result, isA<AuthResponseModel>());
        expect(result.user.id, equals('1'));
        expect(result.user.email, equals('test@example.com'));
        expect(result.user.name, equals('Test User'));
        expect(result.token, equals('test_token_123'));
      });

      test('should throw exception when map is invalid', () {
        const invalidMap = <String, dynamic>{
          'token': 'test_token_123',
          // missing user
        };

        expect(
          () => AuthResponseModel.fromMap(invalidMap),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception when user data is invalid', () {
        const invalidMap = <String, dynamic>{
          'user': {
            'id': '1',
            // missing email and name
          },
          'token': 'test_token_123',
        };

        expect(
          () => AuthResponseModel.fromMap(invalidMap),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception when token is missing', () {
        const invalidMap = <String, dynamic>{
          'user': {
            'id': '1',
            'email': 'test@example.com',
            'name': 'Test User',
          },
          // missing token
        };

        expect(
          () => AuthResponseModel.fromMap(invalidMap),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception when field types are wrong', () {
        const invalidMap = <String, dynamic>{
          'user': 'invalid_user_data', // should be Map
          'token': 'test_token_123',
        };

        expect(
          () => AuthResponseModel.fromMap(invalidMap),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('error handling', () {
      test('should include stack trace in exception message', () {
        const invalidMap = <String, dynamic>{
          'user': 'invalid_user_data',
          'token': 'test_token_123',
        };

        try {
          AuthResponseModel.fromMap(invalidMap);
          fail('Should have thrown an exception');
        } catch (e) {
          expect(e.toString(), contains('Error parsing AuthResponseModel'));
          expect(e.toString(), contains('Stack trace'));
        }
      });

      test('should handle null values gracefully', () {
        const invalidMap = <String, dynamic>{
          'user': null,
          'token': 'test_token_123',
        };

        expect(
          () => AuthResponseModel.fromMap(invalidMap),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle empty map', () {
        const emptyMap = <String, dynamic>{};

        expect(
          () => AuthResponseModel.fromMap(emptyMap),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('data integrity', () {
      test('should preserve user data correctly', () {
        final result = AuthResponseModel.fromMap(authResponseMap);

        expect(result.user, isA<UserModel>());
        expect(result.user.id, equals(userModel.id));
        expect(result.user.email, equals(userModel.email));
        expect(result.user.name, equals(userModel.name));
      });

      test('should preserve token correctly', () {
        final result = AuthResponseModel.fromMap(authResponseMap);

        expect(result.token, equals('test_token_123'));
        expect(result.token, isA<String>());
      });

      test('should handle different token formats', () {
        final mapWithLongToken = {
          'user': {
            'id': '1',
            'email': 'test@example.com',
            'name': 'Test User',
          },
          'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c',
        };

        final result = AuthResponseModel.fromMap(mapWithLongToken);

        expect(result.token, isA<String>());
        expect(result.token.length, greaterThan(10));
      });
    });
  });
}