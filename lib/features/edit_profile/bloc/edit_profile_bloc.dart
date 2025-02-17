import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../data/error/failures.dart';
import '../../../main_blocs/user_bloc.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';
import '../repo/edit_profile_repo.dart';

class EditProfileBloc extends Bloc<AppEvent, AppState> {
  final EditProfileRepo repo;

  EditProfileBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
    on<Init>(onInit);
  }

  final formKey = GlobalKey<FormState>();

  Map<String, dynamic> body = {
    "name": "${UserBloc.instance.user?.name}",
    "email": "${UserBloc.instance.user?.email}",
    "phone_number": "${UserBloc.instance.user?.phone}",
  };

  TextEditingController nameTEC = TextEditingController();
  TextEditingController phoneTEC = TextEditingController();
  TextEditingController mailTEC = TextEditingController();

  final profileImage = BehaviorSubject<File?>();
  Function(File?) get updateProfileImage => profileImage.sink.add;
  Stream<File?> get profileImageStream =>
      profileImage.stream.asBroadcastStream();

  clear() {
    nameTEC.clear();
    phoneTEC.clear();
    mailTEC.clear();
    updateProfileImage(null);
  }

  @override
  Future<void> close() {
    clear();
    return super.close();
  }

  hasImage() {
    if (profileImage.value != null ||
        UserBloc.instance.user?.profileImage != null) {
      return true;
    } else {
      return false;
    }
  }

  bool _boolCheckString(dynamic value, String key) {
    if (value != null && value != "" && value != body[key]) {
      return true;
    } else {
      return false;
    }
  }

  bool checkData() {
    return _boolCheckString(nameTEC.text.trim(), "name") ||
        _boolCheckString(mailTEC.text.trim(), "email") ||
        _boolCheckString(phoneTEC.text.trim(), "phone_number");
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      if (checkData() || profileImage.valueOrNull != null) {
        if (profileImage.valueOrNull != null) {
          body.addAll({
            "profile_image":
                MultipartFile.fromFileSync(profileImage.value!.path)
          });
        }

        if (_boolCheckString(nameTEC.text.trim(), "name")) {
          body["name"] = nameTEC.text.trim();
        }

        if (_boolCheckString(mailTEC.text.trim(), "email")) {
          body["email"] = mailTEC.text.trim();
        }

        if (_boolCheckString(phoneTEC.text.trim(), "phone_number")) {
          body["phone_number"] = phoneTEC.text.trim();
        }

        Either<ServerFailure, Response> response = await repo.editProfile(body);

        response.fold((fail) {
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.transparent));
          emit(Error());
        }, (success) {
          if (event.arguments as bool == true) {
            AppCore.showSnackBar(
                notification: AppNotification(
              message: getTranslated("register_success_description"),
              backgroundColor: Styles.ACTIVE,
              borderColor: Styles.ACTIVE,
            ));
            CustomNavigator.push(Routes.dashboard, clean: true, arguments: 0);
          } else {
            AppCore.showSnackBar(
                notification: AppNotification(
              message: getTranslated("your_profile_successfully_updated"),
              backgroundColor: Styles.ACTIVE,
              borderColor: Styles.ACTIVE,
            ));
            CustomNavigator.pop();
          }

          ///To Update Profile Data
          UserBloc.instance.add(Click());
          emit(Done());
        });
      } else {
        AppCore.showToast(getTranslated("you_must_change_something"));
        emit(Start());
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

  ///To init Profile Data
  Future<void> onInit(Init event, Emitter<AppState> emit) async {
    nameTEC.text = UserBloc.instance.user?.name ?? "";
    phoneTEC.text = UserBloc.instance.user?.phone ?? "";
    mailTEC.text = UserBloc.instance.user?.email ?? "";
    emit(Start());
  }
}
