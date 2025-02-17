import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:petspal/main_repos/base_repo.dart';
import '../app/core/app_storage_keys.dart';
import '../data/error/api_error_handler.dart';
import '../data/error/failures.dart';
import '../main_models/user_model.dart';

class UserRepo extends BaseRepo {
  UserRepo({required super.sharedPreferences, required super.dioClient});

  bool get isLogIn => sharedPreferences.containsKey(AppStorageKey.isLogin);

  Either<ServerFailure, UserModel> getUser() {
    try {
      final String? userObject =
          sharedPreferences.getString(AppStorageKey.userData);
      if (userObject != null) {
        final json = jsonDecode(userObject);
        return Right(UserModel.fromJson(json));
      } else {
        return Left(ServerFailure("There is no data in SharedPreference"));
      }
    } catch (error) {
      return Left(ServerFailure(ApiErrorHandler.getMessage(error)));
    }
  }

  setUserData(json) {
    sharedPreferences.setString(AppStorageKey.userData, jsonEncode(json));
  }

  clearUserData() {
    sharedPreferences.remove(AppStorageKey.userData);
  }
}
