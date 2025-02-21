import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:petspal/features/auth/social_media_login/model/social_media_model.dart';
import '../../../../app/core/app_storage_keys.dart';
import '../../../../data/api/end_points.dart';
import '../../../../data/error/api_error_handler.dart';
import '../../../../data/error/failures.dart';
import '../../../../helpers/social_media_login_helper.dart';
import '../../../../main_repos/base_repo.dart';

class SocialMediaRepo extends BaseRepo {
  SocialMediaRepo(
      {required this.socialMediaLoginHelper,
      required super.sharedPreferences,
      required super.dioClient});

  final SocialMediaLoginHelper socialMediaLoginHelper;

  saveUserData(json) {
    subscribeToTopic(id: "${json["id"]}", userType: json["user_type"]);
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

  Future<Either<ServerFailure, Response>> signInWithSocialMedia(
      Map<String, dynamic> data) async {
    try {
      SocialMediaProvider provider = data["provider"] as SocialMediaProvider;
      Either<ServerFailure, SocialMediaModel>? socialResponse;
      if (provider == SocialMediaProvider.google) {
        socialResponse = await socialMediaLoginHelper.googleLogin();
      }

      if (provider == SocialMediaProvider.facebook) {
        socialResponse = await socialMediaLoginHelper.facebookLogin();
      }

      if (provider == SocialMediaProvider.apple) {
        socialResponse = await socialMediaLoginHelper.appleLogin();
      }

      return socialResponse!.fold((fail) {
        return left(fail);
      }, (success) async {
        Response response = await dioClient.post(
            uri: EndPoints.socialMediaAuth,
            data: success.toJson(userType: data["user_type"]));

        if (response.statusCode == 200) {
          saveUserData(response.data["data"]);
          saveUserToken(response.data['data']["token"]);
          return Right(response);
        } else {
          return left(
              ApiErrorHandler.getServerFailure(response.data['message']));
        }
      });
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }
}
