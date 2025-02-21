import 'package:flutter/material.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/app/core/extensions.dart';
import 'package:petspal/components/custom_images.dart';
import '../../navigation/custom_navigation.dart';
import '../app/core/images.dart';
import '../app/core/styles.dart';
import '../app/core/svg_images.dart';
import '../app/core/text_styles.dart';
import '../features/language/bloc/language_bloc.dart';
import 'back_icon.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? actionChild;
  final bool withBack;
  final bool withHPadding;
  final bool withVPadding;
  final double? height;
  final bool withSafeArea;
  final Color? backColor;
  final double? actionWidth;

  const CustomAppBar(
      {super.key,
      this.title,
      this.height,
      this.backColor,
      this.withHPadding = true,
      this.withVPadding = true,
      this.withBack = true,
      this.withSafeArea = true,
      this.actionWidth,
      this.actionChild});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: withHPadding ? Dimensions.PADDING_SIZE_DEFAULT.w : 0,
        vertical: withVPadding ? Dimensions.PADDING_SIZE_DEFAULT.h : 0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SafeArea(
        top: withSafeArea,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            withBack && CustomNavigator.navigatorState.currentState!.canPop()
                ? FilteredBackIcon()
                : SizedBox(
                    width: actionWidth ?? 30,
                  ),
            const Expanded(child: SizedBox()),
            Text(
              title ?? "",
              style: AppTextStyles.w600
                  .copyWith(color: Styles.WHITE_COLOR, fontSize: 18),
            ),
            const Expanded(child: SizedBox()),
            SizedBox(
              height: actionWidth ?? 30,
              width: actionWidth ?? 30,
              child: actionChild ?? const SizedBox(),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(
      CustomNavigator.navigatorState.currentContext!.width, height ?? 120.h);
}
