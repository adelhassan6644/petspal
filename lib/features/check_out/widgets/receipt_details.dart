import 'package:zurex/app/core/dimensions.dart';
import 'package:flutter/material.dart';

import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../model/price_details_model.dart';

class ReceiptDetails extends StatelessWidget {
  const ReceiptDetails({super.key, this.priceDetails});
  final PriceDetailsModel? priceDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
          vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
      decoration: const BoxDecoration(color: Styles.SMOKED_WHITE_COLOR),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTranslated("receipt_details"),
            style:
                AppTextStyles.w600.copyWith(fontSize: 18, color: Styles.HEADER),
          ),
          SizedBox(height: 8.h),

          ///Staff Cost
          if (priceDetails?.staffCost != null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      getTranslated("staff_cost"),
                      style: AppTextStyles.w600
                          .copyWith(fontSize: 14, color: Styles.HEADER),
                    ),
                  ),
                  Text(
                    "${(priceDetails?.staffCost ?? 0).toStringAsFixed(2)} ${priceDetails?.currency ?? "\$"}",
                    style: AppTextStyles.w400
                        .copyWith(fontSize: 14, color: Styles.DETAILS_COLOR),
                  ),
                ],
              ),
            ),

          ///Sub Total
          if (priceDetails?.subTotal != null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      getTranslated("sub_total"),
                      style: AppTextStyles.w600
                          .copyWith(fontSize: 14, color: Styles.HEADER),
                    ),
                  ),
                  Text(
                    "${(priceDetails?.subTotal ?? 0).toStringAsFixed(2)} ${priceDetails?.currency ?? getTranslated("sar")}",
                    style: AppTextStyles.w400
                        .copyWith(fontSize: 14, color: Styles.DETAILS_COLOR),
                  ),
                ],
              ),
            ),

          ///Service
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "${getTranslated("service")}(${priceDetails?.servicePercentage ?? 0}%)",
                    style: AppTextStyles.w600
                        .copyWith(fontSize: 14, color: Styles.HEADER),
                  ),
                ),
                Text(
                  "${(priceDetails?.service ?? 0).toStringAsFixed(2)} ${priceDetails?.currency ?? getTranslated("sar")}",
                  style: AppTextStyles.w400
                      .copyWith(fontSize: 14, color: Styles.DETAILS_COLOR),
                ),
              ],
            ),
          ),

          ///Discount
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    getTranslated("discount"),
                    // "${getTranslated("discount")}(${priceDetails?.couponPercentage ?? 0}%)",
                    style: AppTextStyles.w600
                        .copyWith(fontSize: 14, color: Styles.HEADER),
                  ),
                ),
                Text(
                  "- ${(priceDetails?.couponPrice ?? 0).toStringAsFixed(2)} ${priceDetails?.currency ?? getTranslated("sar")}",
                  style: AppTextStyles.w400
                      .copyWith(fontSize: 14, color: Styles.IN_ACTIVE),
                ),
              ],
            ),
          ),

          ///Tax
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "${getTranslated("tax")}(${priceDetails?.taxPercentage ?? 0}%)",
                    style: AppTextStyles.w600
                        .copyWith(fontSize: 14, color: Styles.HEADER),
                  ),
                ),
                Text(
                  "${(priceDetails?.tax ?? 0).toStringAsFixed(2)} ${priceDetails?.currency ?? getTranslated("sar")}",
                  style: AppTextStyles.w400
                      .copyWith(fontSize: 14, color: Styles.DETAILS_COLOR),
                ),
              ],
            ),
          ),

          ///fees
          if(priceDetails?.fees != 0 || priceDetails?.fees != null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 3.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${getTranslated("fees")}(${priceDetails?.feesPercentage ?? 0}%)",
                          style: AppTextStyles.w600
                              .copyWith(fontSize: 14, color: Styles.HEADER),
                        ),
                        Text(
                          "(${getTranslated("fees_desc")})",
                          style: AppTextStyles.w400.copyWith(
                              fontSize: 10, color: Styles.DETAILS_COLOR),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${(priceDetails?.fees ?? 0).toStringAsFixed(2)} ${priceDetails?.currency ?? getTranslated("sar")}",
                    style: AppTextStyles.w400
                        .copyWith(fontSize: 14, color: Styles.DETAILS_COLOR),
                  ),
                ],
              ),
            ),

          ///Total
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    getTranslated("total"),
                    style: AppTextStyles.w600
                        .copyWith(fontSize: 14, color: Styles.TITLE),
                  ),
                ),
                Text(
                  "${(priceDetails?.totalPrice ?? 0).toStringAsFixed(2)} ${priceDetails?.currency ?? getTranslated("sar")}",
                  style: AppTextStyles.w400
                      .copyWith(fontSize: 14, color: Styles.ACTIVE),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
