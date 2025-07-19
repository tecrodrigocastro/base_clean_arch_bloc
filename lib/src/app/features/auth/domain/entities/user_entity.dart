import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
  });

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, name: $name)';
  }

  @override
  List<Object?> get props => [id, email, name];
}
