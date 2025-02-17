import 'package:zurex/main_repos/country_states_repo.dart';
import 'package:zurex/main_models/custom_field_model.dart';
import 'package:country_state_city/models/state.dart' as states_of_country;
import 'package:country_state_city/utils/state_utils.dart';
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

class CountryStatesBloc extends Bloc<AppEvent, AppState> {
  final CountryStatesRepo repo;

  CountryStatesBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      List<states_of_country.State> list =
          await getStatesOfCountry(event.arguments as String);
      if (list.isEmpty) {
        emit(Empty());
      } else {
        emit(Done(data: list, loading: false));
      }

      // Either<ServerFailure, Response> response =
      //     await repo.getCountryStates(event.arguments as String);
      //
      // response.fold((fail) {
      //   AppCore.showSnackBar(
      //       notification: AppNotification(
      //           message: fail.error,
      //           isFloating: true,
      //           backgroundColor: Styles.IN_ACTIVE,
      //           borderColor: Colors.red));
      //   emit(Error());
      // }, (success) {
      //   CustomFieldModel? model = CustomFieldModel.fromJson(success.data);
      //
      //   if (model.data != null && model.data!.isNotEmpty) {
      //     emit(Done(data: model.data, loading: false));
      //   } else {
      //     emit(Empty());
      //   }
      // });
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
