import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../data/api/end_points.dart';
import '../../../../data/error/api_error_handler.dart';
import '../../../../data/error/failures.dart';
import '../../../../main_repos/base_repo.dart';

class ChangePasswordRepo extends BaseRepo {
  ChangePasswordRepo(
      {required super.sharedPreferences, required super.dioClient});

  Future<Either<ServerFailure, Response>> changePassword(data) async {
    try {
      Response response = await dioClient.post(
          uri: EndPoints.changePassword, data: FormData.fromMap(data));

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ApiErrorHandler.getServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }
}
