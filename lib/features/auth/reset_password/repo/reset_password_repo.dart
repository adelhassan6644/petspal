import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petspal/app/core/app_storage_keys.dart';
import '../../../../data/api/end_points.dart';
import '../../../../data/error/api_error_handler.dart';
import '../../../../data/error/failures.dart';
import '../../../../main_repos/base_repo.dart';

class ResetPasswordRepo extends BaseRepo {
  ResetPasswordRepo(
      {required super.sharedPreferences, required super.dioClient});

  Future<Either<ServerFailure, Response>> resetPassword(data) async {
    try {
      Response response =
          await dioClient.post(uri: EndPoints.resetPassword, data: data);

      if (response.statusCode == 200) {
        sharedPreferences.remove(AppStorageKey.credentials);
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ServerFailure(ApiErrorHandler.getMessage(error)));
    }
  }
}
