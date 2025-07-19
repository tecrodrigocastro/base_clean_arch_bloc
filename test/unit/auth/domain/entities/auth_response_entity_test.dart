import 'package:flutter_test/flutter_test.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/entities/auth_response_entity.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/entities/user_entity.dart';

void main() {
  group('AuthResponseEntity', () {
    final user = UserEntity(
      id: '1',
      email: 'test@example.com',
      name: 'Test User',
    );

    test('should create AuthResponseEntity with correct properties', () {
      final authResponse = AuthResponseEntity(
        user: user,
        token: 'test_token_123',
      );

      expect(authResponse.user, equals(user));
      expect(authResponse.token, equals('test_token_123'));
    });

    test('should be equal when properties are the same', () {
      final authResponse1 = AuthResponseEntity(
        user: user,
        token: 'test_token_123',
      );

      final authResponse2 = AuthResponseEntity(
        user: user,
        token: 'test_token_123',
      );

      expect(authResponse1, equals(authResponse2));
      expect(authResponse1.hashCode, equals(authResponse2.hashCode));
    });

    test('should not be equal when properties are different', () {
      final authResponse1 = AuthResponseEntity(
        user: user,
        token: 'test_token_123',
      );

      final authResponse2 = AuthResponseEntity(
        user: user,
        token: 'different_token',
      );

      expect(authResponse1, isNot(equals(authResponse2)));
      expect(authResponse1.hashCode, isNot(equals(authResponse2.hashCode)));
    });

    test('should not be equal when user is different', () {
      final user2 = UserEntity(
        id: '2',
        email: 'test2@example.com',
        name: 'Test User 2',
      );

      final authResponse1 = AuthResponseEntity(
        user: user,
        token: 'test_token_123',
      );

      final authResponse2 = AuthResponseEntity(
        user: user2,
        token: 'test_token_123',
      );

      expect(authResponse1, isNot(equals(authResponse2)));
      expect(authResponse1.hashCode, isNot(equals(authResponse2.hashCode)));
    });

    test('toString should return correct string representation', () {
      final authResponse = AuthResponseEntity(
        user: user,
        token: 'test_token_123',
      );

      final result = authResponse.toString();

      expect(result, contains('AuthResponseEntity'));
      expect(result, contains('user:'));
      expect(result, contains('token: test_token_123'));
    });
  });
}