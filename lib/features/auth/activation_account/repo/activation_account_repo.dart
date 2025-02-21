import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../data/api/end_points.dart';
import '../../../../data/error/api_error_handler.dart';
import '../../../../data/error/failures.dart';
import '../../../../main_repos/base_repo.dart';

class ActivationAccountRepo extends BaseRepo {
  ActivationAccountRepo(
      {required super.sharedPreferences, required super.dioClient});

  Future<Either<ServerFailure, Response>> activateAccount(
      Map<String, dynamic> data) async {
    try {
      Response response =
          await dioClient.post(uri: EndPoints.reactivateAccount, data: data);

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }
}
