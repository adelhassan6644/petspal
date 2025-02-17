import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/components/loading_dialog.dart';
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
import '../repo/activation_account_repo.dart';

class ActivationAccountBloc extends Bloc<AppEvent, AppState> {
  final ActivationAccountRepo repo;

  ActivationAccountBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      loadingDialog();
      Map<String, dynamic> data = {"phone_number": event.arguments as String};

      Either<ServerFailure, Response> response =
          await repo.activateAccount(data);
      CustomNavigator.pop();

      response.fold((fail) {
        AppCore.showToast(getTranslated("something_went_wrong"));
        emit(Error());
      }, (success) {
        CustomNavigator.push(
          Routes.verification,
          arguments: VerificationModel(
            phone: event.arguments as String,
            fromRegister: false,
            fromComplete: false,
          ),
        );
        emit(Done());
      });
    } catch (e) {
      CustomNavigator.pop();
      AppCore.showToast(getTranslated("something_went_wrong"));
      emit(Error());
    }
  }
}
