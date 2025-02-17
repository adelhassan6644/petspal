import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/svg_images.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_bottom_sheet.dart';
import '../../../components/custom_images.dart';
import '../../../navigation/custom_navigation.dart';
import '../../language/bloc/language_bloc.dart';
import 'language_bottom_sheet.dart';

class LanguageButton extends StatefulWidget {
  final bool fromWelcome;
  const LanguageButton({super.key, this.fromWelcome = false});

  @override
  State<LanguageButton> createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
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
          child: Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Styles.LIGHT_BORDER_COLOR))),
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.PADDING_SIZE_SMALL.h,
                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                customImageIconSVG(
                  imageName: SvgImages.language,
                  height: 22.w,
                  width: 22.w,
                  color: Styles.TITLE,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(getTranslated("language", context: context),
                        maxLines: 1,
                        style: AppTextStyles.w500.copyWith(
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            color: Styles.TITLE)),
                  ),
                ),
                Padding(
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
                        .copyWith(fontSize: 12, color: Styles.PRIMARY_COLOR),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: Styles.DETAILS_COLOR,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
