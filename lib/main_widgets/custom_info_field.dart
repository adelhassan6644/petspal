import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/components/custom_images.dart';
import 'package:flutter/material.dart';

import '../app/core/styles.dart';
import '../app/core/text_styles.dart';

class CustomInfoField extends StatelessWidget {
  const CustomInfoField(
      {super.key,
      required this.title,
      this.icon,
      this.subValue,
      required this.value});
  final String title, value;
  final String? icon, subValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeMini.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyles.w500.copyWith(
              fontSize: 14,
              color: Styles.HEADER,
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Styles.BORDER_COLOR)),
            child: Row(
              children: [
                ///Icon
                if (icon != null)
                  Row(
                    children: [
                      customImageIconSVG(
                          imageName: icon ?? "",
                          width: 18,
                          height: 18,
                          color: Styles.DETAILS_COLOR),
                      Container(
                        height: 20,
                        width: 1,
                        margin: EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeExtraSmall.w),
                        decoration: BoxDecoration(
                            color: Styles.DETAILS_COLOR,
                            borderRadius: BorderRadius.circular(100)),
                        child: const SizedBox(),
                      ),
                    ],
                  ),

                ///value
                Expanded(
                  child: Text(
                    value,
                    style: AppTextStyles.w400.copyWith(
                      fontSize: 14,
                      color: Styles.DETAILS_COLOR,
                    ),
                  ),
                ),

                ///Sub value
                if (subValue != null) SizedBox(width: 8.w),
                if (subValue != null)
                  Text(
                    subValue ?? "",
                    style: AppTextStyles.w400.copyWith(
                      fontSize: 14,
                      color: Styles.DETAILS_COLOR,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
