import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_bottom_sheet.dart';
import '../../../components/custom_images.dart';
import '../../../navigation/custom_navigation.dart';
import '../../language/bloc/language_bloc.dart';
import 'language_bottom_sheet.dart';

class LanguageButtonIcon extends StatefulWidget {
  const LanguageButtonIcon({super.key});

  @override
  State<LanguageButtonIcon> createState() => _LanguageButtonIconState();
}

class _LanguageButtonIconState extends State<LanguageButtonIcon> {
  @override
  void initState() {
    LanguageBloc.instance.add(Init());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, AppState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            LanguageBloc.instance.add(Init());
            CustomBottomSheet.show(
                height: 350,
                widget: const LanguageBottomSheet(),
                label: getTranslated("select_language"),
                onConfirm: () {
                  CustomNavigator.pop();
                  LanguageBloc.instance.add(Update());
                });
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: customImageIcon(
                  imageName: LanguageBloc
                          .instance
                          .languages[
                              LanguageBloc.instance.selectIndex.valueOrNull ??
                                  0]
                          .icon ??
                      "",
                  height: 18.h,
                  width: 24.w,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    LanguageBloc
                            .instance
                            .languages[
                                LanguageBloc.instance.selectIndex.valueOrNull ??
                                    0]
                            .name ??
                        "",
                    style: AppTextStyles.w400
                        .copyWith(fontSize: 12, color: Styles.WHITE_COLOR),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
