import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/data/models/user_model.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserModel', () {
    final userModel = UserModel(
      id: '1',
      email: 'test@example.com',
      name: 'Test User',
    );

    const userMap = {
      'id': '1',
      'email': 'test@example.com',
      'name': 'Test User',
    };

    const userJson = '{"id":"1","email":"test@example.com","name":"Test User"}';

    test('should be a subclass of UserEntity', () {
      expect(userModel, isA<UserEntity>());
    });

    test('should create UserModel with correct properties', () {
      expect(userModel.id, equals('1'));
      expect(userModel.email, equals('test@example.com'));
      expect(userModel.name, equals('Test User'));
    });

    group('fromMap', () {
      test('should return a valid UserModel from Map', () {
        final result = UserModel.fromMap(userMap);

        expect(result, isA<UserModel>());
        expect(result.id, equals('1'));
        expect(result.email, equals('test@example.com'));
        expect(result.name, equals('Test User'));
      });

      test('should throw exception when map is invalid', () {
        const invalidMap = <String, dynamic>{
          'id': '1',
          // missing email and name
        };

        expect(
          () => UserModel.fromMap(invalidMap),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception when field types are wrong', () {
        const invalidMap = <String, dynamic>{
          'id': 123, // should be String
          'email': 'test@example.com',
          'name': 'Test User',
        };

        expect(
          () => UserModel.fromMap(invalidMap),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('toMap', () {
      test('should return a valid Map from UserModel', () {
        final result = userModel.toMap();

        expect(result, isA<Map<String, dynamic>>());
        expect(result['id'], equals('1'));
        expect(result['email'], equals('test@example.com'));
        expect(result['name'], equals('Test User'));
      });

      test('should return Map with all required fields', () {
        final result = userModel.toMap();

        expect(result.containsKey('id'), isTrue);
        expect(result.containsKey('email'), isTrue);
        expect(result.containsKey('name'), isTrue);
      });
    });

    group('fromJson', () {
      test('should return a valid UserModel from JSON string', () {
        final result = UserModel.fromJson(userJson);

        expect(result, isA<UserModel>());
        expect(result.id, equals('1'));
        expect(result.email, equals('test@example.com'));
        expect(result.name, equals('Test User'));
      });

      test('should throw exception when JSON is invalid', () {
        const invalidJson = '{"id":"1"}'; // missing required fields

        expect(
          () => UserModel.fromJson(invalidJson),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception when JSON format is wrong', () {
        const invalidJson = 'invalid json string';

        expect(
          () => UserModel.fromJson(invalidJson),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('toJson', () {
      test('should return a valid JSON string from UserModel', () {
        final result = userModel.toJson();

        expect(result, isA<String>());
        
        final decoded = json.decode(result) as Map<String, dynamic>;
        expect(decoded['id'], equals('1'));
        expect(decoded['email'], equals('test@example.com'));
        expect(decoded['name'], equals('Test User'));
      });

      test('should create JSON that can be parsed back to UserModel', () {
        final jsonString = userModel.toJson();
        final parsedModel = UserModel.fromJson(jsonString);

        expect(parsedModel.id, equals(userModel.id));
        expect(parsedModel.email, equals(userModel.email));
        expect(parsedModel.name, equals(userModel.name));
      });
    });

    group('serialization round trip', () {
      test('should maintain data integrity through map serialization', () {
        final map = userModel.toMap();
        final reconstructed = UserModel.fromMap(map);

        expect(reconstructed.id, equals(userModel.id));
        expect(reconstructed.email, equals(userModel.email));
        expect(reconstructed.name, equals(userModel.name));
      });

      test('should maintain data integrity through JSON serialization', () {
        final jsonString = userModel.toJson();
        final reconstructed = UserModel.fromJson(jsonString);

        expect(reconstructed.id, equals(userModel.id));
        expect(reconstructed.email, equals(userModel.email));
        expect(reconstructed.name, equals(userModel.name));
      });
    });
  });
}