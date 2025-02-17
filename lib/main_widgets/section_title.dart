import 'package:flutter/material.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/app/core/svg_images.dart';
import 'package:zurex/app/localization/language_constant.dart';
import 'package:zurex/components/custom_images.dart';
import '../app/core/styles.dart';
import '../app/core/text_styles.dart';
import '../components/shimmer/custom_shimmer.dart';
import '../data/config/di.dart';
import '../features/language/bloc/language_bloc.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.withView = false,
    this.mentionText,
    this.onViewTap,
  });
  final String title;
  final String? mentionText;
  final bool withView;
  final Function()? onViewTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Dimensions.PADDING_SIZE_DEFAULT.w,
        bottom: Dimensions.paddingSizeExtraSmall.w,
        left: Dimensions.PADDING_SIZE_DEFAULT.w,
        right: Dimensions.PADDING_SIZE_DEFAULT.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: Text(
            title,
            style: AppTextStyles.w900
                .copyWith(fontSize: 18, ),
          )),
          if (withView)
            InkWell(
              onTap: onViewTap,
              child: Row(
                children: [
                  Text(
                    "${getTranslated("view_all", context: context)}  ",
                    style: AppTextStyles.w500
                        .copyWith(fontSize: 14, color: Styles.PRIMARY_COLOR),
                  ),
                  RotatedBox(
                    quarterTurns: sl<LanguageBloc>().isLtr ? 0 : 2,
                    child: customImageIconSVG(
                        imageName: SvgImages.arrowRight,
                        width: 14,
                        height: 14,
                        color: Styles.PRIMARY_COLOR),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}

class SectionTitleShimmer extends StatelessWidget {
  const SectionTitleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Dimensions.PADDING_SIZE_DEFAULT.w,
        bottom: Dimensions.paddingSizeExtraSmall.w,
        left: Dimensions.PADDING_SIZE_DEFAULT.w,
        right: Dimensions.PADDING_SIZE_DEFAULT.w,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomShimmerText(
            width: 100,
          ),
          CustomShimmerText(
            width: 70,
          ),
        ],
      ),
    );
  }
}
