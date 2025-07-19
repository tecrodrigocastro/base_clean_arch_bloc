class LoginParams {
  String email;
  String password;

  LoginParams({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  void setEmail(String value) {
    email = value;
  }

  void setPassword(String value) {
    password = value;
  }

  static LoginParams empty() {
    return LoginParams(email: '', password: '');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginParams &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode {
    return email.hashCode ^ password.hashCode;
  }

  @override
  String toString() {
    return 'LoginParams(email: $email, password: $password)';
  }
}
