import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/main_models/custom_field_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../data/error/failures.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';
import '../../verification/model/verification_model.dart';
import '../repo/register_repo.dart';

class RegisterBloc extends Bloc<AppEvent, AppState> {
  final RegisterRepo repo;
  RegisterBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
  }

  final FocusNode nameNode = FocusNode();
  final FocusNode emailNode = FocusNode();
  final FocusNode phoneNode = FocusNode();
  final FocusNode countryNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final FocusNode confirmPasswordNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  final profileImage = BehaviorSubject<File?>();
  Function(File?) get updateProfileImage => profileImage.sink.add;
  Stream<File?> get profileImageStream =>
      profileImage.stream.asBroadcastStream();

  final name = BehaviorSubject<String?>();
  Function(String?) get updateName => name.sink.add;
  Stream<String?> get nameStream => name.stream.asBroadcastStream();

  final email = BehaviorSubject<String?>();
  Function(String?) get updateEmail => email.sink.add;
  Stream<String?> get emailStream => email.stream.asBroadcastStream();

  final phone = BehaviorSubject<String?>();
  Function(String?) get updatePhone => phone.sink.add;
  Stream<String?> get phoneStream => phone.stream.asBroadcastStream();

  final password = BehaviorSubject<String?>();
  Function(String?) get updatePassword => password.sink.add;
  Stream<String?> get passwordStream => password.stream.asBroadcastStream();

  final confirmPassword = BehaviorSubject<String?>();
  Function(String?) get updateConfirmPassword => confirmPassword.sink.add;
  Stream<String?> get confirmPasswordStream =>
      confirmPassword.stream.asBroadcastStream();

  final country = BehaviorSubject<CustomFieldModel?>();
  Function(CustomFieldModel?) get updateCountry => country.sink.add;
  Stream<CustomFieldModel?> get countryStream =>
      country.stream.asBroadcastStream();

  final agreeToTerms = BehaviorSubject<bool?>();
  Function(bool?) get updateAgreeToTerms => agreeToTerms.sink.add;
  Stream<bool?> get agreeToTermsStream => agreeToTerms.stream.asBroadcastStream();

  Stream<bool> get registerStream => Rx.combineLatest6(
          nameStream,
          emailStream,
          phoneStream,
          countryStream,
          passwordStream,
          confirmPasswordStream, (a, b, c, d, e, f) {
        if (Validations.name(a as String) == null &&
            Validations.mail(b as String) == null &&
            Validations.phone(c as String) == null &&
            Validations.field((d as CustomFieldModel).name, fieldName: getTranslated("country")) ==
                null &&
            Validations.firstPassword(e as String) == null &&
            Validations.confirmNewPassword(e, f as String) == null) {
          return true;
        }
        return false;
      });

  clear() {
    updateName(null);
    updateEmail(null);
    updatePhone(null);
    updateCountry(null);
    updatePassword(null);
    updateConfirmPassword(null);
    updateAgreeToTerms(null);
    updateProfileImage(null);
  }

  @override
  Future<void> close() {
    clear();
    return super.close();
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      if (agreeToTerms.valueOrNull != true) {
        return AppCore.showToast(
          getTranslated("oops_you_must_agree_to_terms_and_conditions"),
        );
      }

      Map<String, dynamic> data = {
        "name": name.valueOrNull,
        "email": email.valueOrNull,
        "phone": phone.valueOrNull,
        "password": password.valueOrNull,
        "country": country.valueOrNull ?? "KW",
      };

      if (profileImage.valueOrNull == null) {
        return AppCore.showToast(
          getTranslated("oops_you_have_to_select_profile_image"),
        );
      } else {
        data.addAll({
          "profile_image": MultipartFile.fromFileSync(profileImage.value!.path)
        });
      }
      emit(Loading());

      Either<ServerFailure, Response> response = await repo.register(data);

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.transparent));
        emit(Error());
      }, (success) {
        AppCore.showSnackBar(
          notification: AppNotification(
            message: getTranslated("register_success_description"),
            backgroundColor: Styles.ACTIVE,
            borderColor: Styles.ACTIVE,
          ),
        );

        CustomNavigator.push(Routes.verification,
            arguments: VerificationModel(
                email: email.valueOrNull,
                phone: phone.valueOrNull,
                countryCode: country.valueOrNull?.code,
                fromRegister: true));
        clear();
        emit(Done());
      });
    } catch (e) {
      AppCore.showSnackBar(
        notification: AppNotification(
          message: e.toString(),
          backgroundColor: Styles.IN_ACTIVE,
          borderColor: Styles.RED_COLOR,
        ),
      );
      emit(Error());
    }
  }
}
