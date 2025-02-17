import 'package:petspal/main_repos/base_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../app/core/app_strings.dart';
import '../../../data/api/end_points.dart';
import '../../../data/error/api_error_handler.dart';
import '../../../data/error/failures.dart';

class MapsRepo extends BaseRepo {
  MapsRepo({required super.sharedPreferences, required super.dioClient});
  Future<Either<ServerFailure, Response>> searchLocation(String text) async {
    try {
      Response response = await dioClient.get(
          useGoogleUri: true,
          uri:
              '${EndPoints.autoComplete}json?input=$text&key=${AppStrings.googleApiKey}');

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ServerFailure(ApiErrorHandler.getMessage(error)));
    }
  }

  Future<Either<ServerFailure, Response>> getAddressFromGeocode(
      LatLng latLng) async {
    try {
      Response response = await dioClient.get(
          useGoogleUri: true,
          // uri:  '${EndPoints.GEOCODE_URI}?lat=${latLng.latitude}&lng=${latLng.longitude}');
          uri:
              '${EndPoints.geoCodeUrl}json?latlng=${latLng.latitude},${latLng.longitude}&key=${AppStrings.googleApiKey}');

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
