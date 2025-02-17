import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/app/localization/language_constant.dart';
import 'package:zurex/navigation/custom_navigation.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_state.dart';
import '../../../../data/error/failures.dart';
import '../../../app/core/app_notification.dart';
import '../../../app/core/styles.dart';
import '../repo/contact_with_us_repo.dart';

class ContactWithUsBloc extends Bloc<AppEvent, AppState> {
  final ContactWithUsRepo repo;

  ContactWithUsBloc({required this.repo}) : super(Start()) {
    updateProblemType(ProblemType.help);
    updateContactType(ContactWays.whatsapp);
    on<Click>(onClick);
  }
  final formKey = GlobalKey<FormState>();

  TextEditingController descriptionTEC = TextEditingController();
  TextEditingController contactTEC = TextEditingController();

  final image = BehaviorSubject<File?>();
  Function(File?) get updateImage => image.sink.add;
  Stream<File?> get imageStream => image.stream.asBroadcastStream();

  final problemType = BehaviorSubject<ProblemType?>();
  Function(ProblemType?) get updateProblemType => problemType.sink.add;
  Stream<ProblemType?> get problemTypeStream =>
      problemType.stream.asBroadcastStream();

  final contactType = BehaviorSubject<ContactWays?>();
  Function(ContactWays?) get updateContactType => contactType.sink.add;
  Stream<ContactWays?> get contactTypeStream =>
      contactType.stream.asBroadcastStream();

  clear() {
    descriptionTEC.clear();
    contactTEC.clear();
    updateProblemType(ProblemType.help);
    updateContactType(ContactWays.whatsapp);
    updateImage(null);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Map<String, dynamic> data = {
        "problem_type": problemType.valueOrNull?.name,
        "desc": descriptionTEC.text.trim(),
        "contact_type": contactType.valueOrNull?.name,
        "contact_info": contactTEC.text.trim(),
      };

      if (image.valueOrNull != null) {
        data.addAll({"image": MultipartFile.fromFileSync(image.value!.path)});
      }
      Either<ServerFailure, Response> response = await repo.contactUs(data);

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        clear();
        CustomNavigator.pop();
        AppCore.showSnackBar(
            notification: AppNotification(
                message:
                    getTranslated("your_problem_has_been_sent_successfully"),
                isFloating: true,
                backgroundColor: Styles.ACTIVE,
                borderColor: Styles.ACTIVE));
        emit(Done());
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

enum ProblemType { help, bug, suggestions }

enum ContactWays { whatsapp, email, phone }
