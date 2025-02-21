import 'package:flutter/cupertino.dart';

import '../../../../main_models/custom_field_model.dart';

class RegisterEntity {
  TextEditingController? name, email, phone, password, confirmPassword;
  CustomFieldModel? country;

  String? nameError, emailError, phoneError, countryError;
  String? passwordError, confirmPasswordError;

  RegisterEntity({
    this.name,
    this.email,
    this.phone,
    this.country,
    this.password,
    this.confirmPassword,
    this.nameError,
    this.emailError,
    this.phoneError,
    this.countryError,
    this.passwordError,
    this.confirmPasswordError,
  });

  RegisterEntity copyWith({
    String? name,
    String? email,
    String? phone,
    CustomFieldModel? country,
    String? password,
    String? confirmPassword,
    String? nameError,
    String? emailError,
    String? phoneError,
    String? countryError,
    String? passwordError,
    String? confirmPasswordError,
  }) {
    this.country = country ?? this.country;
    this.nameError = nameError ?? this.nameError;
    this.emailError = emailError ?? this.emailError;
    this.phoneError = phoneError ?? this.phoneError;
    this.countryError = countryError ?? this.countryError;
    this.passwordError = passwordError ?? this.passwordError;
    this.confirmPasswordError =
        confirmPasswordError ?? this.confirmPasswordError;
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = nameError == "" ? name?.text.trim() : null;
    data['email'] = emailError == "" ? email?.text.trim() : null;
    data['phone'] = phoneError == "" ? phone?.text.trim() : null;
    data['country_id'] = countryError == "" ? country?.id : null;
    data['password'] = passwordError == "" ? password?.text.trim() : null;
    data['confirm_password'] = confirmPasswordError == "" ? confirmPassword?.text.trim() : "";
    return data;
  }
}
