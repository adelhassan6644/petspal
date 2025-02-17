import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/app/core/extensions.dart';
import 'package:zurex/app/core/styles.dart';
import 'package:zurex/app/localization/language_constant.dart';
import 'package:zurex/components/animated_widget.dart';
import 'package:zurex/components/empty_widget.dart';
import 'package:zurex/features/chat/repo/chat_repo.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../data/config/di.dart';
import '../../../main_models/search_engine.dart';
import '../../chats/bloc/chats_bloc.dart';
import '../widgets/chat_app_bar.dart';
import '../bloc/chat_bloc.dart';
import '../model/message_model.dart';
import '../widgets/chat_bottom_sheet.dart';
import '../widgets/message_card.dart';
import '../widgets/typing_widget.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.data});
  final Map data;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void dispose() {
    sl<ChatsBloc>().add(Click(arguments: SearchEngine(isUpdate: true)));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.BACKGROUND_COLOR,
      appBar: ChatAppBar(
        id: widget.data["user_id"] ?? "",
        image: widget.data["image"] ?? "",
        name: widget.data["name"] ?? "",
      ),
      body: BlocProvider(
        create: (context) => ChatBloc(repo: sl<ChatRepo>())
          ..connectToChat(widget.data["chat_id"])
          ..add(Click(arguments: widget.data["chat_id"])),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, AppState>(
                builder: (context, state) {
                  if (state is Loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is Done) {
                    MessagesModel res = state.model as MessagesModel;
                    return SingleChildScrollView(
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                      child: Column(children: [
                        ...List.generate(
                          res.messages?.length ?? 0,
                          (index) => MessageCard(
                            message: res.messages![index],
                            image: widget.data["image"] ?? "",
                          ),
                        ),
                        const TypingWidget(),
                      ]),
                    );
                  }
                  if (state is Error || state is Empty) {
                    return ListAnimator(
                      customPadding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                        vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                      ),
                      data: [
                        SizedBox(
                          height: 50.h,
                        ),
                        EmptyState(
                          txt: state is Empty
                              ? "${getTranslated("start_to_chat_with")} ${widget.data["name"].toString().capitalize()}"
                              : state is Error
                                  ? getTranslated("something_went_wrong")
                                  : null,
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
            BlocBuilder<ChatBloc, AppState>(
              builder: (context, state) {
                return Visibility(
                  visible: state is! Loading,
                  child: ChatBottomSheet(
                    chatId: widget.data["chat_id"].toString(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
