import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/navigation/custom_navigation.dart';
import 'package:petspal/navigation/routes.dart';
import 'package:geolocator/geolocator.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../data/config/di.dart';
import '../../../helpers/permissions.dart';
import '../../../main_blocs/user_bloc.dart';
import '../../setting/bloc/setting_bloc.dart';
import '../repo/splash_repo.dart';

class SplashBloc extends Bloc<AppEvent, AppState> {
  final SplashRepo repo;
  SplashBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
  }

  Future<void> onClick(AppEvent event, Emitter<AppState> emit) async {
    Future.delayed(const Duration(milliseconds: 2000), () async {
      ///Ask Notification Permission
      PermissionHandler.checkNotificationsPermission();

      ///Ask Location Permission
      Geolocator.requestPermission();

      ///Get Setting
      // sl<SettingBloc>().add(Get());
      if (repo.isLogin) {
        UserBloc.instance.add(Click());
      } else {
        if (!kDebugMode) {
          await repo.guestMode();
        }
      }


      // if (repo.isFirstTime) {
      //   CustomNavigator.push(Routes.onBoarding, clean: true);
      // } else
        if (!repo.isLogin) {
        CustomNavigator.push(Routes.login, clean: true);
      } else {
        CustomNavigator.push(Routes.dashboard, clean: true, arguments: 0);
      }
      repo.setFirstTime();
    });
  }
}
