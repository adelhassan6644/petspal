import 'package:petspal/main_models/search_engine.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../data/api/end_points.dart';
import '../../../../../data/error/api_error_handler.dart';
import '../../../../../data/error/failures.dart';
import '../../../../../main_repos/base_repo.dart';

class FeedbacksRepo extends BaseRepo {
  FeedbacksRepo({required super.dioClient, required super.sharedPreferences});

  Future<Either<ServerFailure, Response>> getFeedbacks(
      SearchEngine data) async {
    try {
      Response response = await dioClient.get(
        uri: EndPoints.feedbacks(data.id),
        queryParameters: {"page": data.currentPage! + 1, "limit": data.limit},
      );
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ServerFailure(ApiErrorHandler.getMessage(error)));
    }
  }

  Future<Either<ServerFailure, Response>> sendFeedback(
      Map<String, dynamic> body) async {
    try {
      Response response = await dioClient.post(
          uri: EndPoints.sendFeedback, data: FormData.fromMap(body));
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
