import 'package:flutter/widgets.dart';
import 'package:zurex/components/custom_images.dart';
import '../../../../app/core/dimensions.dart';
import '../../../../app/core/images.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/localization/language_constant.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

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
                  imageName: Images.logo, width: 220.w, height: 70.h)),
        ),
        Text(
          getTranslated("login_header"),
          style: AppTextStyles.w800
              .copyWith(fontSize: 32, color: Styles.PRIMARY_COLOR),
        ),
        SizedBox(height: Dimensions.paddingSizeMini.h),
        Text(
          getTranslated("login_description"),
          style: AppTextStyles.w400
              .copyWith(fontSize: 16, color: Styles.DETAILS_COLOR),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
      ],
    );
  }
}
