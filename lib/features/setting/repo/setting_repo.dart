import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petspal/main_repos/base_repo.dart';
import '../../../app/core/app_storage_keys.dart';
import '../../../data/api/end_points.dart';
import '../../../data/error/api_error_handler.dart';
import '../../../data/error/failures.dart';

class SettingRepo extends BaseRepo {
  SettingRepo({required super.dioClient, required super.sharedPreferences});

  Future<Either<ServerFailure, Response>> getSetting() async {
    try {
      Response response = await dioClient.get(uri: EndPoints.settings);
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ApiErrorHandler.getServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }

  String get getConfigVideo =>
      sharedPreferences.getString(AppStorageKey.configVideo) ?? "";

  cacheSplashVideo(v) {
    sharedPreferences.setString(AppStorageKey.configVideo, v);
  }
}
