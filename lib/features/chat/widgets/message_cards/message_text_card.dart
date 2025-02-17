import 'package:flutter/material.dart';

import '../../../../app/core/styles.dart';
import '../../../../app/core/text_styles.dart';
import '../../model/message_model.dart';

class MessageTextCard extends StatelessWidget {
  const MessageTextCard({required this.message, super.key});
  final MessageItem message;
  @override
  Widget build(BuildContext context) {
    return Text(
      message.message ?? "",
      maxLines: 20,
      style: AppTextStyles.w400.copyWith(
        fontSize: 14,
        color: message.isMe == true ? Styles.WHITE_COLOR : Styles.BLACK,
      ),
    );
  }
}
