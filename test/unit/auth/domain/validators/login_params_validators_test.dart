import 'package:flutter_test/flutter_test.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/validators/login_params_validators.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/dtos/login_params.dart';

void main() {
  group('LoginParamsValidators', () {
    late LoginParamsValidators validator;

    setUp(() {
      validator = LoginParamsValidators();
    });

    group('email validation', () {
      test('should return valid when email is valid', () {
        final params = LoginParams(
          email: 'test@example.com',
          password: 'Password123!',
        );

        final result = validator.validate(params);

        expect(result.isValid, isTrue);
      });

      test('should return invalid when email is empty', () {
        final params = LoginParams(
          email: '',
          password: 'Password123!',
        );

        final result = validator.validate(params);

        expect(result.isValid, isFalse);
        expect(result.exceptions.any((e) => e.key == 'email'), isTrue);
      });

      test('should return invalid when email format is invalid', () {
        final params = LoginParams(
          email: 'invalid-email',
          password: 'Password123!',
        );

        final result = validator.validate(params);

        expect(result.isValid, isFalse);
        expect(result.exceptions.any((e) => e.key == 'email'), isTrue);
      });

      test('should validate email field individually', () {
        final params = LoginParams(
          email: 'test@example.com',
          password: 'Password123!',
        );

        final result = validator.byField(params, 'email');

        expect(result, isNull); // null means valid
      });

      test('should return error message for invalid email field', () {
        final params = LoginParams(
          email: 'invalid-email',
          password: 'Password123!',
        );

        final result = validator.byField(params, 'email');

        expect(result, isNotNull);
        expect(result, contains('Email'));
      });
    });

    group('password validation', () {
      test('should return valid when password meets all criteria', () {
        final params = LoginParams(
          email: 'test@example.com',
          password: 'Password123!',
        );

        final result = validator.validate(params);

        expect(result.isValid, isTrue);
      });

      test('should return invalid when password is empty', () {
        final params = LoginParams(
          email: 'test@example.com',
          password: '',
        );

        final result = validator.validate(params);

        expect(result.isValid, isFalse);
        expect(result.exceptions.any((e) => e.key == 'password'), isTrue);
      });

      test('should return invalid when password is too short', () {
        final params = LoginParams(
          email: 'test@example.com',
          password: 'Pass1!',
        );

        final result = validator.validate(params);

        expect(result.isValid, isFalse);
        expect(result.exceptions.any((e) => e.key == 'password'), isTrue);
      });

      test('should return invalid when password lacks uppercase', () {
        final params = LoginParams(
          email: 'test@example.com',
          password: 'password123!',
        );

        final result = validator.validate(params);

        expect(result.isValid, isFalse);
        expect(result.exceptions.any((e) => e.key == 'password'), isTrue);
      });

      test('should return invalid when password lacks lowercase', () {
        final params = LoginParams(
          email: 'test@example.com',
          password: 'PASSWORD123!',
        );

        final result = validator.validate(params);

        expect(result.isValid, isFalse);
        expect(result.exceptions.any((e) => e.key == 'password'), isTrue);
      });

      test('should return invalid when password lacks number', () {
        final params = LoginParams(
          email: 'test@example.com',
          password: 'Password!',
        );

        final result = validator.validate(params);

        expect(result.isValid, isFalse);
        expect(result.exceptions.any((e) => e.key == 'password'), isTrue);
      });

      test('should return invalid when password lacks special character', () {
        final params = LoginParams(
          email: 'test@example.com',
          password: 'Password123',
        );

        final result = validator.validate(params);

        expect(result.isValid, isFalse);
        expect(result.exceptions.any((e) => e.key == 'password'), isTrue);
      });

      test('should validate password field individually', () {
        final params = LoginParams(
          email: 'test@example.com',
          password: 'Password123!',
        );

        final result = validator.byField(params, 'password');

        expect(result, isNull); // null means valid
      });

      test('should return error message for invalid password field', () {
        final params = LoginParams(
          email: 'test@example.com',
          password: '123',
        );

        final result = validator.byField(params, 'password');

        expect(result, isNotNull);
        expect(result, contains('senha'));
      });
    });

    group('custom validation scenarios', () {
      test('should accept various valid email formats', () {
        final validEmails = [
          'test@example.com',
          'user.name@domain.co.uk',
          'user+tag@example.org',
          'test123@test-domain.com',
        ];

        for (final email in validEmails) {
          final params = LoginParams(
            email: email,
            password: 'Password123!',
          );

          final result = validator.validate(params);
          expect(result.isValid, isTrue, reason: 'Email $email should be valid');
        }
      });

      test('should reject various invalid email formats', () {
        final invalidEmails = [
          'plainaddress',
          '@domain.com',
          'user@',
          'user..name@domain.com',
          'user@domain',
        ];

        for (final email in invalidEmails) {
          final params = LoginParams(
            email: email,
            password: 'Password123!',
          );

          final result = validator.validate(params);
          expect(result.isValid, isFalse, reason: 'Email $email should be invalid');
        }
      });
    });
  });
}