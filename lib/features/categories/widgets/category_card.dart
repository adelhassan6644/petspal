import 'package:flutter/material.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/app/core/svg_images.dart';
import 'package:petspal/app/core/text_styles.dart';
import 'package:petspal/app/localization/language_constant.dart';
import 'package:petspal/components/custom_images.dart';
import 'package:petspal/components/custom_network_image.dart';
import 'package:petspal/navigation/custom_navigation.dart';
import '../../../app/core/styles.dart';
import '../../../navigation/routes.dart';
import '../model/categories_model.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.model});
  final CategoryModel model;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => CustomNavigator.push(Routes.products, arguments: model),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeMini.h,
                horizontal: Dimensions.paddingSizeMini.w),
            decoration: BoxDecoration(
                color: Styles.WHITE_COLOR,
                border: Border.all(color: Styles.LIGHT_BORDER_COLOR),
                borderRadius: BorderRadius.circular(12.w)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomNetworkImage.containerNewWorkImage(
                  height: 70.h,
                  width: 70.w,
                  image: model.image ?? "",
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeMini.h),
                  child: Text(
                    model.name ?? "PetsPal",
                    style: AppTextStyles.w700.copyWith(
                      fontSize: 18,
                      color: Styles.HEADER,
                    ),
                  ),
                ),
                Row(
                  children: [
                    customImageIconSVG(
                        imageName: SvgImages.clock,
                        width: 16.w,
                        height: 16.h,
                        color: Styles.DETAILS_COLOR),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        getTranslated(model.is24Hr == true
                            ? "service_24_hr"
                            : "service_limit_hr"),
                        style: AppTextStyles.w400.copyWith(
                          fontSize: 14,
                          color: Styles.DETAILS_COLOR,
                        ),
                      ),
                    ),
                    SizedBox(width: 30.w),
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeMini.h,
                horizontal: Dimensions.paddingSizeMini.w),
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Styles.PRIMARY_COLOR),
            child: Icon(
              Icons.add,
              color: Styles.WHITE_COLOR,
              size: 24,
            ),
          )
        ],
      ),
    );
  }
}
