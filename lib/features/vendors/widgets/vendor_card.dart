import 'package:flutter/material.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/app/core/svg_images.dart';
import 'package:petspal/app/core/text_styles.dart';
import 'package:petspal/components/custom_images.dart';
import 'package:petspal/components/custom_network_image.dart';
import '../../../app/core/styles.dart';
import '../model/vendors_model.dart';

class VendorCard extends StatelessWidget {
  const VendorCard({super.key, required this.model});
  final VendorModel model;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_SMALL.w,
          vertical: Dimensions.PADDING_SIZE_SMALL.w,
        ),
        decoration: BoxDecoration(
            color: Styles.WHITE_COLOR,
            borderRadius: BorderRadius.circular(20.w),
            border: Border.all(color: Styles.LIGHT_BORDER_COLOR)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomNetworkImage.containerNewWorkImage(
              image: model.image ?? "",
              width: 70.w,
              height: 70.w,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Text(
                model.name ?? "Name",
                style: AppTextStyles.w500
                    .copyWith(fontSize: 16, color: Styles.HEADER),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  model.description ?? "Description",
                  maxLines: 1,
                  style: AppTextStyles.w500
                      .copyWith(fontSize: 14, color: Styles.SUBTITLE),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: customImageIconSVG(
                      imageName: SvgImages.fillStar, width: 16.w, height: 16.w),
                ),
                Text(
                  "${model.avgRate ?? 0}",
                  maxLines: 1,
                  style: AppTextStyles.w600
                      .copyWith(fontSize: 14, color: Styles.SUBTITLE),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
