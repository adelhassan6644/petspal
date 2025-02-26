import 'dart:convert';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:petspal/features/products/repo/products_repo.dart';
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

class MarketplaceBloc extends Bloc<AppEvent, AppState> {
  final InternetConnection internetConnection;

  MarketplaceBloc({required this.internetConnection}) : super(Start()) {
    controller = ScrollController();
    customScroll(controller);
  }

  late ScrollController controller;
  final selectType = BehaviorSubject<int?>();
  Function(int?) get updateSelectType => selectType.sink.add;
  Stream<int?> get selectTypeStream => selectType.stream.asBroadcastStream();

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
    });
  }
}
