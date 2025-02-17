import 'package:flutter/material.dart';
import 'package:zurex/app/core/dimensions.dart';

import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../components/custom_images.dart';

class MoreCard extends StatelessWidget {
  const MoreCard(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.icon,
      required this.value,
      this.onTap,
      this.color});
  final String title, subTitle, icon, value;
  final Color? color;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeExtraSmall.w,
          vertical: Dimensions.paddingSizeExtraSmall.h,
        ),
        decoration: BoxDecoration(
            color: Styles.WHITE_COLOR,
            borderRadius: BorderRadius.circular(12.w),
            border: Border.all(color: Styles.LIGHT_BORDER_COLOR)),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    style: AppTextStyles.w500.copyWith(
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        color: Styles.TITLE),
                  ),
                ),
                SizedBox(width: 8.w),
                customContainerSvgIcon(
                    backGround: color,
                    imageName: icon,
                    radius: 100,
                    height: 40.w,
                    width: 40.w,
                    padding: 8.w,
                    color: Styles.WHITE_COLOR),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    subTitle,
                    style: AppTextStyles.w400.copyWith(
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        color: Styles.DETAILS_COLOR),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  value,
                  style: AppTextStyles.w600.copyWith(
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis,
                      color: color),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
