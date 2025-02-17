import 'package:flutter/material.dart';
import 'package:zurex/app/core/dimensions.dart';
import '../app/core/styles.dart';
import '../app/core/text_styles.dart';
import '../components/custom_images.dart';

class TabWidget extends StatelessWidget {
  const TabWidget({
    required this.label,
    this.fontSize = 16,
    this.withUpperBorder = false,
    required this.isSelected,
    required this.onTap,
    super.key,
    this.svgIcon,
  });
  final double fontSize;
  final String label;
  final bool isSelected, withUpperBorder;
  final Function() onTap;
  final String? svgIcon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
            vertical: Dimensions.PADDING_SIZE_SMALL.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Styles.PRIMARY_COLOR
              : Styles.PRIMARY_COLOR.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? Styles.PRIMARY_COLOR : Styles.LIGHT_BORDER_COLOR,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (svgIcon != null)
              customImageIconSVG(
                imageName: svgIcon!,
                color: isSelected ? Styles.WHITE_COLOR : Styles.HEADER,
              ),
            if (svgIcon != null) const SizedBox(width: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: AppTextStyles.w600.copyWith(
                overflow: TextOverflow.ellipsis,
                fontSize: fontSize,
                color: isSelected ? Styles.WHITE_COLOR : Styles.HEADER,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
