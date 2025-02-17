import 'package:flutter/material.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/app/core/text_styles.dart';
import 'package:zurex/features/chat/repo/chat_repo.dart';
import 'package:zurex/features/chat/widgets/message_cards/video_card.dart';
import '../../../app/core/styles.dart';
import 'message_cards/attachment_card.dart';
import '../model/message_model.dart';
import 'message_cards/audio_card.dart';
import 'message_cards/image_card.dart';
import 'message_cards/message_text_card.dart';

class MessageCard extends StatelessWidget {
  final MessageItem message;
  final String image;
  const MessageCard({
    super.key,
    required this.message,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection:
            message.isMe == true ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Expanded(
            child: Align(
              alignment: message.isMe == true
                  ? Alignment.bottomRight
                  : Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: message.isMe != true
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                crossAxisAlignment: message.isMe != true
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: message.isMe == true
                          ? Dimensions.PADDING_SIZE_EXTRA_LARGE.w
                          : 0,
                      right: message.isMe != true
                          ? Dimensions.PADDING_SIZE_EXTRA_LARGE.w
                          : 0,
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeExtraSmall.w,
                        vertical: 8.h),
                    decoration: BoxDecoration(
                      color: message.isMe == true
                          ? Styles.PRIMARY_COLOR
                          : const Color(0XFFEAEAEA),
                      borderRadius: BorderRadiusDirectional.only(
                        topEnd: Radius.circular(message.isMe == true ? 12 : 0),
                        topStart:
                            Radius.circular(message.isMe == true ? 0 : 12),
                        bottomEnd: const Radius.circular(12),
                        bottomStart: const Radius.circular(12),
                      ),
                    ),
                    child: messageOption(message),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 4.h,
                      bottom: Dimensions.PADDING_SIZE_SMALL.h,
                    ),
                    child: Text(
                      "${message.createdAt}",
                      textDirection: TextDirection.ltr,
                      style: AppTextStyles.w400.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Styles.DETAILS_COLOR,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  messageOption(MessageItem message) {
    switch (MessageType.values[message.type ?? 0]) {
      case MessageType.text:
        return MessageTextCard(message: message);
      case MessageType.image:
        return ImageCard(message: message);
      case MessageType.audio:
        return AudioCard(message: message);
      case MessageType.video:
        return VideoCard(videoUrl: message.message ?? "");
      case MessageType.file:
        return AttachmentCard(
          url: message.message ?? "",
          isMe: message.isMe == true,
        );
      case MessageType.invitation:
        return const SizedBox();
    }
  }
}
