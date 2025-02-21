import 'package:flutter/cupertino.dart';

class ResetPasswordEntity {
  TextEditingController? password;
  TextEditingController? confirmPassword;

  String? passwordError;
  String? confirmPasswordError;

  ResetPasswordEntity({
    this.password,
    this.confirmPassword,
    this.passwordError,
    this.confirmPasswordError,
  });

  ResetPasswordEntity copyWith({
    String? passwordError,
    String? confirmPasswordError,
  }) {
    this.passwordError = passwordError ?? this.passwordError;
    this.confirmPasswordError =
        confirmPasswordError ?? this.confirmPasswordError;

    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['password'] = passwordError == "" ? password?.text.trim() : null;
    data['confirm_password'] = confirmPasswordError == "" ? confirmPassword?.text.trim() : "";
    return data;
  }
}
