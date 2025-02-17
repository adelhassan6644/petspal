class VerificationModel {
  String? email;
  String? code;
  String? phone;
  String? countryCode;
  bool fromRegister, withMail, fromComplete;
  VerificationModel({
    this.email,
    this.code,
    this.phone,
    this.countryCode,
    this.fromComplete = false,
    this.fromRegister = true,
    this.withMail = false,
  });
  bool isEmpty() => email == "";

  Map<String, dynamic> toJson({bool withCode = true}) => {
        if (withMail) "email": email,
        if (!withMail) "phone_number": phone,
        // if (!withMail) "country_code": countryCode,
        if (withCode) "otp": code,
      };
}
