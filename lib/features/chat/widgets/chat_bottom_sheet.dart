import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/app/core/svg_images.dart';
import 'package:zurex/app/localization/language_constant.dart';
import 'package:zurex/features/chat/entity/typing_entity.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/styles.dart';
import '../../../components/custom_images.dart';
import '../../../components/custom_text_form_field.dart';
import '../bloc/chat_bloc.dart';
import '../entity/message_entity.dart';
import '../repo/chat_repo.dart';
import 'buttons/attach_button.dart';
import 'buttons/image_button.dart';
import 'buttons/video_button.dart';
import 'buttons/recording_button.dart';

class ChatBottomSheet extends StatefulWidget {
  const ChatBottomSheet({
    super.key,
    required this.chatId,
  });
  final String chatId;

  @override
  State<ChatBottomSheet> createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<ChatBottomSheet> {
  bool isExpand = false;
  Timer? timer;

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MessageEntity>(
        stream: context.read<ChatBloc>().messageStream,
        initialData: MessageEntity(chatId: widget.chatId),
        builder: (context, messageSnapshot) {
          return SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
              ),
              decoration: const BoxDecoration(
                color: Styles.WHITE_COLOR,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StreamBuilder<TypingEntity?>(
                            stream: context.read<ChatBloc>().typingStream,
                            builder: (context, typingSnapshot) {
                              return CustomTextField(
                                hint: getTranslated("write_your_message"),
                                controller: _controller,
                                maxLines: 3,
                                onTapOutside: (v) {
                                  context.read<ChatBloc>().updateTyping(
                                        typingSnapshot.data!.copyWith(
                                          meTyping: false,
                                        ),
                                      );
                                  context.read<ChatBloc>().add(Typing());
                                },
                                onChanged: (v) {
                                  if (timer != null && timer!.isActive) {
                                    timer!.cancel();
                                  }
                                  timer = Timer(
                                      const Duration(milliseconds: 100), () {
                                    context.read<ChatBloc>().updateMessage(
                                          messageSnapshot.data!.copyWith(
                                              chatId: widget.chatId,
                                              message: _controller.text.trim(),
                                              messageType: MessageType.text),
                                        );

                                    context.read<ChatBloc>().updateTyping(
                                          typingSnapshot.data!.copyWith(
                                            meTyping: true,
                                          ),
                                        );
                                    context.read<ChatBloc>().add(Typing());
                                  });
                                },
                                sufWidget: customImageIconSVG(
                                  imageName: SvgImages.send,
                                  color: messageSnapshot.data?.message
                                                  ?.trim() !=
                                              null &&
                                          messageSnapshot.data!.message!
                                              .trim()
                                              .isNotEmpty
                                      ? Styles.PRIMARY_COLOR
                                      : Styles.PRIMARY_COLOR.withOpacity(0.4),
                                  onTap: () {
                                    if (_controller.text.isNotEmpty) {
                                      context.read<ChatBloc>().updateMessage(
                                            messageSnapshot.data!.copyWith(
                                                chatId: widget.chatId,
                                                message:
                                                    _controller.text.trim(),
                                                messageType: MessageType.text),
                                          );
                                      context.read<ChatBloc>().updateTyping(
                                            typingSnapshot.data!.copyWith(
                                              meTyping: false,
                                            ),
                                          );
                                      context.read<ChatBloc>().add(Typing());

                                      context
                                          .read<ChatBloc>()
                                          .add(SendMessage());

                                      _controller.clear();
                                    }
                                  },
                                ),
                              );
                            }),
                      ),
                      //
                      // ///Recording
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 8.w),
                      //   child: RecordingButton(
                      //     onRecord: (v) {
                      //       context.read<ChatBloc>().updateMessage(
                      //             messageSnapshot.data!.copyWith(
                      //                 chatId: widget.chatId,
                      //                 message: v,
                      //                 messageType: MessageType.audio),
                      //           );
                      //       context.read<ChatBloc>().add(SendMessage());
                      //     },
                      //   ),
                      // ),

                      customImageIconSVG(
                        imageName: SvgImages.addCircle,
                        color: Styles.PRIMARY_COLOR,
                        width: 24,
                        height: 24,
                        onTap: () {
                          setState(() {
                            isExpand = !isExpand;
                          });
                        },
                      ),
                    ],
                  ),
                  AnimatedCrossFade(
                    crossFadeState: isExpand
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 250),
                    firstChild: Padding(
                      padding: EdgeInsets.only(
                          top: Dimensions.PADDING_SIZE_DEFAULT.h),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Styles.PRIMARY_COLOR)),
                            child: customImageIconSVG(
                                imageName: SvgImages.invitePeople,
                                color: Styles.PRIMARY_COLOR,
                                height: 20,
                                width: 20),
                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL.w),
                          AttachButton(
                            onSelectFile: (v) {
                              context.read<ChatBloc>().updateMessage(
                                    messageSnapshot.data!.copyWith(
                                        chatId: widget.chatId,
                                        message: v,
                                        messageType: MessageType.file),
                                  );
                              context.read<ChatBloc>().add(SendMessage());
                            },
                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL.w),
                          VideoButton(
                            onSelectFile: (v) {
                              context.read<ChatBloc>().updateMessage(
                                    messageSnapshot.data!.copyWith(
                                        chatId: widget.chatId,
                                        message: v,
                                        messageType: MessageType.video),
                                  );
                              context.read<ChatBloc>().add(SendMessage());
                            },
                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL.w),
                          ImageButton(
                            onSelectFile: (v) {
                              context.read<ChatBloc>().updateMessage(
                                    messageSnapshot.data!.copyWith(
                                        chatId: widget.chatId,
                                        message: v,
                                        messageType: MessageType.image),
                                  );
                              context.read<ChatBloc>().add(SendMessage());
                            },
                          ),
                        ],
                      ),
                    ),
                    secondChild: const SizedBox(),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
