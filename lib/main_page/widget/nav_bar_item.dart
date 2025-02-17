import 'package:petspal/app/core/dimensions.dart';
import 'package:flutter/material.dart';
import '../../app/core/styles.dart';
import '../../components/custom_images.dart';

class BottomNavBarItem extends StatelessWidget {
  final String? imageIcon;
  final String? svgIcon;
  final VoidCallback onTap;
  final bool isSelected, withIconColor, withDot;
  final String? label;
  final double? width;
  final double? height;

  const BottomNavBarItem({
    super.key,
    this.imageIcon,
    this.svgIcon,
    this.label,
    this.isSelected = false,
    this.withDot = false,
    this.withIconColor = true,
    required this.onTap,
    this.width = 22,
    this.height = 22,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
        margin: EdgeInsets.only( top: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Styles.PRIMARY_COLOR.withOpacity(0.1)
              : Styles.WHITE_COLOR,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  svgIcon != null
                      ? customImageIconSVG(
                          imageName: svgIcon!,
                          color: isSelected
                              ? Styles.PRIMARY_COLOR
                              : withIconColor
                                  ? Styles.DISABLED
                                  : null,
                          width: width,
                          height: height)
                      : customImageIcon(
                          imageName: imageIcon!,
                          height: height,
                          color: isSelected
                              ? Styles.PRIMARY_COLOR
                              : Styles.DISABLED,
                          width: width,
                        ),
                  // if (label != null && !isSelected) SizedBox(height: 4.h),
                  if (label != null && !isSelected)
                    Material(
                      type: MaterialType.transparency,
                      child: Text(
                        label ?? "",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? Styles.PRIMARY_COLOR
                              : Styles.DISABLED,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 12,
                        ),
                      ),
                    )
                ],
              ),
            ),
            if (label != null && isSelected) SizedBox(width: 8.w),
            if (label != null && isSelected)
              Flexible(
                child: Material(
                  type: MaterialType.transparency,
                  child: FittedBox(
                      child: Text(
                    label ?? "",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color:
                          isSelected ? Styles.PRIMARY_COLOR : Styles.DISABLED,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14,
                    ),
                  )),
                ),
              )
          ],
        ),
      ),
    );
  }
}
