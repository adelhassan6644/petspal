import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../app/core/app_storage_keys.dart';
import '../../../../data/api/end_points.dart';
import '../../../../main_repos/base_repo.dart';

class LogoutRepo extends BaseRepo {
  LogoutRepo({required super.sharedPreferences, required super.dioClient});

  Future unSubscribeToTopic() async {
    await FirebaseMessaging.instance
        .unsubscribeFromTopic(EndPoints.specificTopic(userId))
        .then((v) async {
      await sharedPreferences.remove(AppStorageKey.isSubscribe);
    });
  }

  Future<bool> logOut() async {
    try {
      await unSubscribeToTopic();
      await FirebaseAuth.instance.signOut();
      await _logeOutFromGoogle();
      await _logeOutFromFaceBook();

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
