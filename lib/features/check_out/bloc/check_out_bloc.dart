import 'dart:io';

import 'package:petspal/features/check_out/repo/check_out_interface_repo.dart';
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
import '../../../app/localization/language_constant.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';

class CheckOutBloc extends Bloc<AppEvent, AppState> {
  final CheckOutInterfaceRepo repo;

  CheckOutBloc({required this.repo}) : super(Start()) {
    updatePaymentType(PaymentType.onlinePayment);
    on<Click>(onClick);
  }

  final paymentType = BehaviorSubject<PaymentType>();
  Function(PaymentType) get updatePaymentType => paymentType.sink.add;
  Stream<PaymentType> get paymentTypeStream =>
      paymentType.stream.asBroadcastStream();

  final image = BehaviorSubject<File?>();
  Function(File?) get updateImage => image.sink.add;
  Stream<File?> get imageStream => image.stream.asBroadcastStream();

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      Map<String, dynamic> data = event.arguments as Map<String, dynamic>;
      if (paymentType.valueOrNull == PaymentType.byBankTransfer) {
        if (image.valueOrNull != null) {
          data.addAll({
            "bank_transfer":
                MultipartFile.fromFileSync(image.valueOrNull!.path),
          });
        } else {
          return AppCore.showToast(
              getTranslated("oops_you_have_to_upload_bank_transfer_image"));
        }
      }

      emit(Loading());

      Either<ServerFailure, Response> response = await repo.checkOut(data);
      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        if (paymentType.valueOrNull == PaymentType.byBankTransfer) {
          CustomNavigator.pop();
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: getTranslated("your_request_under_review"),
                  isFloating: true,
                  backgroundColor: Styles.ACTIVE,
                  borderColor: Colors.green));
          emit(Done());
        } else {
          if (success.data["data"] != null &&
              success.data["data"]["url"] != null) {
            CustomNavigator.push(Routes.payment,
                arguments: success.data["data"]["url"]);
            emit(Done());
          } else {
            AppCore.showSnackBar(
              notification: AppNotification(
                message: getTranslated("something_went_wrong"),
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Styles.RED_COLOR,
              ),
            );
            emit(Error());
          }
        }
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

enum PaymentType { onlinePayment, byBankTransfer }
