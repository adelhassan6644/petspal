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
import '../../../../data/error/failures.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';
import '../../verification/model/verification_model.dart';
import '../repo/forget_password_repo.dart';

class ForgetPasswordBloc extends Bloc<AppEvent, AppState> {
  final ForgetPasswordRepo repo;

  ForgetPasswordBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
  }

  final formKey = GlobalKey<FormState>();
  final FocusNode emailNode = FocusNode();

  final email = BehaviorSubject<String?>();
  Function(String?) get updateEmail => email.sink.add;
  Stream<String?> get emailStream => email.stream.asBroadcastStream();

  clear() {
    updateEmail(null);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Map<String, dynamic> data = {
        "email": email.valueOrNull,
      };
      Either<ServerFailure, Response> response =
          await repo.forgetPassword(data);

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        CustomNavigator.push(Routes.verification,
            arguments: VerificationModel(
                email: email.valueOrNull, fromRegister: false));
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
