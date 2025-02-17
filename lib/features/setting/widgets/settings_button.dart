import 'package:zurex/app/core/dimensions.dart';
import 'package:flutter/material.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../components/custom_images.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton(
      {required this.title, required this.icon, this.onTap, super.key});
  final String title, icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeExtraSmall.h,
            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            customImageIconSVG(
                imageName: icon, height: 22, width: 22, color: Styles.TITLE),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(title,
                    maxLines: 1,
                    style: AppTextStyles.w500.copyWith(
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                        color: Styles.TITLE)),
              ),
            ),
            SizedBox(
              width: 16.w,
            ),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              color: Styles.HEADER,
              size: 18,
            )
          ],
        ),
      ),
    );
  }
}
