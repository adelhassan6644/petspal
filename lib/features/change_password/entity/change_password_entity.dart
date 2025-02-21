import 'package:flutter/cupertino.dart';

class ChangePasswordEntity {
  TextEditingController? currentPassword;
  TextEditingController? newPassword;
  TextEditingController? confirmNewPassword;

  String? currentPasswordError;
  String? newPasswordError;
  String? confirmNewPasswordError;

  ChangePasswordEntity({
    this.currentPassword,
    this.newPassword,
    this.confirmNewPassword,
    this.currentPasswordError,
    this.newPasswordError,
    this.confirmNewPasswordError,
  });

  ChangePasswordEntity copyWith({
    String? currentPasswordError,
    String? newPasswordError,
    String? confirmNewPasswordError,
  }) {
    this.currentPasswordError = currentPasswordError ?? this.currentPasswordError;
    this.newPasswordError = newPasswordError ?? this.newPasswordError;
    this.confirmNewPasswordError = confirmNewPasswordError ?? this.confirmNewPasswordError;
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_password'] = currentPasswordError == "" ? currentPassword?.text.trim() : null;
    data['new_password'] = newPasswordError == "" ? newPassword?.text.trim() : null;
    data['confirm_new_password'] = confirmNewPasswordError == "" ? confirmNewPassword?.text.trim() : "";
    return data;
  }
}
