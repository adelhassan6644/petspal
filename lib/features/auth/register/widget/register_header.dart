import 'package:flutter/widgets.dart';

import '../../../../app/core/dimensions.dart';
import '../../../../app/core/images.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_images.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
              child: customImageIcon(
                  imageName: Images.authLogo, width: 230.w, height: 130.h)),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              getTranslated("signup_header"),
              style: AppTextStyles.w700
                  .copyWith(fontSize: 24, color: Styles.HEADER),
            ),
            SizedBox(width: 6.w),
            customImageIcon(
                imageName: Images.logoWord,
                height: 24.h,
                width: 115.w,
                fit: BoxFit.fitWidth)
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          getTranslated("signup_description"),
          style: AppTextStyles.w600.copyWith(fontSize: 20, color: Styles.TITLE),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_LARGE.h),
      ],
    );
  }
}
