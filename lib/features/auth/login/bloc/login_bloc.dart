import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:petspal/features/auth/verification/model/verification_model.dart';

import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_simple_dialog.dart';
import '../../../../data/error/failures.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';
import '../../activation_account/view/activation_dialog.dart';
import '../repo/login_repo.dart';

class LoginBloc extends Bloc<AppEvent, AppState> {
  final LoginRepo repo;
  LoginBloc({required this.repo}) : super(Start()) {
    updateRememberMe(false);

    on<Add>(onAdd);
    on<Click>(onClick);
    on<Remember>(onRemember);
  }

  final formKey = GlobalKey<FormState>();
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();

  final email = BehaviorSubject<String?>();
  Function(String?) get updateEmail => email.sink.add;
  Stream<String?> get emailStream => email.stream.asBroadcastStream();

  final password = BehaviorSubject<String?>();
  Function(String?) get updatePassword => password.sink.add;
  Stream<String?> get passwordStream => password.stream.asBroadcastStream();

  Stream<bool> get loginStream =>
      Rx.combineLatest2(emailStream, passwordStream, (n, p) {
        if (Validations.mail(n as String) == null &&
            Validations.password(p) == null) {
          return true;
        }
        return false;
      });

  final rememberMe = BehaviorSubject<bool?>();
  Function(bool?) get updateRememberMe => rememberMe.sink.add;
  Stream<bool?> get rememberMeStream => rememberMe.stream.asBroadcastStream();

  clear() {
    updateEmail(null);
    updatePassword(null);
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
      Map<String, dynamic> data = {
        "email": email.valueOrNull?.trim(),
        "password": password.valueOrNull?.trim(),
      };

      Either<ServerFailure, Response> response = await repo.logIn(data);

      response.fold((fail) {
        if (fail.statusCode == 406) {
          CustomSimpleDialog.parentSimpleDialog(
            canDismiss: false,
            withContentPadding: false,
            customWidget:
                ActivationDialog(email: email.valueOrNull?.trim() ?? ""),
          );
        } else {
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: getTranslated("invalid_credentials"),
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.transparent));
        }
        emit(Error());
      }, (success) {
        if (rememberMe.valueOrNull == true) {
          repo.saveCredentials(data);
        }

        if (success.data['data'] != null &&
            success.data['data']["email_verified_at"] == null) {
          CustomNavigator.push(
            Routes.verification,
            arguments: VerificationModel(
                email: email.valueOrNull?.trim() ?? "", fromRegister: true),
          );
        } else {
          CustomNavigator.push(Routes.dashboard, clean: true, arguments: 0);
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
      updateEmail(data["email"]);
      updatePassword(data["password"]);
      updateRememberMe(data["email"] != "" && data["password"] != null);
      emit(Done());
    }
  }

  Future<void> onAdd(Add event, Emitter<AppState> emit) async {
    repo.guestMode();
    CustomNavigator.push(Routes.dashboard, clean: true, arguments: 0);
  }
}
