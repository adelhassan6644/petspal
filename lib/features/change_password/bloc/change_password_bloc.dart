import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/app/localization/language_constant.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';
import '../../../../navigation/custom_navigation.dart';
import '../repo/change_password_repo.dart';

class ChangePasswordBloc extends Bloc<AppEvent, AppState> {
  final ChangePasswordRepo repo;
  ChangePasswordBloc({required this.repo}) : super(Start()) {
    on<Click>(_onChangePassword);
  }

  TextEditingController currentPasswordTEC = TextEditingController();
  TextEditingController newPasswordTEC = TextEditingController();
  TextEditingController confirmNewPasswordTEC = TextEditingController();

  clear() {
    currentPasswordTEC.clear();
    newPasswordTEC.clear();
    confirmNewPasswordTEC.clear();
  }

  _onChangePassword(AppEvent event, Emitter emit) async {
    try {
      emit(Loading());
      Map<String, dynamic> data = {
        "old_password": currentPasswordTEC.text.trim(),
        "password": newPasswordTEC.text.trim(),
      };

      Either<ServerFailure, Response> response =
          await repo.changePassword(data);

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        CustomNavigator.pop();
        AppCore.showSnackBar(
            notification: AppNotification(
                message: getTranslated("your_password_changed_successfully"),
                backgroundColor: Styles.ACTIVE,
                borderColor: Styles.ACTIVE,
                isFloating: true));
        emit(Done());
      });
    } catch (e) {
      AppCore.showSnackBar(
          notification: AppNotification(
        message: e.toString(),
        backgroundColor: Styles.IN_ACTIVE,
        borderColor: Styles.RED_COLOR,
      ));
      emit(Error());
    }
  }
}
