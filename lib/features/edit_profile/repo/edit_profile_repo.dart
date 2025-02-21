import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../data/api/end_points.dart';
import '../../../../data/error/api_error_handler.dart';
import '../../../../data/error/failures.dart';
import '../../../../main_repos/base_repo.dart';
import '../../../app/core/app_storage_keys.dart';

class EditProfileRepo extends BaseRepo {
  EditProfileRepo({required super.sharedPreferences, required super.dioClient});

  Future<Either<ServerFailure, Response>> editProfile(data) async {
    try {
      Response response = await dioClient.post(
          uri: EndPoints.editProfile, data: FormData.fromMap(data));

      if (response.statusCode == 200) {
        setUserData(response.data["data"]);

        return Right(response);
      }else {
        return left(ApiErrorHandler.getServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }

  setUserData(json) {
    sharedPreferences.setString(AppStorageKey.userData, jsonEncode(json));
  }
}
