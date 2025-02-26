import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';
import '../../../data/internet_connection/internet_connection.dart';
import '../../../main_models/search_engine.dart';
import '../../products/model/products_model.dart';
import '../repo/wishlist_repo.dart';

class WishlistBloc extends HydratedBloc<AppEvent, AppState> {
  final WishlistRepo repo;
  final InternetConnection internetConnection;

  WishlistBloc({required this.repo, required this.internetConnection})
      : super(Start()) {
    controller = ScrollController();
    customScroll(controller);
    on<Click>(onClick);
    on<Update>(onUpdate);
  }

  bool get isLogin => repo.isLogin;

  List<ProductModel>? model;
  late ScrollController controller;
  late SearchEngine _engine;
  customScroll(ScrollController controller) {
    controller.addListener(() {
      bool scroll = AppCore.scrollListener(
          controller, _engine.maxPages, _engine.currentPage!);
      if (scroll) {
        _engine.updateCurrentPage(_engine.currentPage!);
        add(Click(arguments: _engine));
      }
    });
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    if (await internetConnection.updateConnectivityStatus()) {
      try {
        _engine = event.arguments as SearchEngine;
        if (_engine.currentPage == 0) {
          model = [];
          if (!_engine.isUpdate) {
            emit(Loading());
          }
        } else {
          emit(Done(data: model, loading: true));
        }

        Either<ServerFailure, Response> response =
            await repo.getWishlist(_engine);

        response.fold((fail) {
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.red));
          emit(Error());
        }, (success) {
          ProductsModel? res = ProductsModel.fromJson(success.data);

          if (_engine.currentPage == 0) {
            model?.clear();
          }

          if (res.data != null && res.data!.isNotEmpty) {
            for (var item in res.data!) {
              model?.removeWhere((e) => e.id == item.id);
              model?.add(item);
            }
            _engine.maxPages = res.meta?.pagesCount ?? 1;
            _engine.updateCurrentPage(res.meta?.currentPage ?? 1);
          }

          if (model != null && model!.isNotEmpty) {
            emit(Done(list: model, loading: false));
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

  Future<void> onUpdate(Update event, Emitter<AppState> emit) async {
    try {
      Map data = event.arguments as Map;
      Either<ServerFailure, Response> response =
          await repo.updateWishlist((data["product"] as ProductModel).id);

      response.fold((fail) {
        AppCore.showToast(fail.error);
      }, (success) {
        if (data["isFav"]) {
          model?.removeWhere(
              (e) => e.id == (data["product"] as ProductModel).id);
        } else {
          model ??= [];
          model?.add((data["product"] as ProductModel));
        }

        if (model != null && model!.isNotEmpty) {
          emit(Done(list: model, loading: false));
        } else {
          emit(Empty());
        }
      });
    } catch (e) {
      AppCore.showToast(e.toString());
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
          list: List<ProductModel>.from(
              jsonDecode(json['list']).map((e) => ProductModel.fromJson(e))),
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
