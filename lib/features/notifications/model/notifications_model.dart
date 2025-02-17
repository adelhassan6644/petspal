import '../../../data/config/mapper.dart';
import '../../../main_models/meta.dart';

class NotificationsModel extends SingleMapper {
  String? status;
  String? message;
  List<NotificationModel>? data;
  Meta? meta;

  NotificationsModel({
    this.status,
    this.message,
    this.data,
  });

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;

    data = json["data"] == null
        ? []
        : List<NotificationModel>.from(
            json["data"]!.map((x) => NotificationModel.fromJson(x)));
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "meta": meta?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return NotificationsModel.fromJson(json);
  }
}

class NotificationModel extends SingleMapper {
  String? id;
  String? createdTime;
  String? createdAt;
  bool? isRead;
  String? image;
  String? key;
  String? title;
  String? body;
  int? keyId;

  NotificationModel({
    this.id,
    this.createdTime,
    this.createdAt,
    this.isRead,
    this.image,
    this.key,
    this.title,
    this.body,
    this.keyId,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['created_time'];
    createdAt = json['created_at'];
    isRead = json['is_readed'];
    image = json['image'];
    key = json['key'];
    title = json['title'];
    body = json['body'];
    keyId = json['key_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['key_id'] = keyId;
    data['created_time'] = createdTime;
    data['created_at'] = createdAt;
    data['is_readed'] = isRead;
    data['image'] = image;
    data['key'] = key;
    data['title'] = title;
    data['body'] = body;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return NotificationModel.fromJson(json);
  }
}
