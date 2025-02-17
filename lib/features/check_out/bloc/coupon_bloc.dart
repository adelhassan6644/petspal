import 'package:zurex/features/check_out/repo/check_out_interface_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/core/app_core.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_notification.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../data/error/failures.dart';
import '../model/price_details_model.dart';

class CouponBloc extends Bloc<AppEvent, AppState> {
  final CheckOutInterfaceRepo repo;
  CouponBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
    on<Update>(onUpdate);
  }

  final TextEditingController couponTEC = TextEditingController();

  final coupon = BehaviorSubject<String?>();
  Function(String?) get updateCoupon => coupon.sink.add;
  Stream<String?> get couponStream => coupon.stream.asBroadcastStream();

  clear() {
    couponTEC.clear();
    updateCoupon(null);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      Either<ServerFailure, Response> response = await repo.applyCoupon(
        event.arguments as int,
        couponTEC.text.trim(),
      );
      response.fold((fail) {
        if (fail.statusCode != 422) {
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.red));
        }
        emit(Error());
      }, (success) {
        if (success.data["data"] != null) {
          PriceDetailsModel model =
              PriceDetailsModel.fromJson(success.data["data"]);
          emit(Done(model: model));
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

  Future<void> onUpdate(Update event, Emitter<AppState> emit) async {
    clear();
    emit(Start());
  }
}
