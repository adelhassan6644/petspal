import 'package:flutter/cupertino.dart';

class LoginEntity {
  TextEditingController? email;
  TextEditingController? password;

  String? emailError;
  String? passwordError;

  LoginEntity({
    this.email,
    this.password,
    this.emailError,
    this.passwordError,
  });

  LoginEntity copyWith({
    String? emailError,
    String? passwordError,
  }) {
    this.emailError = emailError ?? this.emailError;
    this.passwordError = passwordError ?? this.passwordError;

    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = emailError == "" ? email?.text.trim() : null;
    data['password'] = passwordError == "" ? password?.text.trim() : null;
    return data;
  }
}
