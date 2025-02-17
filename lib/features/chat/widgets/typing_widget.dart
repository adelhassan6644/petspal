import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zurex/app/core/dimensions.dart';

import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../bloc/chat_bloc.dart';
import '../entity/typing_entity.dart';

class TypingWidget extends StatelessWidget {
  const TypingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TypingEntity?>(
        stream: context.read<ChatBloc>().typingStream,
        builder: (context, typingSnapshot) {
          return Visibility(
            visible: typingSnapshot.hasData &&
                typingSnapshot.data!.userTyping == true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  getTranslated("typing"),
                  style: AppTextStyles.w400
                      .copyWith(color: Styles.HINT_COLOR, fontSize: 12),
                ),
                SizedBox(
                  width: 8.w,
                ),
                const SpinKitThreeBounce(
                  color: Styles.HINT_COLOR,
                  size: 16,
                ),
              ],
            ),
          );
        });
  }
}
