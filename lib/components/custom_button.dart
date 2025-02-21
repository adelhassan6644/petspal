import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/app/core/extensions.dart';
import 'package:flutter/material.dart';
import '../app/core/styles.dart';
import '../app/core/text_styles.dart';
import 'lottie_file.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final String? text;
  final double? textSize;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final double? radius;
  final bool isLoading;
  final bool isActive;
  final bool withBorderColor;
  final bool withShadow;
  final Widget? lIconWidget, rIconWidget;

  const CustomButton({
    super.key,
    this.onTap,
    this.rIconWidget,
    this.lIconWidget,
    this.isActive = true,
    this.radius,
    this.height,
    this.isLoading = false,
    this.textColor,
    this.borderColor,
    this.width,
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
          ),
          child: Center(
            child: isLoading
                ? LottieFile.asset("loading", height: height)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (lIconWidget != null) ...[
                        lIconWidget!,
                        SizedBox(width: 8.w)
                      ],
                      if (text != null)
                        Flexible(
                          child: Text(
                            text ?? "",
                            style: AppTextStyles.w700.copyWith(
                              fontSize: textSize ?? 16,
                              height: 1,
                              overflow: TextOverflow.ellipsis,
                              color: textColor ?? Styles.WHITE_COLOR,
                            ),
                          ),
                        ),
                      if (rIconWidget != null) ...[
                        SizedBox(width: 8.w),
                        rIconWidget!,
                      ],
                    ],
                  ),
          ),
        ));
  }
}
