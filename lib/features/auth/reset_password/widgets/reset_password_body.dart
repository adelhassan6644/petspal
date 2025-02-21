import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/core/svg_images.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_text_form_field.dart';
import '../bloc/reset_password_bloc.dart';
import '../entity/reset_password_entity.dart';

class ResetPasswordBody extends StatelessWidget {
  const ResetPasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<ResetPasswordBloc>().formKey,
      child: StreamBuilder<ResetPasswordEntity?>(
        stream: context.read<ResetPasswordBloc>().resetPasswordEntityStream,
        initialData: ResetPasswordEntity(
          password: TextEditingController(),
          confirmPassword: TextEditingController(),
        ),
        builder: (context, snapshot) {
          return Column(
            children: [
              ///New Password
              CustomTextField(
                controller: snapshot.data?.password,
                label: getTranslated("new_password"),
                hint: getTranslated("enter_new_password"),
                focusNode: context.read<ResetPasswordBloc>().passwordNode,
                nextFocus:
                    context.read<ResetPasswordBloc>().confirmPasswordNode,
                inputType: TextInputType.visiblePassword,
                isPassword: true,
                pSvgIcon: SvgImages.lockIcon,
                validate: (v) {
                  context.read<ResetPasswordBloc>().updateResetPasswordEntity(
                      snapshot.data?.copyWith(
                          passwordError: Validations.firstPassword(v) ?? ""));
                  return null;
                },
                errorText: snapshot.data?.passwordError,
                customError: snapshot.data?.passwordError != null &&
                    snapshot.data?.passwordError != "",
              ),

              ///Confirm New Password
              CustomTextField(
                controller: snapshot.data?.confirmPassword,
                label: getTranslated("confirm_new_password"),
                hint: getTranslated("enter_confirm_new_password"),
                focusNode:
                    context.read<ResetPasswordBloc>().confirmPasswordNode,
                inputType: TextInputType.visiblePassword,
                isPassword: true,
                pSvgIcon: SvgImages.lockIcon,
                validate: (v) {
                  context.read<ResetPasswordBloc>().updateResetPasswordEntity(
                      snapshot.data?.copyWith(
                          confirmPasswordError: Validations.confirmNewPassword(
                                  snapshot.data?.password?.text.trim(), v) ??
                              ""));
                  return null;
                },
                errorText: snapshot.data?.confirmPasswordError,
                customError: snapshot.data?.confirmPasswordError != null &&
                    snapshot.data?.confirmPasswordError != "",
                keyboardAction: TextInputAction.done,
              ),
            ],
          );
        },
      ),
    );
  }
}
