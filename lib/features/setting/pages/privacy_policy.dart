import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_app_bar.dart';
import '../../../components/custom_loading.dart';
import '../../../components/empty_widget.dart';
import '../bloc/setting_bloc.dart';
import '../model/setting_model.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated("privacy_policy"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<SettingBloc, AppState>(
                builder: (context, state) {
                  if (state is Loading) {
                    return const CustomLoading();
                  }
                  if (state is Done) {
                    return ListAnimator(
                      customPadding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                      ),
                      data: [
                        SizedBox(
                          height: 24.h,
                        ),
                        HtmlWidget((state.model as SettingModel)
                                .appRules
                                ?.privacyPolicy ??
                            "Privacy Policy"),
                        SizedBox(
                          height: 24.h,
                        ),
                      ],
                    );
                  }
                  if (state is Empty) {
                    return ListAnimator(
                      customPadding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                      ),
                      data: [
                        SizedBox(
                          height: 24.h,
                        ),
                        const EmptyState(),
                        SizedBox(height: 24.h),
                      ],
                    );
                  }
                  if (state is Error) {
                    return ListAnimator(
                      customPadding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                      ),
                      data: [
                        SizedBox(
                          height: 24.h,
                        ),
                        EmptyState(
                          txt: getTranslated("something_went_wrong"),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
