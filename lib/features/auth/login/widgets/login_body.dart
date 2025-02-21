import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/components/animated_widget.dart';
import 'package:petspal/components/custom_images.dart';
import 'package:petspal/features/language/bloc/language_bloc.dart';
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
                      StreamBuilder<String?>(
                          stream: context.read<LoginBloc>().emailStream,
                          builder: (context, snapshot) {
                            return CustomTextField(
                              autofillHints: const [
                                AutofillHints.email,
                                AutofillHints.username,
                              ],
                              onChanged: context.read<LoginBloc>().updateEmail,
                              focusNode: context.read<LoginBloc>().emailNode,
                              nextFocus: context.read<LoginBloc>().passwordNode,
                              label: getTranslated("mail_or_phone_number"),
                              hint: getTranslated("enter_mail_or_phone_number"),
                              inputType: TextInputType.emailAddress,
                              pSvgIcon: SvgImages.user,
                              validate: (v) {
                                if ((v) != null) {
                                  context
                                      .read<LoginBloc>()
                                      .email
                                      .addError(Validations.mail(v) ?? "");
                                }
                                return null;
                              },
                              errorText: snapshot.error,
                              customError: snapshot.hasError,
                            );
                          }),

                      ///Password
                      StreamBuilder<String?>(
                          stream: context.read<LoginBloc>().passwordStream,
                          builder: (context, snapshot) {
                            return CustomTextField(
                              autofillHints: const [AutofillHints.password],
                              onChanged: context.read<LoginBloc>().updatePassword,
                              keyboardAction: TextInputAction.done,
                              label: getTranslated("password"),
                              hint: getTranslated("enter_your_password"),
                              focusNode: context.read<LoginBloc>().passwordNode,
                              inputType: TextInputType.visiblePassword,
                              isPassword: true,
                              pSvgIcon: SvgImages.lockIcon,
                              validate: (v) {
                                if ((v) != null) {
                                  context
                                      .read<LoginBloc>()
                                      .password
                                      .addError(Validations.password(v) ?? "");
                                }
                                return null;
                              },
                              errorText: snapshot.error,
                              customError: snapshot.hasError,
                            );
                          }),

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
                                  // decoration: TextDecoration.underline,
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
                            vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
                        child: StreamBuilder<bool>(
                            stream: context.read<LoginBloc>().loginStream,
                            builder: (context, snapshot) {
                              return CustomButton(
                                  text: getTranslated("sign_in"),
                                  onTap: () {
                                    context
                                        .read<LoginBloc>()
                                        .formKey
                                        .currentState!
                                        .validate();
                                    if (snapshot.data == true) {
                                      TextInput.finishAutofillContext();
                                      context.read<LoginBloc>().add(Click());
                                    }
                                  },
                                  rIconWidget: RotatedBox(
                                    quarterTurns:
                                        sl<LanguageBloc>().isLtr ? 0 : 2,
                                    child: customImageIconSVG(
                                      imageName: SvgImages.forwardArrow,
                                      color: Styles.WHITE_COLOR,
                                    ),
                                  ),
                                  isLoading: state is Loading);
                            }),
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
                                  text:
                                      " ${getTranslated("create_an_account")}",
                                  style: AppTextStyles.w600.copyWith(
                                    fontSize: 16,
                                    color: Styles.PRIMARY_COLOR,
                                    // decoration: TextDecoration.underline
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () =>
                                        CustomNavigator.push(Routes.register)),
                            ]),
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
                                  color: Styles.HINT_COLOR,
                                  height: 12.h,
                                )),
                                Text(
                                  "  ${getTranslated("or")}  ",
                                  style: AppTextStyles.w500.copyWith(
                                      fontSize: 14, color: Styles.HINT_COLOR),
                                ),
                                Expanded(
                                    child: Divider(
                                  color: Styles.HINT_COLOR,
                                  height: 12.h,
                                )),
                              ],
                            ),
                            SizedBox(height: 8.h),
                          ],
                        ),
                      ),

                      Wrap(
                        runSpacing: 16.w,
                        spacing: 16.h,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          ///Login With Google
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.PADDING_SIZE_SMALL.h),
                            child: BlocProvider(
                              create: (context) =>
                                  SocialMediaBloc(repo: sl<SocialMediaRepo>()),
                              child: BlocBuilder<SocialMediaBloc, AppState>(
                                builder: (context, state) {
                                  return customImageIconSVG(
                                    imageName: SvgImages.google,
                                    width: 40.w,
                                    height: 40.w,
                                    onTap: () {
                                      context.read<SocialMediaBloc>().add(Click(
                                            arguments: {
                                              "provider":
                                                  SocialMediaProvider.google
                                            },
                                          ));
                                    },
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
                                return customImageIconSVG(
                                  imageName: SvgImages.faceBook,
                                  width: 40.w,
                                  height: 40.w,
                                  onTap: () {
                                    context.read<SocialMediaBloc>().add(Click(
                                        arguments:
                                            SocialMediaProvider.facebook));
                                  },
                                );
                              },
                            ),
                          ),

                          if (Platform.isIOS)
                            BlocProvider(
                              create: (context) =>
                                  SocialMediaBloc(repo: sl<SocialMediaRepo>()),
                              child: BlocBuilder<SocialMediaBloc, AppState>(
                                builder: (context, state) {
                                  return customImageIconSVG(
                                    imageName: SvgImages.apple,
                                    width: 40.w,
                                    height: 40.w,
                                    onTap: () {
                                      context.read<SocialMediaBloc>().add(Click(
                                            arguments: {
                                              "provider":
                                                  SocialMediaProvider.apple
                                            },
                                          ));
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
