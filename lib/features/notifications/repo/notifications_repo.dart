import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../app/core/app_storage_keys.dart';
import '../../../data/api/end_points.dart';
import '../../../data/error/api_error_handler.dart';
import '../../../data/error/failures.dart';
import '../../../main_models/search_engine.dart';
import '../../../main_repos/base_repo.dart';

class NotificationsRepo extends BaseRepo {
  NotificationsRepo(
      {required super.dioClient, required super.sharedPreferences});

  bool get isTurnOn => sharedPreferences.containsKey(AppStorageKey.isSubscribe);

  Future switchNotification() async {
    if (isTurnOn) {
      await FirebaseMessaging.instance
          .unsubscribeFromTopic(userId)
          .then((v) async {
        await sharedPreferences.remove(AppStorageKey.isSubscribe);
      });
    } else {
      await FirebaseMessaging.instance.subscribeToTopic(userId).then((v) async {
        await sharedPreferences.setBool(AppStorageKey.isSubscribe, true);
      });
    }
  }

  Future<Either<ServerFailure, Response>> getNotifications(
      SearchEngine data) async {
    try {
      Response response = await dioClient.get(
        uri: EndPoints.notifications,
        queryParameters: {
          "page": data.currentPage! + 1,
          "limit": data.limit,
        },
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

  Future<Either<ServerFailure, Response>> readNotification(id) async {
    try {
      Response response =
          await dioClient.get(uri: EndPoints.readNotification(id));
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ApiErrorHandler.getServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }

  Future<Either<ServerFailure, Response>> deleteNotification(id) async {
    try {
      Response response =
          await dioClient.delete(uri: EndPoints.deleteNotification(id));
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
