import 'package:zurex/app/core/app_state.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/app/core/svg_images.dart';
import 'package:zurex/app/core/text_styles.dart';
import 'package:zurex/app/localization/language_constant.dart';
import 'package:zurex/components/custom_images.dart';
import 'package:zurex/main_blocs/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/core/styles.dart';
import '../../../data/config/di.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, AppState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
            vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeExtraSmall.w,
            vertical: Dimensions.paddingSizeExtraSmall.h,
          ),
          decoration: BoxDecoration(
              color: Styles.WHITE_COLOR,
              borderRadius: BorderRadius.circular(12.w),
              border: Border.all(color: Styles.LIGHT_BORDER_COLOR)),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      getTranslated("cash_back"),
                      maxLines: 1,
                      style: AppTextStyles.w500.copyWith(
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                          color: Styles.TITLE),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  customContainerSvgIcon(
                      backGround: Styles.GREEN,
                      imageName: SvgImages.money,
                      radius: 100,
                      height: 40.w,
                      width: 40.w,
                      padding: 8.w,
                      color: Styles.WHITE_COLOR),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      getTranslated("balance"),
                      style: AppTextStyles.w400.copyWith(
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                          color: Styles.DETAILS_COLOR),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "${sl<UserBloc>().user?.balance ?? 0} ${getTranslated("sar", context: context)}",
                    style: AppTextStyles.w600.copyWith(
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis,
                      color: Styles.GREEN,
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
