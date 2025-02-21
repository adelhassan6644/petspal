import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petspal/features/auth/verification/model/verification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../app/core/app_storage_keys.dart';
import '../../../../data/api/end_points.dart';
import '../../../../data/error/api_error_handler.dart';
import '../../../../data/error/failures.dart';
import '../../../../main_repos/base_repo.dart';

class VerificationRepo extends BaseRepo {
  VerificationRepo(
      {required super.sharedPreferences, required super.dioClient});

  saveUserData(json) {
    subscribeToTopic(json["id"]);
    sharedPreferences.setString(AppStorageKey.userId, json["id"].toString());
    sharedPreferences.setString(AppStorageKey.userData, jsonEncode(json));
    sharedPreferences.setBool(AppStorageKey.isLogin, true);
  }

  saveUserToken(token) {
    sharedPreferences.setString(AppStorageKey.token, token);
    dioClient.updateHeader(token);
  }

  Future subscribeToTopic(id) async {
    FirebaseMessaging.instance
        .subscribeToTopic(EndPoints.specificTopic(id))
        .then((v) async {
      await sharedPreferences.setBool(AppStorageKey.isSubscribe, true);
    });
  }

  saveCredentials(credentials) {
    sharedPreferences.setString(
        AppStorageKey.credentials, jsonEncode(credentials));
  }

  Future<Either<ServerFailure, Response>> resendCode(
      VerificationModel model) async {
    try {
      Response response = await dioClient.post(
        uri: EndPoints.resend,
        data: model.toJson(withCode: false),
      );

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ApiErrorHandler.getServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }

  Future<Either<ServerFailure, Response>> verifyAccount(
      VerificationModel model) async {
    try {
      Response response =
          await dioClient.post(uri: EndPoints.verifyOtp, data: model.toJson());

      if (response.statusCode == 200) {
        if (model.fromRegister && response.data['data'] != null) {
          saveUserToken(response.data["data"]["token"]);
          saveUserData(response.data["data"]["user"]);
        }
        return Right(response);
      } else {
        return left(ApiErrorHandler.getServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }
}
