import 'dart:developer';

import 'package:dio/dio.dart';

import '../../app/core/app_event.dart';
import '../../app/core/app_state.dart';
import '../../app/localization/language_constant.dart';
import '../../features/auth/logout/bloc/logout_bloc.dart';
import '../config/di.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription = "";
    if (error is Exception) {
      try {
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;
            case DioExceptionType.connectionTimeout:
              errorDescription = "Connection timeout with API server";
              break;
            case DioExceptionType.unknown:
              errorDescription =
                  "Connection to API server failed due to internet connection";
              break;
            case DioExceptionType.receiveTimeout:
              errorDescription =
                  "Receive timeout in connection with API server";
              break;
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {
                case 404:
                  errorDescription = error.response!.data["message"];
                  break;
                case 401:
                  if (sl<LogoutBloc>().isLogin &&
                      sl<LogoutBloc>().state is! Loading) {
                    sl<LogoutBloc>().add(Click());
                  }
                  errorDescription =
                      getTranslated("your_session_has_been_expired");
                  break;
                case 500:
                  errorDescription = error.response!.data["message"];
                  break;
                case 503:
                  errorDescription = error.response!.statusMessage;
                  break;
                default:
                  log(error.response!.data.toString());

                  try {
                    errorDescription = error.response!.data["message"];
                  } catch (e) {
                    errorDescription = error.response!.data['data']["message"];
                  }
              }
              break;
            case DioExceptionType.sendTimeout:
              errorDescription = "Send timeout with server";
              break;
            case DioExceptionType.badCertificate:
              errorDescription = "Bad Certificate with server";
              break;
            case DioExceptionType.connectionError:
              errorDescription = "Connection Error with server";
              break;
          }
        } else {
          errorDescription = "Unexpected error occurred";
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = error.toString();
    }
    return errorDescription;
  }
}
