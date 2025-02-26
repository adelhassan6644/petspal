import 'dart:convert';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../../app/core/app_core.dart';
import '../../../../../app/core/app_event.dart';
import '../../../../../app/core/app_notification.dart';
import '../../../../../app/core/app_state.dart';
import '../../../../../app/core/styles.dart';
import '../../../../../data/error/failures.dart';
import '../../../data/internet_connection/internet_connection.dart';
import '../../../main_models/search_engine.dart';
import '../model/brands_model.dart';
import '../repo/brands_repo.dart';

class BrandsBloc extends HydratedBloc<AppEvent, AppState> {
  final BrandsRepo repo;
  final InternetConnection internetConnection;

  BrandsBloc({required this.internetConnection, required this.repo})
      : super(Start()) {
    controller = ScrollController();
    customScroll(controller);
    on<Click>(onClick);
  }

  late SearchEngine _engine;
  late ScrollController controller;
  List<BrandModel>? model;

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
            await repo.getBrands(_engine);

        response.fold((fail) {
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.red));
          emit(Error());
        }, (success) {
          BrandsModel? res = BrandsModel.fromJson(success.data);

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
          list: List<BrandModel>.from(
              jsonDecode(json['list']).map((e) => BrandModel.fromJson(e))),
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
