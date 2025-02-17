import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../data/error/failures.dart';

abstract class CheckOutInterfaceRepo {
  Future<Either<ServerFailure, Response>> checkOut(data);
  Future<Either<ServerFailure, Response>> applyCoupon(id, coupon);
}
