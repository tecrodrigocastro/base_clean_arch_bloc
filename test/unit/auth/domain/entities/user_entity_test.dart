import 'package:flutter_test/flutter_test.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserEntity', () {
    test('should create UserEntity with correct properties', () {
      final user = UserEntity(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      expect(user.id, equals('1'));
      expect(user.email, equals('test@example.com'));
      expect(user.name, equals('Test User'));
    });

    test('should be equal when properties are the same', () {
      final user1 = UserEntity(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      final user2 = UserEntity(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      expect(user1, equals(user2));
      expect(user1.hashCode, equals(user2.hashCode));
    });

    test('should not be equal when properties are different', () {
      final user1 = UserEntity(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      final user2 = UserEntity(
        id: '2',
        email: 'test@example.com',
        name: 'Test User',
      );

      expect(user1, isNot(equals(user2)));
      expect(user1.hashCode, isNot(equals(user2.hashCode)));
    });

    test('toString should return correct string representation', () {
      final user = UserEntity(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
      );

      final result = user.toString();

      expect(result, contains('UserEntity'));
      expect(result, contains('id: 1'));
      expect(result, contains('email: test@example.com'));
      expect(result, contains('name: Test User'));
    });
  });
}