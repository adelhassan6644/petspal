import 'package:petspal/features/countries/repo/countries_repo.dart';
import 'package:petspal/main_models/custom_field_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../app/core/app_core.dart';
import '../../../../../../../app/core/app_event.dart';
import '../../../../../../../app/core/app_notification.dart';
import '../../../../../../../app/core/app_state.dart';
import '../../../../../../../app/core/styles.dart';
import '../../../../../../../data/error/failures.dart';

class CountriesBloc extends Bloc<AppEvent, AppState> {
  final CountriesRepo repo;

  CountriesBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Either<ServerFailure, Response> response = await repo.getCountries();

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        CustomFieldsModel? model = CustomFieldsModel.fromJson(success.data);

        if (model.data != null && model.data!.isNotEmpty) {
          emit(Done(list: model.data, loading: false));
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
