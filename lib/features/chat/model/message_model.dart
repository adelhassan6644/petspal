import '../../../data/config/mapper.dart';
import '../../../main_models/meta.dart';

class MessagesModel extends SingleMapper {
  List<MessageItem>? messages;
  Meta? meta;

  MessagesModel({this.messages, this.meta});

  factory MessagesModel.fromJson(Map<String, dynamic> json) => MessagesModel(
      messages: json["data"] == null
          ? []
          : List<MessageItem>.from(
              json["data"]!.map((x) => MessageItem.fromJson(x))),
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]));

  Map<String, dynamic> toJson() => {
        "data": messages == null
            ? []
            : List<dynamic>.from(messages!.map((x) => x.toJson())),
      };

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return MessagesModel.fromJson(json);
  }
}

class MessageItem {
  int? id;
  String? message;
  bool? isMe;
  int? type;
  String? name;
  String? createdAt;

  MessageItem(
      {this.id, this.message, this.type, this.isMe, this.name, this.createdAt});

  factory MessageItem.fromJson(Map<String, dynamic> json) => MessageItem(
        id: json["id"],
        message: json['message'],
        type: json['type'],
        isMe: json['is_me'],
        name: json['name'],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_me": isMe,
        "type": type,
        "message": message,
        "created_at": createdAt,
      };
}
