import 'package:flutter/material.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/app/core/text_styles.dart';

import '../app/core/images.dart';
import '../app/core/styles.dart';
import '../data/config/di.dart';
import '../features/language/bloc/language_bloc.dart';

class DiscountWidget extends StatelessWidget {
  const DiscountWidget({super.key, this.discount});
  final double? discount;
  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: sl<LanguageBloc>().isLtr ? 0 : 3,
      child: Container(
        width: 55.w,
        height: 65.w,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.w),
          ),
          image: DecorationImage(
            image: AssetImage(Images.discount),
            fit: BoxFit.contain,
          ),
        ),
        child: Transform.rotate(
          angle: 45,
          child: Text(
            "- ${discount ?? "10"} %",
            textAlign: TextAlign.center,
            style: AppTextStyles.w500
                .copyWith(fontSize: 14, color: Styles.WHITE_COLOR),
          ),
        ),
      ),
    );
  }
}
