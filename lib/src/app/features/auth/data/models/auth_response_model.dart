import 'dart:convert';

import 'package:base_clean_arch_bloc/src/app/features/auth/data/models/user_model.dart';
import 'package:base_clean_arch_bloc/src/app/features/auth/domain/entities/auth_response_entity.dart';

class AuthResponseModel extends AuthResponseEntity {
  AuthResponseModel({required super.user, required super.token});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': (user as UserModel).toMap(),
      'token': token,
    };
  }

  factory AuthResponseModel.fromMap(Map<String, dynamic> map) {
    try {
      return AuthResponseModel(
        user: UserModel.fromMap(map['user'] as Map<String, dynamic>),
        token: map['token'] as String,
      );
    } catch (e, s) {
      throw Exception('Error parsing AuthResponseModel: $e \nStack trace: $s');
    }
  }

  String toJson() => json.encode(toMap());

  factory AuthResponseModel.fromJson(String source) => AuthResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
