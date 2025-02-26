import 'package:flutter/cupertino.dart';

import '../../../app/core/dimensions.dart';
import '../../../app/core/svg_images.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_text_form_field.dart';

class MarketplaceSearchFilter extends StatelessWidget {
  const MarketplaceSearchFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.PADDING_SIZE_DEFAULT.w,
        right: Dimensions.PADDING_SIZE_DEFAULT.w,
        bottom: Dimensions.paddingSizeExtraSmall.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              pSvgIcon: SvgImages.search,
              height: 40.h,
              hint: "${getTranslated("search")}...",
            ),
          ),
        ],
      ),
    );
  }
}
