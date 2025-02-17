import 'package:zurex/components/loading_dialog.dart';
import 'package:zurex/navigation/custom_navigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_state.dart';
import '../../../data/config/di.dart';
import '../repo/notifications_repo.dart';

class TurnNotificationsBloc extends Bloc<AppEvent, AppState> {
  final NotificationsRepo repo;

  TurnNotificationsBloc({required this.repo}) : super(Start()) {
    on<Turn>(onTurn);
  }

  bool get isLogin => repo.isLogin;
  bool get isTurnOn => repo.isTurnOn;

  Future<void> onTurn(Turn event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      loadingDialog();
      await repo.switchNotification();
      CustomNavigator.pop();
      emit(Done());
    } catch (e) {
      CustomNavigator.pop();
      AppCore.showToast(e.toString());
      emit(Error());
    }
  }
}
