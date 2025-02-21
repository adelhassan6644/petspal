import 'dart:developer';

import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/core/app_event.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/svg_images.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_images.dart';
import '../../../../data/config/di.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';
import '../../../language/bloc/language_bloc.dart';
import '../../verification/model/verification_model.dart';
import '../bloc/register_bloc.dart';

class RegisterActions extends StatelessWidget {
  const RegisterActions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, AppState>(
      builder: (context, state) {
        return Column(
          children: [
            StreamBuilder<bool?>(
                stream: context.read<RegisterBloc>().agreeToTermsStream,
                builder: (context, snapshot) {
                  return _AgreeToTerms(
                    check: snapshot.data ?? true,
                    onChange: context.read<RegisterBloc>().updateAgreeToTerms,
                  );
                }),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: CustomButton(
                  text: getTranslated("signup"),
                  rIconWidget: RotatedBox(
                    quarterTurns: sl<LanguageBloc>().isLtr ? 0 : 2,
                    child: customImageIconSVG(
                      imageName: SvgImages.forwardArrow,
                      color: Styles.WHITE_COLOR,
                    ),
                  ),
                  onTap: () {
                    context.read<RegisterBloc>().formKey.currentState!.validate();
                    if (context.read<RegisterBloc>().isBodyValid()) {
                      context.read<RegisterBloc>().clear();
                      CustomNavigator.push(Routes.verification,
                          arguments: VerificationModel(email: "", fromRegister: true));
                      // context.read<RegisterBloc>().add(Click());
                    }

                  },
                  isLoading: state is Loading),
            ),

            ///Login up if u have account

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: getTranslated("have_acc"),
                  style: AppTextStyles.w400
                      .copyWith(fontSize: 14, color: Styles.DETAILS_COLOR),
                  children: [
                    TextSpan(
                        text: " ${getTranslated("sign_in")}",
                        style: AppTextStyles.w600.copyWith(
                          fontSize: 16,
                          color: Styles.PRIMARY_COLOR,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => CustomNavigator.pop()),
                  ]),
            ),
            SizedBox(height: 12.h),
          ],
        );
      },
    );
  }
}

class _AgreeToTerms extends StatelessWidget {
  const _AgreeToTerms({
    this.check = true,
    required this.onChange,
  });
  final bool check;
  final Function(bool) onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 12.h, 8.w, 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: () => onChange(!check),
            child: Icon(
              check ? Icons.check_box : Icons.check_box_outline_blank,
              color: check ? Styles.PRIMARY_COLOR : Styles.DISABLED,
              size: 22,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                  text: "${getTranslated("by_signing_in_you_agree")}\n",
                  style: AppTextStyles.w500
                      .copyWith(fontSize: 14, color: Styles.TITLE),
                  children: [
                    TextSpan(
                        text: getTranslated("terms_conditions"),
                        style: AppTextStyles.w600.copyWith(
                            fontSize: 14,
                            color: Styles.PRIMARY_COLOR,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            CustomNavigator.push(Routes.terms);
                          }),
                    TextSpan(
                      text: " & ",
                      style: AppTextStyles.w500
                          .copyWith(fontSize: 14, color: Styles.TITLE),
                    ),
                    TextSpan(
                        text: getTranslated("privacy_policy"),
                        style: AppTextStyles.w600.copyWith(
                            fontSize: 14,
                            color: Styles.PRIMARY_COLOR,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            CustomNavigator.push(Routes.privacy);
                          }),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
