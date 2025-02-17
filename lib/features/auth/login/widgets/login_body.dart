import 'package:country_codes/country_codes.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/app/core/app_state.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/components/animated_widget.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_text_form_field.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';
import '../bloc/login_bloc.dart';
import 'login_header.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<LoginBloc, AppState>(
        builder: (context, state) {
          return ListAnimator(
            customPadding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
            data: [
              LoginHeader(),
              Form(
                  key: context.read<LoginBloc>().formKey,
                  child: AutofillGroup(
                    child: Column(
                      children: [
                        ///Phone
                        CustomTextField(
                          controller: context.read<LoginBloc>().phoneTEC,
                          autofillHints: const [
                            AutofillHints.telephoneNumber,
                            AutofillHints.username,
                          ],
                          label: getTranslated("phone"),
                          hint: getTranslated("enter_your_phone"),
                          inputType: TextInputType.phone,
                          validate: Validations.phone,
                          // pSvgIcon: SvgImages.phoneCallIcon,
                          prefixWidget: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 4.h),
                            decoration: BoxDecoration(
                                color: Styles.FILL_COLOR,
                                borderRadius: BorderRadius.circular(4)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CountryFlag.fromCountryCode(
                                  "SA",
                                  height: 18,
                                  width: 24,
                                  shape: const RoundedRectangle(5),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  CountryCodes.detailsForLocale(
                                        Locale.fromSubtags(countryCode: "SA"),
                                      ).dialCode ??
                                      "+966",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: AppTextStyles.w400.copyWith(
                                      fontSize: 14,
                                      height: 1,
                                      color: Styles.HEADER),
                                ),
                              ],
                            ),
                          ),
                        ),

                        ///Sign in
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                          ),
                          child: CustomButton(
                              text: getTranslated("login"),
                              onTap: () {
                                if (context
                                    .read<LoginBloc>()
                                    .formKey
                                    .currentState!
                                    .validate()) {
                                  TextInput.finishAutofillContext();
                                  context.read<LoginBloc>().add(Click());
                                }
                              },
                              isLoading: state is Loading),
                        ),

                        ///Sign up if don't have account
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: getTranslated("do_not_have_acc"),
                              style: AppTextStyles.w400.copyWith(
                                  fontSize: 14, color: Styles.DETAILS_COLOR),
                              children: [
                                TextSpan(
                                    text: " ${getTranslated("signup")}",
                                    style: AppTextStyles.w600.copyWith(
                                        fontSize: 16,
                                        color: Styles.PRIMARY_COLOR,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => CustomNavigator.push(
                                          Routes.register)),
                              ]),
                        ),

                        ///Guest Mode
                        GestureDetector(
                          onTap: () => context.read<LoginBloc>().add(Add()),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeMini.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                                vertical: Dimensions.paddingSizeMini.h),
                            decoration: BoxDecoration(
                                color: Styles.SMOKED_WHITE_COLOR,
                                borderRadius: BorderRadius.circular(8.w)),
                            child: Text(
                              getTranslated("login_as_a_guest"),
                              style: AppTextStyles.w500
                                  .copyWith(fontSize: 14, color: Styles.TITLE),
                            ),
                          ),
                        ),


                        /* Padding(
                          padding: EdgeInsets.only(
                            left: Dimensions.PADDING_SIZE_DEFAULT.w,
                            right: Dimensions.PADDING_SIZE_DEFAULT.w,
                            top: Dimensions.PADDING_SIZE_DEFAULT.h,
                            bottom: Dimensions.PADDING_SIZE_SMALL.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Divider(
                                    color: Styles.DETAILS_COLOR,
                                    height: 12.h,
                                  )),
                                  Text(
                                    "  ${getTranslated("or")}  ",
                                    style: AppTextStyles.w500.copyWith(
                                        fontSize: 14,
                                        color: Styles.DETAILS_COLOR),
                                  ),
                                  Expanded(
                                      child: Divider(
                                    color: Styles.DETAILS_COLOR,
                                    height: 12.h,
                                  )),
                                ],
                              ),
                              SizedBox(height: 8.h),
                            ],
                          ),
                        ),

                         if (Platform.isIOS)
                          BlocProvider(
                            create: (context) =>
                                SocialMediaBloc(repo: sl<SocialMediaRepo>()),
                            child: BlocBuilder<SocialMediaBloc, AppState>(
                              builder: (context, state) {
                                return CustomButton(
                                  text:
                                      "${getTranslated("continue_with")} Apple",
                                  svgIcon: SvgImages.apple,
                                  backgroundColor: Styles.FILL_COLOR,
                                  textColor: Styles.TITLE,
                                  withBorderColor: true,
                                  borderColor: Styles.LIGHT_BORDER_COLOR,
                                  onTap: () {
                                    context.read<SocialMediaBloc>().add(Click(
                                          arguments: {
                                            "provider":
                                                SocialMediaProvider.apple
                                          },
                                        ));
                                  },
                                  isLoading: state is Loading,
                                );
                              },
                            ),
                          ),

                        ///Login With Google
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimensions.PADDING_SIZE_SMALL.h),
                          child: BlocProvider(
                            create: (context) =>
                                SocialMediaBloc(repo: sl<SocialMediaRepo>()),
                            child: BlocBuilder<SocialMediaBloc, AppState>(
                              builder: (context, state) {
                                return CustomButton(
                                  text:
                                      "${getTranslated("continue_with")} Google",
                                  svgIcon: SvgImages.google,
                                  backgroundColor: Styles.FILL_COLOR,
                                  textColor: Styles.TITLE,
                                  withBorderColor: true,
                                  borderColor: Styles.LIGHT_BORDER_COLOR,
                                  onTap: () {
                                    context.read<SocialMediaBloc>().add(Click(
                                          arguments: {
                                            "provider":
                                                SocialMediaProvider.google
                                          },
                                        ));
                                  },
                                  isLoading: state is Loading,
                                );
                              },
                            ),
                          ),
                        ),




                        ///Login With Facebook
                        BlocProvider(
                          create: (context) =>
                              SocialMediaBloc(repo: sl<SocialMediaRepo>()),
                          child: BlocBuilder<SocialMediaBloc, AppState>(
                            builder: (context, state) {
                              return CustomButton(
                                text:
                                    "${getTranslated("continue_with")} Facebook",
                                svgIcon: SvgImages.faceBook,
                                backgroundColor: Colors.white,
                                textColor: Styles.TITLE,
                                withBorderColor: true,
                                borderColor: Styles.LIGHT_BORDER_COLOR,
                                onTap: () {
                                  context.read<SocialMediaBloc>().add(Click(
                                      arguments: SocialMediaProvider.facebook));
                                },
                                isLoading: state is Loading,
                              );
                            },
                          ),
                        ),*/
                      ],
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}
