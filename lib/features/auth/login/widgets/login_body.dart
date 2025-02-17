import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/components/animated_widget.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/svg_images.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_text_form_field.dart';
import '../../../../data/config/di.dart';
import '../../../../helpers/social_media_login_helper.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';
import '../../social_media_login/bloc/social_media_bloc.dart';
import '../../social_media_login/repo/social_media_repo.dart';
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
                        ///Mail
                        CustomTextField(
                          autofillHints: const [
                            AutofillHints.email,
                            AutofillHints.username,
                          ],
                          controller: context.read<LoginBloc>().emailTEC,
                          focusNode: context.read<LoginBloc>().phoneNode,
                          nextFocus: context.read<LoginBloc>().passwordNode,
                          label: getTranslated("mail"),
                          hint: getTranslated("enter_your_mail"),
                          inputType: TextInputType.emailAddress,
                          validate: Validations.mail,
                          pSvgIcon: SvgImages.mailIcon,
                        ),

                        ///Password
                        CustomTextField(
                          autofillHints: const [AutofillHints.password],
                          controller: context.read<LoginBloc>().passwordTEC,
                          keyboardAction: TextInputAction.done,
                          label: getTranslated("password"),
                          hint: getTranslated("enter_your_password"),
                          focusNode: context.read<LoginBloc>().passwordNode,
                          inputType: TextInputType.visiblePassword,
                          validate: Validations.password,
                          isPassword: true,
                          pSvgIcon: SvgImages.lockIcon,
                        ),

                        ///Forget Password && Remember me
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeExtraSmall.h,
                              horizontal: Dimensions.paddingSizeExtraSmall.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // StreamBuilder<bool?>(
                              //   stream:
                              //       context.read<LoginBloc>().rememberMeStream,
                              //   builder: (_, snapshot) {
                              //     return _RememberMe(
                              //       check: snapshot.data ?? false,
                              //       onChange: (v) => context
                              //           .read<LoginBloc>()
                              //           .updateRememberMe(v),
                              //     );
                              //   },
                              // ),
                              const Expanded(child: SizedBox()),
                              InkWell(
                                onTap: () {
                                  context.read<LoginBloc>().clear();
                                  CustomNavigator.push(Routes.forgetPassword);
                                },
                                child: Text(
                                  getTranslated("forget_password"),
                                  style: AppTextStyles.w500.copyWith(
                                    color: Styles.PRIMARY_COLOR,
                                    fontSize: 13,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Styles.PRIMARY_COLOR,
                                  ),
                                ),
                              ),
                            ],
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

                        Padding(
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
                        ),
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
