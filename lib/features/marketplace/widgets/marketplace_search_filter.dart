import 'package:flutter/cupertino.dart';

import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/svg_images.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_images.dart';
import '../../../components/custom_text_form_field.dart';

class MarketplaceSearchFilter extends StatefulWidget {
  const MarketplaceSearchFilter({super.key});

  @override
  State<MarketplaceSearchFilter> createState() =>
      _MarketplaceSearchFilterState();
}

class _MarketplaceSearchFilterState extends State<MarketplaceSearchFilter> {
  late FocusNode searchNode;
  @override
  void initState() {
    searchNode = FocusNode();
    super.initState();
  }

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
              focusNode: searchNode,
            ),
          ),
          SizedBox(width: 12.w),
          customContainerSvgIcon(
              onTap: () {},
              backGround: Styles.WHITE_COLOR,
              color: Styles.HINT_COLOR,
              borderColor: Styles.LIGHT_BORDER_COLOR,
              width: 40.w,
              height: 40.w,
              radius: 16.w,
              padding: 10.w,
              imageName: SvgImages.filter),
        ],
      ),
    );
  }
}
