import 'package:zurex/features/feedbacks/repo/feedbacks_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../app/core/app_core.dart';
import '../../../../../app/core/app_event.dart';
import '../../../../../app/core/app_notification.dart';
import '../../../../../app/core/app_state.dart';
import '../../../../../app/core/styles.dart';
import '../../../../../data/error/failures.dart';
import '../../../../../main_models/search_engine.dart';
import '../model/feedback_model.dart';

class FeedbacksBloc extends Bloc<AppEvent, AppState> {
  final FeedbacksRepo repo;

  FeedbacksBloc({required this.repo}) : super(Start()) {
    controller = ScrollController();
    customScroll(controller);
    on<Click>(onClick);
    on<Update>(onUpdate);
  }

  late SearchEngine _engine;
  List<FeedbackModel>? model;

  late ScrollController controller;
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
          await repo.getFeedbacks(_engine);

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        FeedbacksModel? res = FeedbacksModel.fromJson(success.data);

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
          emit(Done(data: model, loading: false));
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

  Future<void> onUpdate(Update event, Emitter<AppState> emit) async {
    model?.add(event.arguments as FeedbackModel);
    if (model != null && model!.isNotEmpty) {
      emit(Done(data: model, loading: false));
    } else {
      emit(Empty());
    }
  }
}
