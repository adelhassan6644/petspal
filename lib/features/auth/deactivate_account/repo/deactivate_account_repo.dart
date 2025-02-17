import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zurex/main_repos/base_repo.dart';

import '../../../../app/core/app_storage_keys.dart';
import '../../../../data/api/end_points.dart';
import '../../../../data/error/api_error_handler.dart';
import '../../../../data/error/failures.dart';

class DeactivateAccountRepo extends BaseRepo {
  DeactivateAccountRepo(
      {required super.dioClient, required super.sharedPreferences});

  Future<Either<ServerFailure, Response>> deactivateAccount() async {
    try {
      Response response = await dioClient.post(
        uri: EndPoints.suspendAccount,
      );
      if (response.statusCode == 200) {
        await clearCache();
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ServerFailure(ApiErrorHandler.getMessage(error)));
    }
  }

  Future<bool> clearCache() async {
    try {
      if (!kDebugMode) {
        await unSubscribeToTopic();
        await FirebaseAuth.instance.signOut();
        await _logeOutFromGoogle();
        await _logeOutFromFaceBook();
      }
      if (sharedPreferences.containsKey(AppStorageKey.isSubscribe)) {
        return false;
      } else {
        dioClient.updateHeader(null);
        await sharedPreferences.remove(AppStorageKey.userId);
        await sharedPreferences.remove(AppStorageKey.userData);
        await sharedPreferences.remove(AppStorageKey.token);
        await sharedPreferences.remove(AppStorageKey.isLogin);
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future unSubscribeToTopic() async {
    await FirebaseMessaging.instance
        .unsubscribeFromTopic(EndPoints.specificTopic(userId))
        .then((v) async {
      await sharedPreferences.remove(AppStorageKey.isSubscribe);
    });
  }

  Future _logeOutFromFaceBook() async {
    if (await FacebookAuth.instance.accessToken != null) {
      await FacebookAuth.instance.logOut();
    }
  }

  Future _logeOutFromGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
    );
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.disconnect();
    }
  }
}
