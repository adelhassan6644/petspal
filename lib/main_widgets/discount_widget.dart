import 'package:flutter/material.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/app/core/text_styles.dart';

import '../app/core/styles.dart';

class DiscountWidget extends StatelessWidget {
  const DiscountWidget({super.key, this.discount});
  final double? discount;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
      decoration: const BoxDecoration(
        color: Styles.PRIMARY_COLOR,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          bottomLeft: Radius.circular(4),
        ),
      ),
      child: Text(
        "- ${discount ?? "10"} %",
        textAlign: TextAlign.center,
        style: AppTextStyles.w500
            .copyWith(fontSize: 14, color: Styles.WHITE_COLOR),
      ),
    );
  }
}
