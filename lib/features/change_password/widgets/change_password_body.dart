import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/features/change_password/bloc/change_password_bloc.dart';
import 'package:petspal/features/change_password/entity/change_password_entity.dart';

import '../../../../app/core/svg_images.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_text_form_field.dart';

class ChangePasswordBody extends StatelessWidget {
  const ChangePasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<ChangePasswordBloc>().formKey,
      child: StreamBuilder<ChangePasswordEntity?>(
        stream: context.read<ChangePasswordBloc>().changePasswordEntityStream,
        initialData: ChangePasswordEntity(
          currentPassword: TextEditingController(),
          newPassword: TextEditingController(),
          confirmNewPassword: TextEditingController(),
        ),
        builder: (context, snapshot) {
          return Column(
            children: [
              ///Current Password
              CustomTextField(
                controller: snapshot.data?.currentPassword,
                label: getTranslated("current_password"),
                hint: getTranslated("enter_current_password"),
                focusNode:
                    context.read<ChangePasswordBloc>().currentPasswordNode,
                nextFocus: context.read<ChangePasswordBloc>().passwordNode,
                inputType: TextInputType.visiblePassword,
                isPassword: true,
                pSvgIcon: SvgImages.lockIcon,
                validate: (v) {
                  context.read<ChangePasswordBloc>().updateChangePasswordEntity(
                      snapshot.data?.copyWith(
                          currentPasswordError:
                              Validations.firstPassword(v) ?? ""));
                  return null;
                },
                errorText: snapshot.data?.currentPasswordError,
                customError: snapshot.data?.currentPasswordError != null &&
                    snapshot.data?.currentPasswordError != "",
              ),

              ///New Password
              CustomTextField(
                controller: snapshot.data?.newPassword,
                label: getTranslated("new_password"),
                hint: getTranslated("enter_new_password"),
                focusNode: context.read<ChangePasswordBloc>().passwordNode,
                nextFocus:
                    context.read<ChangePasswordBloc>().confirmPasswordNode,
                inputType: TextInputType.visiblePassword,
                validate: (v) {
                  context.read<ChangePasswordBloc>().updateChangePasswordEntity(
                      snapshot.data?.copyWith(
                          newPasswordError: Validations.newPassword(
                                  snapshot.data?.currentPassword?.text.trim(),
                                  v) ??
                              ""));
                  return null;
                },
                isPassword: true,
                pSvgIcon: SvgImages.lockIcon,
                errorText: snapshot.data?.newPasswordError,
                customError: snapshot.data?.newPasswordError != null &&
                    snapshot.data?.newPasswordError != "",
              ),

              ///Confirm New Password
              CustomTextField(
                controller: snapshot.data?.confirmNewPassword,
                label: getTranslated("confirm_new_password"),
                hint: getTranslated("enter_confirm_new_password"),
                focusNode:
                    context.read<ChangePasswordBloc>().confirmPasswordNode,
                inputType: TextInputType.visiblePassword,
                keyboardAction: TextInputAction.done,
                validate: (v) {
                  context.read<ChangePasswordBloc>().updateChangePasswordEntity(
                      snapshot.data?.copyWith(
                          confirmNewPasswordError:
                              Validations.confirmNewPassword(
                                      snapshot.data?.newPassword?.text.trim(),
                                      v) ??
                                  ""));
                  return null;
                },
                isPassword: true,
                pSvgIcon: SvgImages.lockIcon,
                errorText: snapshot.data?.confirmNewPasswordError,
                customError: snapshot.data?.confirmNewPasswordError != null &&
                    snapshot.data?.confirmNewPasswordError != "",
              ),
            ],
          );
        },
      ),
    );
  }
}
