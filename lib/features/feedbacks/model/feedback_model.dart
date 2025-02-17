import '../../../data/config/mapper.dart';
import '../../../main_models/meta.dart';

class FeedbacksModel extends SingleMapper {
  String? message;
  int? statusCode;
  List<FeedbackModel>? data;
  Meta? meta;

  FeedbacksModel({
    this.message,
    this.statusCode,
    this.data,
    this.meta,
  });

  Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "meta": meta?.toJson(),
        "data": data != null
            ? List<dynamic>.from(data!.map((x) => x.toJson()))
            : [],
      };

  FeedbacksModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['status_code'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;

    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(FeedbackModel.fromJson(v));
      });
    }
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return FeedbacksModel.fromJson(json);
  }
}

class FeedbackModel {
  int? id;
  DateTime? createdAt;
  int? rate;
  String? feedback;
  String? name;
  String? avatar;

  FeedbackModel({
    this.id,
    this.createdAt,
    this.rate,
    this.feedback,
    this.name,
    this.avatar,
  });

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    if (json["user"] != null) {
      avatar = json["user"]["avatar"];
      name = json["user"]["full_name"];
    }

    rate = json["rate"];
    feedback = json["feedback"];
    createdAt =
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "rate": rate,
        "feedback": feedback,
        "user['avatar']": avatar,
        "user['full_name']": name,
      };
}
