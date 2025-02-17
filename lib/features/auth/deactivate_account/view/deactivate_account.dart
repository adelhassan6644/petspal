import 'package:zurex/app/core/app_state.dart';
import 'package:zurex/app/core/images.dart';
import 'package:zurex/app/core/text_styles.dart';
import 'package:zurex/components/custom_images.dart';
import 'package:zurex/navigation/custom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/core/app_event.dart';
import '../../../../app/core/dimensions.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_button.dart';
import '../../../../data/config/di.dart';
import '../bloc/deactivate_account_bloc.dart';
import '../repo/deactivate_account_repo.dart';

class DeactivateAccount extends StatelessWidget {
  const DeactivateAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DeactivateAccountBloc(repo: sl<DeactivateAccountRepo>()),
      child: BlocBuilder<DeactivateAccountBloc, AppState>(
          builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: customImageIcon(
                    imageName: Images.logo, width: 220.w, height: 70.h)),

            Text(
              getTranslated("deactivate_account"),
              textAlign: TextAlign.center,
              style: AppTextStyles.w600
                  .copyWith(fontSize: 22, color: Styles.IN_ACTIVE),
            ),
            Text(
              getTranslated("are_you_sure_you_want_to_deactivate_your_account"),
              textAlign: TextAlign.center,
              style: AppTextStyles.w400
                  .copyWith(fontSize: 16, color: Styles.HEADER),
            ),

            ///Actions
            Padding(
              padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL.h),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: getTranslated("cancel"),
                      height: 45.h,
                      textColor: Styles.PRIMARY_COLOR,
                      backgroundColor: Styles.WHITE_COLOR,
                      withBorderColor: true,
                      borderColor: Styles.PRIMARY_COLOR,
                      onTap: () {
                        if (state is! Loading) {
                          CustomNavigator.pop();
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: CustomButton(
                      text: getTranslated("confirm"),
                      height: 45.h,
                      textColor: Styles.WHITE_COLOR,
                      backgroundColor: Styles.IN_ACTIVE,
                      isLoading: state is Loading,
                      onTap: () =>
                          context.read<DeactivateAccountBloc>().add(Delete()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
