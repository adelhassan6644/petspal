import 'package:petspal/app/core/dimensions.dart';
import 'package:flutter/material.dart';
import '../../app/core/styles.dart';
import '../../components/custom_images.dart';

class BottomNavBarItem extends StatelessWidget {
  final String? imageIcon;
  final String? svgIcon;
  final VoidCallback onTap;
  final bool isSelected;
  final String? label;
  final double? width;
  final double? height;

  const BottomNavBarItem({
    super.key,
    this.imageIcon,
    this.svgIcon,
    this.label,
    this.isSelected = false,
    required this.onTap,
    this.width = 22,
    this.height = 22,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(top: 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            svgIcon != null
                ? customImageIconSVG(
                    imageName: svgIcon!,
                    color: isSelected ? Styles.PRIMARY_COLOR : Styles.DISABLED,
                    width: width,
                    height: height)
                : customImageIcon(
                    imageName: imageIcon!,
                    height: height,
                    color: isSelected ? Styles.PRIMARY_COLOR : Styles.DISABLED,
                    width: width,
                  ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                  label ?? "",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Styles.PRIMARY_COLOR : Styles.DISABLED,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                  color: isSelected ? Styles.PRIMARY_COLOR : Colors.transparent,
                  shape: BoxShape.circle),
            )
          ],
        ),
      ),
    );
  }
}
