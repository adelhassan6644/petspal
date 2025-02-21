import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/features/auth/login/entity/login_entity.dart';
import 'package:rxdart/rxdart.dart';
import 'package:petspal/features/auth/verification/model/verification_model.dart';

import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
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

  final loginEntity = BehaviorSubject<LoginEntity?>();
  Function(LoginEntity?) get updateLoginEntity => loginEntity.sink.add;
  Stream<LoginEntity?> get loginEntityStream =>
      loginEntity.stream.asBroadcastStream();

  bool isBodyValid() {
    for (var entry in (loginEntity.valueOrNull?.toJson() ?? {}).entries) {
      final value = entry.value;
      if (value == null || (value is String && value.trim().isEmpty)) {
        return false;
      }
    }
    return true;
  }

  final rememberMe = BehaviorSubject<bool?>();
  Function(bool?) get updateRememberMe => rememberMe.sink.add;
  Stream<bool?> get rememberMeStream => rememberMe.stream.asBroadcastStream();

  clear() {
    updateLoginEntity(LoginEntity(
      email: TextEditingController(),
      password: TextEditingController(),
    ));
    updateRememberMe(false);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Either<ServerFailure, Response> response =
          await repo.logIn(loginEntity.valueOrNull!.toJson());

      response.fold((fail) {
        if (fail.statusCode == 406) {
          CustomSimpleDialog.parentSimpleDialog(
            canDismiss: false,
            withContentPadding: false,
            customWidget: ActivationDialog(
                email: loginEntity.valueOrNull?.email?.text.trim() ?? ""),
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
          repo.saveCredentials(loginEntity.valueOrNull!.toJson());
        }

        if (success.data['data'] != null &&
            success.data['data']["email_verified_at"] == null) {
          CustomNavigator.push(
            Routes.verification,
            arguments: VerificationModel(
                email: loginEntity.valueOrNull?.email?.text.trim() ?? "",
                fromRegister: true),
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
      updateLoginEntity(LoginEntity(
        email: TextEditingController(text: data["email"]),
        password: TextEditingController(text: data["password"]),
      ));
      updateRememberMe(data["email"] != "" && data["password"] != null);
      emit(Done());
    }
  }

  Future<void> onAdd(Add event, Emitter<AppState> emit) async {
    repo.guestMode();
    CustomNavigator.push(Routes.dashboard, clean: true, arguments: 0);
  }
}
