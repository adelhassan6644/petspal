import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
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

  final formKey = GlobalKey<FormState>();

  final profileImage = BehaviorSubject<File?>();
  Function(File?) get updateProfileImage => profileImage.sink.add;
  Stream<File?> get profileImageStream =>
      profileImage.stream.asBroadcastStream();

  TextEditingController nameTEC = TextEditingController();

  TextEditingController mailTEC = TextEditingController();

  TextEditingController phoneTEC = TextEditingController();

  final country = BehaviorSubject<String?>();
  Function(String?) get updateCountry => country.sink.add;
  Stream<String?> get countryStream => country.stream.asBroadcastStream();

  final agreeToTerms = BehaviorSubject<bool?>();
  Function(bool?) get updateAgreeToTerms => agreeToTerms.sink.add;
  Stream<bool?> get agreeToTermsStream =>
      agreeToTerms.stream.asBroadcastStream();

  clear() {
    nameTEC.clear();
    mailTEC.clear();
    phoneTEC.clear();
    updateCountry("SA");
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
        "name": nameTEC.text.trim(),
        "email": mailTEC.text.trim(),
        "phone_number": phoneTEC.text.trim(),
        // "country_code": country.valueOrNull?.toLowerCase() ?? "sa",
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
                email: mailTEC.text.trim(),
                phone: phoneTEC.text.trim(),
                countryCode: (country.valueOrNull ?? "sa").toLowerCase(),
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
