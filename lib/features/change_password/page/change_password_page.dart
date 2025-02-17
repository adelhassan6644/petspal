import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/app/core/app_state.dart';
import 'package:zurex/app/core/dimensions.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/animated_widget.dart';
import '../../../../components/custom_app_bar.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_text_form_field.dart';
import '../../../../data/config/di.dart';
import '../../../app/core/app_event.dart';
import '../bloc/change_password_bloc.dart';
import '../repo/change_password_repo.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode currentPasswordNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final FocusNode confirmPasswordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePasswordBloc(repo: sl<ChangePasswordRepo>()),
      child: BlocBuilder<ChangePasswordBloc, AppState>(
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(
              title: getTranslated("change_password"),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListAnimator(
                    customPadding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                        vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
                    data: [
                      Center(
                        child: Text(
                          getTranslated("reset_password_description"),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.w600
                              .copyWith(fontSize: 22, color: Styles.HEADER),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.PADDING_SIZE_DEFAULT.h,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              ///Current Password
                              CustomTextField(
                                controller: context
                                    .read<ChangePasswordBloc>()
                                    .currentPasswordTEC,
                                label: getTranslated("current_password"),
                                hint: getTranslated("enter_current_password"),
                                focusNode: currentPasswordNode,
                                inputType: TextInputType.visiblePassword,
                                validate: Validations.firstPassword,
                                isPassword: true,
                              ),

                              ///New Password
                              CustomTextField(
                                controller: context
                                    .read<ChangePasswordBloc>()
                                    .newPasswordTEC,
                                label: getTranslated("new_password"),
                                hint: getTranslated("enter_new_password"),
                                focusNode: passwordNode,
                                inputType: TextInputType.visiblePassword,
                                validate: (v) => Validations.newPassword(
                                    context
                                        .read<ChangePasswordBloc>()
                                        .currentPasswordTEC
                                        .text
                                        .trim(),
                                    v),
                                isPassword: true,
                              ),

                              ///Confirm New Password
                              CustomTextField(
                                controller: context
                                    .read<ChangePasswordBloc>()
                                    .confirmNewPasswordTEC,
                                label: getTranslated("confirm_new_password"),
                                hint:
                                    getTranslated("enter_confirm_new_password"),
                                focusNode: confirmPasswordNode,
                                inputType: TextInputType.visiblePassword,
                                validate: (v) => Validations.confirmNewPassword(
                                    context
                                        .read<ChangePasswordBloc>()
                                        .newPasswordTEC
                                        .text
                                        .trim(),
                                    v),
                                isPassword: true,
                              ),

                              ///Confirm
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 16.h,
                                ),
                                child: CustomButton(
                                    text: getTranslated("save"),
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        context
                                            .read<ChangePasswordBloc>()
                                            .add(Click());
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
