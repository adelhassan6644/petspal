import 'package:flutter/widgets.dart';

import '../../../../app/core/dimensions.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/localization/language_constant.dart';

class EditProfileHeader extends StatelessWidget {
  const EditProfileHeader({super.key, required this.fromComplete});
  final bool fromComplete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
          vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTranslated(
                fromComplete ? "complete_your_profile" : "edit_your_profile"),
            textAlign: TextAlign.start,
            style: AppTextStyles.w800
                .copyWith(fontSize: 32, color: Styles.PRIMARY_COLOR),
          ),
          // SizedBox(height: Dimensions.paddingSizeMini.h),
          // Center(
          //   child: Text(
          //     getTranslated("signup_description"),
          //     textAlign: TextAlign.center,
          //     style: AppTextStyles.w400
          //         .copyWith(fontSize: 14, color: Styles.DETAILS_COLOR),
          //   ),
          // ),
          // SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
        ],
      ),
    );
  }
}
