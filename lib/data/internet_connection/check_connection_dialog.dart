import 'package:zurex/app/core/extensions.dart';
import 'package:zurex/app/core/images.dart';
import 'package:zurex/components/empty_widget.dart';
import 'package:flutter/material.dart';
import '../../app/core/dimensions.dart';
import '../../app/core/styles.dart';
import '../../app/localization/language_constant.dart';

class CheckConnectionDialog extends StatelessWidget {
  const CheckConnectionDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height,
      width: context.width,
      color: Styles.WHITE_COLOR,
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
          vertical: Dimensions.PADDING_SIZE_DEFAULT.w),
      child: EmptyState(
        txt: getTranslated("no_connection"),
        subText: getTranslated("check_internet"),
        img: Images.noInternet,
        imgHeight: 150,
        imgWidth: 150,
      ),
    );
  }
}
