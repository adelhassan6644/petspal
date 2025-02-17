import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zurex/components/custom_simple_dialog.dart';
import 'package:zurex/features/auth/verification/model/verification_model.dart';

import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../data/error/failures.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';
import '../../activation_account/view/activation_dialog.dart';
import '../repo/login_repo.dart';

class LoginBloc extends Bloc<AppEvent, AppState> {
  final rememberMe = BehaviorSubject<bool?>();

  final LoginRepo repo;
  LoginBloc({required this.repo}) : super(Start()) {
    updateRememberMe(false);

    on<Add>(onAdd);
    on<Click>(onClick);
    on<Remember>(onRemember);
  }

  final formKey = GlobalKey<FormState>();
  final FocusNode phoneNode = FocusNode();
  // final FocusNode passwordNode = FocusNode();

  TextEditingController phoneTEC = TextEditingController();

  // final country = BehaviorSubject<String?>();
  // Function(String?) get updateCountry => country.sink.add;
  // Stream<String?> get countryStream => country.stream.asBroadcastStream();

  Function(bool?) get updateRememberMe => rememberMe.sink.add;
  Stream<bool?> get rememberMeStream => rememberMe.stream.asBroadcastStream();

  clear() {
    phoneTEC.clear();
    // updateCountry(null);
    updateRememberMe(false);
  }

  @override
  Future<void> close() {
    updateRememberMe(false);
    return super.close();
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      Map<String, dynamic> data = {"phone_number": phoneTEC.text.trim()};

      Either<ServerFailure, Response> response = await repo.logIn(data);

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: getTranslated("invalid_phone"),
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.transparent));
        emit(Error());
      }, (success) {
        if (success.statusCode == 406) {
          CustomSimpleDialog.parentSimpleDialog(
            canDismiss: false,
            withContentPadding: false,
            customWidget: ActivationDialog(phone: phoneTEC.text.trim()),
          );
        } else {
          CustomNavigator.push(
            Routes.verification,
            arguments: VerificationModel(
              phone: phoneTEC.text.trim(),
              fromRegister: false,
              fromComplete: success.statusCode == 400,
            ),
          );
        }

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

  Future<void> onRemember(Remember event, Emitter<AppState> emit) async {
    Map<String, dynamic>? data = repo.getCredentials();
    if (data != null) {
      // passwordTEC.text = data["password"];
      phoneTEC.text = data["phone"];
      updateRememberMe(data["phone"] != "" && data["password"] != null);
      emit(Done());
    }
  }

  Future<void> onAdd(Add event, Emitter<AppState> emit) async {
    repo.guestMode();
    CustomNavigator.push(Routes.dashboard, clean: true, arguments: 0);
  }
}
