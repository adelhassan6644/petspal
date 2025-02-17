import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../data/api/end_points.dart';
import '../../../data/error/api_error_handler.dart';
import '../../../data/error/failures.dart';
import '../../../main_repos/base_repo.dart';
import 'package:path/path.dart' as path;
class ChatRepo extends BaseRepo {
  ChatRepo({required super.dioClient, required super.sharedPreferences});

  Future<Either<ServerFailure, Response>> getChatDetails(id) async {
    try {
      Response response = await dioClient.get(uri: EndPoints.chatMessages(id));
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ServerFailure(ApiErrorHandler.getMessage(error)));
    }
  }

  Future<Either<ServerFailure, Response>> uploadFile(String filePath) async {
    try {
      print("filePathh $filePath");
      Response response = await dioClient.post(
        uri: EndPoints.uploadFile,
        data: FormData.fromMap({
          "file":await MultipartFile.fromFile(filePath,filename: path.basename(filePath), ),
        }),
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

enum MessageType {
  text,
  image,
  audio,
  video,
  invitation,
  file,
}
