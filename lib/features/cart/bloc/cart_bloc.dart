import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../app/core/app_core.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_notification.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/loading_dialog.dart';
import '../../../data/error/failures.dart';
import '../../../data/internet_connection/internet_connection.dart';
import '../../../navigation/custom_navigation.dart';
import '../model/cart_model.dart';
import '../repo/cart_repo.dart';

class CartBloc extends HydratedBloc<AppEvent, AppState> {
  final CartRepo repo;
  final InternetConnection internetConnection;
  CartBloc({required this.repo, required this.internetConnection})
      : super(Start()) {
    on<Get>(onGet);
    on<Add>(onAdd);
    on<Update>(onUpdate);
    on<Delete>(onDelete);
  }

  Future<void> onGet(Get event, Emitter<AppState> emit) async {
    if (await internetConnection.updateConnectivityStatus()) {
      try {
        emit(Loading());

        Either<ServerFailure, Response> response = await repo.getCartItems();

        response.fold((fail) {
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.red));
          emit(Error());
        }, (success) {
          if (success.data["data"] != null) {
            CartModel model = CartModel.fromJson(success.data["data"]);

            emit(Done(model: model));
          } else {
            emit(Empty());
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

  Future<void> onAdd(Add event, Emitter<AppState> emit) async {
    try {
      loadingDialog();

      Either<ServerFailure, Response> response =
          await repo.addToCart(event.arguments as Map<String, dynamic>);
      CustomNavigator.pop();
      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        if (success.data["data"] != null) {
          CartModel model = CartModel.fromJson(success.data["data"]);

          emit(Done(model: model));
        } else {
          emit(Empty());
        }
        AppCore.showSnackBar(
            notification: AppNotification(
          message: getTranslated("added_to_cart"),
          backgroundColor: Styles.ACTIVE,
          borderColor: Styles.ACTIVE,
        ));
      });
    } catch (e) {
      CustomNavigator.pop();
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
    try {
      loadingDialog();
      Either<ServerFailure, Response> response =
          await repo.updateCart(event.arguments as Map<String, dynamic>);
      CustomNavigator.pop();
      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        if (success.data["data"] != null) {
          CartModel model = CartModel.fromJson(success.data["data"]);

          emit(Done(model: model));
        } else {
          emit(Empty());
        }
        AppCore.showSnackBar(
            notification: AppNotification(
          message: getTranslated("cart_updated"),
          backgroundColor: Styles.ACTIVE,
          borderColor: Styles.ACTIVE,
        ));
      });
    } catch (e) {
      CustomNavigator.pop();
      AppCore.showSnackBar(
          notification: AppNotification(
        message: e.toString(),
        backgroundColor: Styles.IN_ACTIVE,
        borderColor: Styles.RED_COLOR,
      ));
      emit(Error());
    }
  }

  Future<void> onDelete(Delete event, Emitter<AppState> emit) async {
    try {
      loadingDialog();
      Either<ServerFailure, Response> response =
          await repo.removeFromCart(event.arguments as int);
      CustomNavigator.pop();
      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        if (success.data["data"] != null) {
          CartModel model = CartModel.fromJson(success.data["data"]);

          emit(Done(model: model));
        } else {
          emit(Empty());
        }
        AppCore.showSnackBar(
            notification: AppNotification(
          message: getTranslated("cart_updated"),
          backgroundColor: Styles.ACTIVE,
          borderColor: Styles.ACTIVE,
        ));
      });
    } catch (e) {
      CustomNavigator.pop();
      AppCore.showSnackBar(
          notification: AppNotification(
        message: e.toString(),
        backgroundColor: Styles.IN_ACTIVE,
        borderColor: Styles.RED_COLOR,
      ));
      emit(Error());
    }
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    try {
      if (json['state'] == "Start") {
        return Loading();
      }
      if (json['state'] == "Error") {
        return Error();
      }
      if (json['state'] == "Loading") {
        return Loading();
      }
      if (json['state'] == "Done") {
        return Done(
          model: CartModel.fromJson(jsonDecode(json['model'])),
          loading: jsonDecode(json['loading']) as bool,
        );
      }
      return Loading();
    } catch (e) {
      return Error();
    }
  }

  @override
  Map<String, dynamic>? toJson(AppState? state) => state?.toJson();
}
