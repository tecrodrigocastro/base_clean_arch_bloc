import 'package:flutter_test/flutter_test.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/dtos/login_params.dart';

void main() {
  group('LoginParams', () {
    test('should create LoginParams with correct properties', () {
      final params = LoginParams(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(params.email, equals('test@example.com'));
      expect(params.password, equals('password123'));
    });

    test('should create empty LoginParams', () {
      final params = LoginParams.empty();

      expect(params.email, equals(''));
      expect(params.password, equals(''));
    });

    test('should convert to JSON correctly', () {
      final params = LoginParams(
        email: 'test@example.com',
        password: 'password123',
      );

      final json = params.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['email'], equals('test@example.com'));
      expect(json['password'], equals('password123'));
    });

    test('should set email correctly', () {
      final params = LoginParams.empty();
      
      params.setEmail('newemail@example.com');

      expect(params.email, equals('newemail@example.com'));
    });

    test('should set password correctly', () {
      final params = LoginParams.empty();
      
      params.setPassword('newpassword');

      expect(params.password, equals('newpassword'));
    });

    test('should be equal when properties are the same', () {
      final params1 = LoginParams(
        email: 'test@example.com',
        password: 'password123',
      );

      final params2 = LoginParams(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(params1.email, equals(params2.email));
      expect(params1.password, equals(params2.password));
    });

    test('should not be equal when properties are different', () {
      final params1 = LoginParams(
        email: 'test@example.com',
        password: 'password123',
      );

      final params2 = LoginParams(
        email: 'different@example.com',
        password: 'password123',
      );

      expect(params1.email, isNot(equals(params2.email)));
    });

    test('toString should return correct string representation', () {
      final params = LoginParams(
        email: 'test@example.com',
        password: 'password123',
      );

      final result = params.toString();

      expect(result, contains('LoginParams'));
      expect(result, contains('email: test@example.com'));
      expect(result, contains('password: password123'));
    });
  });
}