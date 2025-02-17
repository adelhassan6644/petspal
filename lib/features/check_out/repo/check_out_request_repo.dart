import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zurex/main_repos/base_repo.dart';
import '../../../data/api/end_points.dart';
import '../../../data/error/api_error_handler.dart';
import '../../../data/error/failures.dart';
import 'check_out_interface_repo.dart';

class CheckOutRequestRepo extends BaseRepo with CheckOutInterfaceRepo {
  CheckOutRequestRepo(
      {required super.dioClient, required super.sharedPreferences});

  @override
  Future<Either<ServerFailure, Response>> checkOut(data) async {
    try {
      Response response = await dioClient.post(
        uri: data["bank_transfer"] == null
            ? EndPoints.checkOutOrder(data["id"])
            : EndPoints.checkOutByBankTransfer(data["id"]),
        data: FormData.fromMap(
          {
            "_method": "put",
            if (data["coupon"] != null) "code": data["coupon"],
            "bank_transfer": data["bank_transfer"]
          },
        ),
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

  @override
  Future<Either<ServerFailure, Response>> applyCoupon(id, coupon) async {
    try {
      Response response = await dioClient.post(
        uri: EndPoints.applyOrderCoupon(id),
        data: FormData.fromMap(
          {
            "code": coupon,
          },
        ),
      );
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message'],
            statusCode: response.statusCode));
      }
    } catch (error) {
      return left(ServerFailure(ApiErrorHandler.getMessage(error)));
    }
  }
}
