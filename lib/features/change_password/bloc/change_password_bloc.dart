import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/localization/language_constant.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';
import '../../../../navigation/custom_navigation.dart';
import '../entity/change_password_entity.dart';
import '../repo/change_password_repo.dart';

class ChangePasswordBloc extends Bloc<AppEvent, AppState> {
  final ChangePasswordRepo repo;
  ChangePasswordBloc({required this.repo}) : super(Start()) {
    on<Click>(_onChangePassword);
  }

  final formKey = GlobalKey<FormState>();
  final FocusNode currentPasswordNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final FocusNode confirmPasswordNode = FocusNode();

  final changePasswordEntity = BehaviorSubject<ChangePasswordEntity?>();
  Function(ChangePasswordEntity?) get updateChangePasswordEntity => changePasswordEntity.sink.add;
  Stream<ChangePasswordEntity?> get changePasswordEntityStream => changePasswordEntity.stream.asBroadcastStream();

  bool isBodyValid() {
    for (var entry
        in (changePasswordEntity.valueOrNull?.toJson() ?? {}).entries) {
      final value = entry.value;
      if (value == null || (value is String && value.trim().isEmpty)) {
        return false;
      }
    }
    return true;
  }

  clear() {
    updateChangePasswordEntity(null);
  }

  _onChangePassword(AppEvent event, Emitter emit) async {
    if (isBodyValid()) {
      try {
        emit(Loading());

        Either<ServerFailure, Response> response = await repo
            .changePassword(changePasswordEntity.valueOrNull!.toJson());

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
}
