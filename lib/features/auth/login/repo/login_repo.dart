import 'dart:convert';
import 'package:zurex/main_models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../../../../app/core/app_storage_keys.dart';
import '../../../../data/api/end_points.dart';
import '../../../../data/error/api_error_handler.dart';
import '../../../../data/error/failures.dart';
import '../../../../main_repos/base_repo.dart';

class LoginRepo extends BaseRepo {
  LoginRepo({required super.sharedPreferences, required super.dioClient});

  saveUserData(json) {
    if (!kDebugMode) {
      subscribeToTopic(id: "${json["id"]}", userType: json["user_type"]);
    }
    sharedPreferences.setString(AppStorageKey.userId, json["id"].toString());
    sharedPreferences.setString(AppStorageKey.userData, jsonEncode(json));
    sharedPreferences.setBool(AppStorageKey.isLogin, true);
  }

  saveUserToken(token) {
    sharedPreferences.setString(AppStorageKey.token, token);
    dioClient.updateHeader(token);
  }

  Future subscribeToTopic(
      {required String id, required String userType}) async {
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

  getCredentials() {
    if (sharedPreferences.containsKey(AppStorageKey.credentials)) {
      return jsonDecode(sharedPreferences.getString(
            AppStorageKey.credentials,
          ) ??
          "{}");
    }
  }

  forgetCredentials() {
    sharedPreferences.remove(AppStorageKey.credentials);
  }

  Future<Either<ServerFailure, Response>> logIn(
      Map<String, dynamic> data) async {
    try {
      Response response =
          await dioClient.post(uri: EndPoints.logIn, data: data);

      if (response.statusCode != 404) {
        // if (response.data['data']["email_verified_at"] != null &&
        //     response.data['data']["token"] != null) {
        //   saveUserToken(response.data['data']["token"]);
        //   saveUserData(response.data["data"]);
        // }
        // if (response.data['data']["email_verified_at"] != null &&
        //     response.data['data']["is_complete"] == true) {
        //   saveUserData(response.data["data"]);
        //
        // }
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      if (error is DioException) {
        if (error.response?.statusCode != 404) {
          return Right(error.response!);
        } else {
          return left(ServerFailure(ApiErrorHandler.getMessage(error)));
        }
      } else {
        return left(ServerFailure(ApiErrorHandler.getMessage(error)));
      }
    }
  }

  guestMode() {
    UserModel user = UserModel();
    sharedPreferences.setString(
        AppStorageKey.userData, jsonEncode(user.toJson()));
  }
}
