import 'dart:convert';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:petspal/features/best_seller/repo/best_seller_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../app/core/app_core.dart';
import '../../../../../app/core/app_event.dart';
import '../../../../../app/core/app_notification.dart';
import '../../../../../app/core/app_state.dart';
import '../../../../../app/core/styles.dart';
import '../../../../../data/error/failures.dart';
import '../../../../../main_models/search_engine.dart';
import '../../../data/internet_connection/internet_connection.dart';
import '../../products/model/products_model.dart';

class BestSellerBloc extends HydratedBloc<AppEvent, AppState> {
  final BestSellerRepo repo;
  final InternetConnection internetConnection;

  BestSellerBloc({required this.repo, required this.internetConnection})
      : super(Start()) {
    controller = ScrollController();
    customScroll(controller);
    on<Click>(onClick);
  }

  late ScrollController controller;
  late SearchEngine _engine;
  List<ProductModel>? model;
  TextEditingController? searchTEC;

  final selectCategory = BehaviorSubject<int?>();
  Function(int?) get updateSelectCategory => selectCategory.sink.add;
  Stream<int?> get selectCategoryStream =>
      selectCategory.stream.asBroadcastStream();

  final goingDown = BehaviorSubject<bool>();
  Function(bool) get updateGoingDown => goingDown.sink.add;
  Stream<bool> get goingDownStream => goingDown.stream.asBroadcastStream();

  customScroll(ScrollController controller) {
    controller.addListener(() {
      if (controller.position.userScrollDirection == ScrollDirection.forward) {
        updateGoingDown(false);
      } else {
        updateGoingDown(true);
      }
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

        _engine.data = {
          if (searchTEC?.text.trim() != "") "keyword": searchTEC?.text.trim(),
          if (selectCategory.valueOrNull != null)
            "category_id": selectCategory.valueOrNull,
        };

        Either<ServerFailure, Response> response =
            await repo.getBestSellers(_engine);

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

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    try {
      if (json['state'] == "Start") {
        return Start();
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
