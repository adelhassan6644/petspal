import '../repo/chat_repo.dart';

class MessageEntity {
  String? message;
  MessageType? messageType;
  String? chatId;

  MessageEntity({
    this.chatId,
    this.message,
    this.messageType,
  });

  toJson() => {
        "chat_id": chatId,
        "message": message,
        "type": messageType?.index,
      };

  MessageEntity copyWith({
    String? chatId,
    String? message,
    MessageType? messageType,
  }) {
    return MessageEntity(
      chatId: chatId ?? this.chatId,
      messageType: messageType ?? this.messageType,
      message: message ?? this.message,
    );
  }
}
