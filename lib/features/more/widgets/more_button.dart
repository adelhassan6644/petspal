import 'package:zurex/app/core/dimensions.dart';
import 'package:flutter/material.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../components/custom_images.dart';

class MoreButton extends StatelessWidget {
  const MoreButton(
      {required this.title,
      required this.icon,
      this.withBottomBorder = true,
      this.onTap,
      this.action,
      this.iconColor,
      super.key});

  final String title;
  final String icon;
  final void Function()? onTap;
  final Widget? action;
  final bool withBottomBorder;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: withBottomBorder
                        ? Styles.LIGHT_BORDER_COLOR
                        : Colors.transparent))),
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.PADDING_SIZE_SMALL.h,
            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            customImageIconSVG(
                imageName: icon,
                height: 22.w,
                width: 22.w,
                color: Styles.TITLE),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  title,
                  maxLines: 1,
                  style: AppTextStyles.w500.copyWith(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                      color: Styles.TITLE),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            action ??
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: Styles.DETAILS_COLOR,
                )
          ],
        ),
      ),
    );
  }
}
