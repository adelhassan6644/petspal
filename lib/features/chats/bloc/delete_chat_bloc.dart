import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/app/localization/language_constant.dart';
import 'package:zurex/components/loading_dialog.dart';
import 'package:zurex/features/chats/bloc/chats_bloc.dart';
import 'package:zurex/navigation/custom_navigation.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';
import '../../../data/config/di.dart';
import '../repo/chats_repo.dart';

class DeleteChatBloc extends Bloc<AppEvent, AppState> {
  final ChatsRepo repo;

  DeleteChatBloc({required this.repo}) : super(Start()) {
    on<Delete>(onDelete);
  }

  Future<void> onDelete(Delete event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      loadingDialog();
      Either<ServerFailure, Response> response =
          await repo.deleteChat(event.arguments as int);
      CustomNavigator.pop();
      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        sl<ChatsBloc>().add(Delete(arguments: event.arguments as int));
        AppCore.showSnackBar(
            notification: AppNotification(
          message: getTranslated("the_chat_has_been_deleted_successfully"),
          backgroundColor: Styles.ACTIVE,
          borderColor: Styles.ACTIVE,
        ));
        emit(Done());
      });
    } catch (e) {
      CustomNavigator.pop();
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
