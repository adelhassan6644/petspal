import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/app/core/extensions.dart';
import 'package:flutter/material.dart';
import '../app/core/styles.dart';
import '../app/core/text_styles.dart';
import 'custom_images.dart';
import 'lottie_file.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final Widget? icon;
  final String? text;
  final double? textSize;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final String? svgIcon;
  final String? assetIcon;
  final Color? iconColor;
  final double? width;
  final double? height;
  final double? radius;
  final double? iconSize;
  final bool isLoading;
  final bool isActive;
  final bool withBorderColor;
  final bool withShadow;
  final Widget? lIconWidget;

  const CustomButton({
    super.key,
    this.icon,
    this.onTap,
    this.lIconWidget,
    this.isActive = true,
    this.radius,
    this.height,
    this.svgIcon,
    this.assetIcon,
    this.isLoading = false,
    this.textColor,
    this.borderColor,
    this.width,
    this.iconColor,
    this.iconSize,
    this.textSize,
    this.withBorderColor = false,
    this.withShadow = false,
    this.text,
    this.backgroundColor = Styles.PRIMARY_COLOR,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          if (onTap != null && !isLoading && isActive) {
            onTap?.call();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutBack,
          width: !isLoading ? width ?? context.width : 100,
          height: height ?? 50.h,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
          ),
          decoration: BoxDecoration(
            color: (onTap == null || !isActive)
                ? Styles.LIGHT_BORDER_COLOR
                : backgroundColor,
            boxShadow: withShadow
                ? [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: const Offset(1, 1))
                  ]
                : null,
            border: Border.all(
                color: withBorderColor
                    ? borderColor ?? Styles.PRIMARY_COLOR
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(radius ?? 15),
            // gradient: backgroundColor != null
            //     ? null
            //     : const LinearGradient(
            //         colors: Styles.kBackgroundGradient,
            //       ),
          ),
          child: Center(
            child: isLoading
                ? LottieFile.asset("loading", height: height)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) icon!,
                      if (assetIcon != null)
                        customImageIcon(
                            imageName: assetIcon!,
                            color: iconColor,
                            width: iconSize ?? 20.w,
                            height: iconSize ?? 20.w),
                      if (svgIcon != null)
                        customImageIconSVG(
                            imageName: svgIcon!,
                            color: iconColor,
                            width: iconSize ?? 20.w,
                            height: iconSize ?? 20.w),
                      if (assetIcon != null || svgIcon != null || icon != null)
                        SizedBox(
                          width: 12.w,
                        ),
                      Visibility(
                          visible: lIconWidget != null,
                          child: lIconWidget ?? const SizedBox()),
                      if (text != null)
                        Flexible(
                          child: Text(
                            text ?? "",
                            style: AppTextStyles.w500.copyWith(
                              fontSize: textSize ?? 16,
                              height: 1,
                              overflow: TextOverflow.ellipsis,
                              color: textColor ?? Styles.WHITE_COLOR,
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ));
  }
}
