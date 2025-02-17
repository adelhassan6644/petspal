import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../app/core/app_event.dart';
import '../../app/core/app_state.dart';
import '../../data/config/di.dart';

class DashboardBloc extends Bloc<AppEvent, AppState> {
  DashboardBloc() : super(Start()) {
    updateSelectIndex(0);
  }

  static DashboardBloc get instance => sl<DashboardBloc>();

  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  final selectIndex = BehaviorSubject<int>();
  updateSelectIndex(int v) {
    selectIndex.sink.add(v);
  }

  Stream<int> get selectIndexStream => selectIndex.stream.asBroadcastStream();
}
