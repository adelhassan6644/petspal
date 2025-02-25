import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/loading_dialog.dart';
import '../../../main_models/search_engine.dart';
import '../../../navigation/custom_navigation.dart';
import '../model/notifications_model.dart';
import '../repo/notifications_repo.dart';

class NotificationsBloc extends Bloc<AppEvent, AppState> {
  final NotificationsRepo repo;

  NotificationsBloc({required this.repo}) : super(Start()) {
    controller = ScrollController();
    customScroll();
    on<Get>(onGet);
    on<Read>(onRead);
    on<Delete>(onDelete);
  }

  late ScrollController controller;
  late SearchEngine _engine;

  customScroll() {
    controller.addListener(() {
      bool scroll = AppCore.scrollListener(
          controller, _engine.maxPages, _engine.currentPage!);
      if (scroll) {
        _engine.updateCurrentPage(_engine.currentPage!);
        add(Click(arguments: _engine));
      }
    });
  }

  bool get isLogin => repo.isLogin;

  List<NotificationModel>? _model;

  Future<void> onGet(Get event, Emitter<AppState> emit) async {
    try {
      _engine = event.arguments as SearchEngine;
      if (_engine.currentPage == 0) {
        _model = [];
        if (!_engine.isUpdate) {
          emit(Loading());
        }
      } else {
        emit(Done(list: _model, loading: true));
      }

      Either<ServerFailure, Response> response =
      await repo.getNotifications(_engine);

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        NotificationsModel? res = NotificationsModel.fromJson(success.data);

        if (_engine.currentPage == 0) {
          _model?.clear();
        }

        if (res.data != null && res.data!.isNotEmpty) {
          for (var notification in res.data!) {
            _model?.removeWhere((e) => e.id == notification.id);

            _model?.add(notification);
          }

          _engine.maxPages = res.meta?.pagesCount ?? 1;
          _engine.updateCurrentPage(res.meta?.currentPage ?? 1);
        }
        if (_model != null && _model!.isNotEmpty) {
          emit(Done(list: _model, loading: false));
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

  Future<void> onRead(Read event, Emitter<AppState> emit) async {
    await repo.readNotification(event.arguments as String);

    _model?.forEach((e) {
      if (e.id == event.arguments as String) {
        e.isRead = true;
      }
    });
    if (_model != null && _model!.isNotEmpty) {
      emit(Done(list: _model, loading: false));
    } else {
      emit(Empty());
    }
  }

  Future<void> onDelete(Delete event, Emitter<AppState> emit) async {
    try {
      loadingDialog();
      Either<ServerFailure, Response> response =
      await repo.deleteNotification(event.arguments as String);
      CustomNavigator.pop();

      response.fold((fail) {
        AppCore.showToast(fail.error);
      }, (success) {
        AppCore.showToast(getTranslated("notification_deleted_successfully"));
        _model?.removeWhere((e) => e.id == event.arguments as String);

        if (_model != null && _model!.isNotEmpty) {
          emit(Done(list: _model, loading: false));
        } else {
          emit(Empty());
        }
      });
    } catch (e) {
      CustomNavigator.pop();
      AppCore.showToast(e.toString());
    }
  }
}
