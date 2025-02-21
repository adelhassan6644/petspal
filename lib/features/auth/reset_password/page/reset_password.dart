import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/features/auth/reset_password/bloc/reset_password_bloc.dart';
import 'package:petspal/features/auth/reset_password/repo/reset_password_repo.dart';

import '../../../../app/core/app_event.dart';
import '../../../../app/core/images.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/svg_images.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/animated_widget.dart';
import '../../../../components/custom_app_bar.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_images.dart';
import '../../../../components/custom_text_form_field.dart';
import '../../../../data/config/di.dart';
import '../../verification/model/verification_model.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key, required this.data});
  final VerificationModel data;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode passwordNode = FocusNode();
  final FocusNode confirmPasswordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordBloc(repo: sl<ResetPasswordRepo>()),
      child: BlocBuilder<ResetPasswordBloc, AppState>(
        builder: (context, state) {
          return Scaffold(
            appBar: const CustomAppBar(),
            body: Column(
              children: [
                Expanded(
                  child: ListAnimator(
                    customPadding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                        vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
                    data: [
                      Center(
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
                            child: customImageIcon(
                                imageName: Images.authLogo,
                                width: 230.w,
                                height: 130.h)),
                      ),
                      Text(
                        getTranslated("reset_password_header"),
                        style: AppTextStyles.w700.copyWith(
                          fontSize: 24,
                          color: Styles.HEADER,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Text(
                          getTranslated("reset_password_title"),
                          style: AppTextStyles.w600
                              .copyWith(fontSize: 20, color: Styles.TITLE),
                        ),
                      ),
                      Text(
                        getTranslated("reset_password_description"),
                        style: AppTextStyles.w500.copyWith(
                            fontSize: 16, color: Styles.DETAILS_COLOR),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL.h),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              ///New Password
                              CustomTextField(
                                controller: context
                                    .read<ResetPasswordBloc>()
                                    .passwordTEC,
                                label: getTranslated("new_password"),
                                hint: getTranslated("enter_new_password"),
                                focusNode: passwordNode,
                                inputType: TextInputType.visiblePassword,
                                validate: Validations.firstPassword,
                                isPassword: true,
                                pSvgIcon: SvgImages.lockIcon,
                              ),

                              ///Confirm New Password
                              CustomTextField(
                                controller: context
                                    .read<ResetPasswordBloc>()
                                    .confirmPasswordTEC,
                                label: getTranslated("confirm_new_password"),
                                hint:
                                    getTranslated("enter_confirm_new_password"),
                                focusNode: confirmPasswordNode,
                                inputType: TextInputType.visiblePassword,
                                validate: (v) => Validations.confirmNewPassword(
                                    context
                                        .read<ResetPasswordBloc>()
                                        .passwordTEC
                                        .text
                                        .trim(),
                                    v),
                                isPassword: true,
                                pSvgIcon: SvgImages.lockIcon,
                              ),

                              ///Confirm
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 16.h,
                                ),
                                child: CustomButton(
                                    text: getTranslated("confirm_password"),
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        context
                                            .read<ResetPasswordBloc>()
                                            .add(Click(arguments: widget.data));
                                      }
                                    },
                                    isLoading: state is Loading),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
