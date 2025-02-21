import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petspal/main_repos/base_repo.dart';
import '../../../data/api/end_points.dart';
import '../../../data/error/api_error_handler.dart';
import '../../../data/error/failures.dart';
import 'check_out_interface_repo.dart';

class CheckOutProductRepo extends BaseRepo with CheckOutInterfaceRepo {
  CheckOutProductRepo(
      {required super.dioClient, required super.sharedPreferences});

  @override
  Future<Either<ServerFailure, Response>> checkOut(data) async {
    try {
      Response response = await dioClient.post(
        uri: EndPoints.checkOutProduct,
        data: FormData.fromMap(
          {
            "product_id": data["id"],
            "code": data["coupon"],
            "type": data["type"],
          },
        ),
      );
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ApiErrorHandler.getServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }

  @override
  Future<Either<ServerFailure, Response>> applyCoupon(id, coupon) async {
    try {
      Response response = await dioClient.post(
        uri: EndPoints.applyProductCoupon,
        data: FormData.fromMap(
          {
            "product_id": id,
            "code": coupon,
          },
        ),
      );
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

enum CheckOutProductType { ticket, product }
