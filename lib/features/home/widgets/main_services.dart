import 'package:flutter/material.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/app/core/svg_images.dart';
import 'package:petspal/app/core/text_styles.dart';
import 'package:petspal/app/localization/language_constant.dart';
import 'package:petspal/components/custom_images.dart';
import 'package:petspal/components/grid_list_animator.dart';

import '../../../app/core/styles.dart';
import '../../../main_page/bloc/dashboard_bloc.dart';

class MainServices extends StatelessWidget {
  const MainServices({super.key});

  @override
  Widget build(BuildContext context) {
    return GridListAnimatorWidget(
        padding:
            EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
        aspectRatio: 0.9,
        columnCount: 3,
        items: [
          _ServiceCard(
            label: getTranslated("marketplace"),
            icon: SvgImages.marketplaceService,
            onTap: () => DashboardBloc.instance.updateSelectIndex(1),
          ),
          _ServiceCard(
            label: getTranslated("petsgram"),
            icon: SvgImages.petsgramService,
            onTap: () => DashboardBloc.instance.updateSelectIndex(2),
          ),
          _ServiceCard(
            label: getTranslated("scanning"),
            icon: SvgImages.scanService,
          ),
          _ServiceCard(
            label: getTranslated("travels"),
            icon: SvgImages.travelService,
          ),
          _ServiceCard(
            label: getTranslated("guidance"),
            icon: SvgImages.guidanceService,
          ),
          _ServiceCard(
            label: getTranslated("orders"),
            icon: SvgImages.orderService,
          ),
        ]);
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard(
      {super.key, required this.label, required this.icon, this.onTap});
  final String label, icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Styles.LIGHT_BORDER_COLOR),
            color: Styles.WHITE_COLOR,
            borderRadius: BorderRadius.circular(20.w)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customImageIconSVG(
              imageName: icon,
              width: 50.w,
              height: 50.h,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: AppTextStyles.w600
                  .copyWith(fontSize: 14, color: Styles.HEADER),
            ),
          ],
        ),
      ),
    );
  }
}
