import 'package:zurex/data/config/mapper.dart';
import 'package:zurex/features/chat/model/message_model.dart';

import '../../../main_models/meta.dart';

class ChatsModel extends SingleMapper {
  String? message;
  int? code;
  List<ChatModel>? data;
  Meta? meta;

  ChatsModel({this.message, this.code, this.data});

  ChatsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    code = json['code'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      data = <ChatModel>[];
      json['data'].forEach((v) {
        data!.add(ChatModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['code'] = code;
    data['meta'] = meta?.toJson();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ChatsModel.fromJson(json);
  }
}

class ChatModel {
  int? id;
  String? name;
  List<ChatUser>? users;
  MessageItem? lastMessage;
  int? countUnreadMessages;
  String? createdAt;

  ChatModel(
      {this.id,
      this.name,
      this.users,
      this.lastMessage,
      this.countUnreadMessages,
      this.createdAt});

  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['users'] != null) {
      users = <ChatUser>[];
      json['users'].forEach((v) {
        users!.add(ChatUser.fromJson(v));
      });
    }
    lastMessage = json['last_message'] != null
        ? MessageItem.fromJson(json['last_message'])
        : null;
    countUnreadMessages = json['count_unread_messages'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    if (lastMessage != null) {
      data['last_message'] = lastMessage!.toJson();
    }
    data['count_unread_messages'] = countUnreadMessages;
    data['created_at'] = createdAt;
    return data;
  }
}

class ChatUser {
  int? id;
  String? photoUrl;
  String? name;
  String? email;
  String? phone;
  String? userName;
  bool? isVerified;

  ChatUser({
    this.id,
    this.photoUrl,
    this.name,
    this.email,
    this.phone,
    this.userName,
    this.isVerified,
  });

  ChatUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photoUrl = json['photo_url'];
    email = json['email'];
    phone = json['phone'];
    userName = json['user_name'];
    photoUrl = json['photo_url'];
    isVerified = json['is_verified'] == 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['user_name'] = userName;
    data['photo_url'] = photoUrl;
    data['is_verified'] = isVerified;
    return data;
  }
}

