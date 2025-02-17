import 'package:zurex/app/localization/language_constant.dart';
import 'package:zurex/features/feedbacks/repo/feedbacks_repo.dart';
import 'package:zurex/navigation/custom_navigation.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../app/core/app_core.dart';
import '../../../../../app/core/app_event.dart';
import '../../../../../app/core/app_notification.dart';
import '../../../../../app/core/app_state.dart';
import '../../../../../app/core/styles.dart';
import '../../../../../data/error/failures.dart';
import '../model/feedback_model.dart';

class SendFeedbacksBloc extends Bloc<AppEvent, AppState> {
  final FeedbacksRepo repo;

  SendFeedbacksBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController feedbackTEC = TextEditingController();

  final ratting = BehaviorSubject<int?>();
  Function(int?) get updateRatting => ratting.sink.add;
  Stream<int?> get rattingStream => ratting.stream.asBroadcastStream();

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      if (ratting.valueOrNull == null) {
        return AppCore.showToast(getTranslated("please_select_your_ratting"));
      }

      emit(Loading());
      Map<String, dynamic> body = {
        "rated_user_id": (event.arguments as Map)["id"] as int,
        "rate": (ratting.value! + 1),
        "feedback": feedbackTEC.text.trim()
      };

      Either<ServerFailure, Response> response = await repo.sendFeedback(body);

      response.fold((fail) {
        AppCore.showToast(fail.error);
        emit(Error());
      }, (success) {
        FeedbackModel feedbackModel =
            FeedbackModel.fromJson(success.data["data"]);
        ((event.arguments as Map)["onSuccess"] as Function(FeedbackModel))
            .call(feedbackModel);
        CustomNavigator.pop();
        AppCore.showSnackBar(
            notification: AppNotification(
          message: getTranslated("your_feedback_ratting_sent_successfully"),
          backgroundColor: Styles.ACTIVE,
          borderColor: Styles.ACTIVE,
        ));
        emit(Done());
      });
    } catch (e) {
      AppCore.showToast(e.toString());
      emit(Error());
    }
  }
}
