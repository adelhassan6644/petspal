import 'package:petspal/app/core/svg_images.dart';
import 'package:petspal/components/custom_images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app/core/dimensions.dart';
import '../app/core/styles.dart';
import '../app/core/text_styles.dart';

class LinkCard extends StatelessWidget {
  const LinkCard({super.key, required this.link, this.onRemove});
  final String link;
  final Function()? onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await launchUrl(Uri.parse(link));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeExtraSmall.w,
          vertical: Dimensions.paddingSizeMini.h,
        ),
        decoration: BoxDecoration(
            color: Styles.BLUE_COLOR.withOpacity(0.06),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                link,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: AppTextStyles.w400.copyWith(
                    fontSize: 14,
                    color: Styles.BLUE_COLOR,
                    decoration: TextDecoration.underline),
              ),
            ),
            SizedBox(width: Dimensions.paddingSizeExtraSmall.w),
            customImageIconSVG(
                onTap: onRemove,
                imageName: SvgImages.trash,
                color: Styles.IN_ACTIVE,
                width: 18.w,
                height: 18.w),
          ],
        ),
      ),
    );
  }
}
