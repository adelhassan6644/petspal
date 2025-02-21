import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petspal/main_repos/base_repo.dart';
import '../../../data/api/end_points.dart';
import '../../../data/error/api_error_handler.dart';
import '../../../data/error/failures.dart';

class HomeRepo extends BaseRepo {
  HomeRepo({required super.dioClient, required super.sharedPreferences});

  Future<Either<ServerFailure, Response>> getHomeBanners() async {
    try {
      Response response = await dioClient.get(uri: EndPoints.banners);
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
