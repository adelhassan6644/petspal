import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petspal/main_models/search_engine.dart';
import 'package:petspal/main_repos/base_repo.dart';
import '../../../data/api/end_points.dart';
import '../../../data/error/api_error_handler.dart';
import '../../../data/error/failures.dart';

class ChatsRepo extends BaseRepo {
  ChatsRepo({required super.dioClient, required super.sharedPreferences});

  Future<Either<ServerFailure, Response>> getChats(SearchEngine data) async {
    try {
      Response response = await dioClient.get(
        uri: EndPoints.chats,
        queryParameters: {"page": data.currentPage! +1 , "limit": data.limit},
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

  Future<Either<ServerFailure, Response>> deleteChat(id) async {
    try {
      Response response = await dioClient.delete(
        uri: EndPoints.deleteChat(id),
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
}
