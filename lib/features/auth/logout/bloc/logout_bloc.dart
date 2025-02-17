import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';
import '../repo/logout_repo.dart';

class LogoutBloc extends Bloc<AppEvent, AppState> {
  final LogoutRepo repo;

  LogoutBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
  }
  bool get isLogin => repo.isLogin;

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      bool response = await repo.logOut();
      if (response == true) {
        CustomNavigator.push(Routes.splash, clean: true);
        AppCore.showSnackBar(
          notification: AppNotification(
            message: getTranslated("you_logged_out_successfully"),
            backgroundColor: Styles.ACTIVE,
            borderColor: Styles.ACTIVE,
          ),
        );
        emit(Done());
      } else {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: getTranslated("something_went_wrong"),
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.transparent));
        emit(Error());
      }
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
