class TypingEntity {
  bool? userTyping;
  bool? meTyping;
  String? chatId;

  TypingEntity({
    this.chatId,
    this.meTyping,
    this.userTyping,
  });

  toJson() => {
        "chat_id": chatId,
        "user_typing": userTyping == true ? 1 : 0,
        "me_typing": meTyping == true ? 1 : 0,
      };

  factory TypingEntity.fromJson(Map<String, dynamic> json) => TypingEntity(
        chatId: json["chat_id"],
        userTyping: json["user_typing"] == 1,
        meTyping: json["me_typing"] == 1,
      );

  TypingEntity copyWith({
    String? chatId,
    bool? userTyping,
    bool? meTyping,
  }) {
    return TypingEntity(
      chatId: chatId ?? this.chatId,
      userTyping: userTyping ?? this.userTyping,
      meTyping: meTyping ?? this.meTyping,
    );
  }
}
