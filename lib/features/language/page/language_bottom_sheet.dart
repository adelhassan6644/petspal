import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/components/animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/app/core/app_state.dart';
import '../../../components/custom_radio_button.dart';
import '../bloc/language_bloc.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, AppState>(
      builder: (context, state) {
        return ListAnimator(
          customPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
          data: List.generate(
              LanguageBloc.instance.languages.length,
              (index) => StreamBuilder<int>(
                  stream: LanguageBloc.instance.selectIndexStream,
                  builder: (context, snapshot) {
                    return CustomRadioButton(
                      title: LanguageBloc.instance.languages[index].name ?? "",
                      icon: LanguageBloc.instance.languages[index].icon,
                      check: (snapshot.data ?? 0) == index,
                      onChange: (v) =>
                          LanguageBloc.instance.updateSelectIndex(index),
                    );
                  })),
        );
      },
    );
  }
}
