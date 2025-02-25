import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../data/api/end_points.dart';
import '../../../../../data/error/api_error_handler.dart';
import '../../../../../data/error/failures.dart';
import '../../../../../main_repos/base_repo.dart';

class CartRepo extends BaseRepo {
  CartRepo({required super.dioClient, required super.sharedPreferences});

  Future<Either<ServerFailure, Response>> getCartItems() async {
    try {
      Response response = await dioClient.get(
        uri: EndPoints.cart,
      );
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }

  Future<Either<ServerFailure, Response>> addToCart(data) async {
    try {
      Response response =
          await dioClient.post(uri: EndPoints.addToCart, data: data);
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }

  Future<Either<ServerFailure, Response>> updateCart(
      Map<String, dynamic> data) async {
    try {
      Response response = await dioClient.post(
          uri: EndPoints.updateCart, data: FormData.fromMap(data));
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }

  Future<Either<ServerFailure, Response>> removeFromCart(id) async {
    try {
      Response response = await dioClient
          .post(uri: EndPoints.removeFromCart, data: {"cartId": id});
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }

  Future<Either<ServerFailure, Response>> applyCoupon(coupon) async {
    try {
      Response response = await dioClient.get(
        uri: EndPoints.applyProductCoupon,
        queryParameters: {
          "code": coupon,
        },
      );
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message'],
            statusCode: response.statusCode));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }
}
