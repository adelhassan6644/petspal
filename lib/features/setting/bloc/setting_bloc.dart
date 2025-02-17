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
import '../../../data/error/failures.dart';
import '../model/setting_model.dart';
import '../repo/setting_repo.dart';

class SettingBloc extends Bloc<AppEvent, AppState> {
  final SettingRepo repo;

  SettingBloc({required this.repo}) : super(Start()) {
    on<Get>(onGet);
  }

  final configVideo = BehaviorSubject<String>();
  Function(String) get updateConfigVideo => configVideo.sink.add;
  Stream<String> get configVideoStream =>
      configVideo.stream.asBroadcastStream();

  // Future<void> onClick(Click event, Emitter<AppState> emit) async {
  //   String video = repo.getConfigVideo;
  //   updateConfigVideo(video);
  // }

  SettingModel? model;

  Future<void> onGet(Get event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      Either<ServerFailure, Response> response = await repo.getSetting();

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.transparent));
        emit(Error());
      }, (success) {
        model = SettingModel.fromJson(success.data["data"]);
        repo.cacheSplashVideo(model?.general?.splashVideo ?? "");

        emit(Done(model: model));
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
