class VerificationModel {
  String? email;
  String? code;
  String? phone;
  String? countryCode;
  bool fromRegister;
  VerificationModel({
    this.email,
    this.code,
    this.phone,
    this.countryCode,
    this.fromRegister = true,
  });
  bool isEmpty() => email == "";

  Map<String, dynamic> toJson({bool withCode = true}) => {
        "email": email,
        if (withCode) "otp": code,
      };
}
