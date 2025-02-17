import 'package:petspal/app/core/extensions.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/svg_images.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_images.dart';
import '../../../components/custom_network_image.dart';
import '../model/feedback_model.dart';

class FeedbackCard extends StatelessWidget {
  const FeedbackCard({super.key, this.item});
  final FeedbackModel? item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
          vertical: Dimensions.PADDING_SIZE_SMALL.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.w),
        color: Styles.WHITE_COLOR,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomNetworkImage.circleNewWorkImage(
                  radius: 25, image: item?.avatar),
              SizedBox(
                width: 8.w,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item?.name ?? "",
                          style: AppTextStyles.w600.copyWith(
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis,
                              color: Styles.HEADER),
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Row(
                        children: [
                          Text(
                            "   ${item?.rate ?? 0}",
                            style: AppTextStyles.w600.copyWith(
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis,
                                color: Styles.HEADER),
                            maxLines: 1,
                          ),
                          ...List.generate(
                            5,
                            (index) => customImageIconSVG(
                              height: 14,
                              width: 14,
                              imageName: (item?.rate?.ceil() ?? 0) <= index
                                  ? SvgImages.emptyStar
                                  : SvgImages.fillStar,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    (item?.createdAt ?? DateTime.now())
                        .dateFormat(format: "d-M-yyyy"),
                    style: AppTextStyles.w500.copyWith(
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                        color: Styles.DETAILS_COLOR),
                    maxLines: 1,
                  ),
                ],
              ))
            ],
          ),
          SizedBox(height: 12.h),
          ReadMoreText(
            item?.feedback ?? "comment",
            style:
                AppTextStyles.w400.copyWith(fontSize: 12, color: Styles.HEADER),
            trimLines: 2,
            colorClickableText: Colors.pink,
            trimMode: TrimMode.Line,
            trimCollapsedText: getTranslated("show_more"),
            trimExpandedText: getTranslated("show_less"),
            textAlign: TextAlign.start,
            moreStyle: AppTextStyles.w600
                .copyWith(fontSize: 14, color: Styles.PRIMARY_COLOR),
            lessStyle: AppTextStyles.w600
                .copyWith(fontSize: 14, color: Styles.PRIMARY_COLOR),
          ),
        ],
      ),
    );
  }
}
