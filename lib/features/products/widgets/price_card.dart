import 'package:zurex/app/localization/language_constant.dart';
import 'package:flutter/material.dart';

import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';

class PriceCard extends StatelessWidget {
  const PriceCard(
      {super.key,
      this.priceAfterDiscount,
      this.price,
      this.fontSize,
      this.discountFontSize});
  final double? priceAfterDiscount, price, fontSize, discountFontSize;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "${priceAfterDiscount ?? price ?? 0} ${getTranslated("sar")}",
        style: AppTextStyles.w600.copyWith(
            height: 1, fontSize: fontSize ?? 18, color: Styles.PRIMARY_COLOR),
        children: [
          if (priceAfterDiscount != price && priceAfterDiscount != null)
            TextSpan(
              text: "  ${getTranslated("disc")} ",
              style: AppTextStyles.w400.copyWith(
                height: 1,
                fontSize: discountFontSize ?? 14,
                color: Styles.DETAILS_COLOR,
              ),
            ),
          if (priceAfterDiscount != price && priceAfterDiscount != null)
            TextSpan(
              text: "$price ${getTranslated("sar")}",
              style: AppTextStyles.w400.copyWith(
                height: 1,
                fontSize: discountFontSize ?? 14,
                color: Styles.DETAILS_COLOR,
                decoration: TextDecoration.lineThrough,
              ),
            ),
        ],
      ),
    );
  }
}
