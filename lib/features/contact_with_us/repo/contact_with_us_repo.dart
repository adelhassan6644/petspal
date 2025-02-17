import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petspal/main_repos/base_repo.dart';
import '../../../data/api/end_points.dart';
import '../../../data/error/api_error_handler.dart';
import '../../../data/error/failures.dart';

class ContactWithUsRepo extends BaseRepo {
  ContactWithUsRepo(
      {required super.dioClient, required super.sharedPreferences});

  Future<Either<ServerFailure, Response>> contactUs(data) async {
    try {
      Response response = await dioClient.post(
          uri: EndPoints.contactUs, data: FormData.fromMap(data));
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ServerFailure(ApiErrorHandler.getMessage(error)));
    }
  }
}
