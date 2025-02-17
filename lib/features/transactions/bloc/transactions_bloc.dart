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
import '../../../main_models/search_engine.dart';
import '../model/transactions_model.dart';
import '../repo/transactions_repo.dart';

class TransactionsBloc extends Bloc<AppEvent, AppState> {
  final TransactionsRepo repo;

  TransactionsBloc({required this.repo}) : super(Start()) {
    on<Click>(oClick);
  }

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

  List<TransactionModel>? _model;

  Future<void> oClick(Click event, Emitter<AppState> emit) async {
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
          await repo.getTransactions(_engine);

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        TransactionsModel? res = TransactionsModel.fromJson(success.data);

        if (_engine.currentPage == 0) {
          _model?.clear();
        }

        if (res.data != null && res.data!.isNotEmpty) {
          for (var transaction in res.data!) {
            _model?.removeWhere((e) => e.id == transaction.id);

            _model?.add(transaction);
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
}
