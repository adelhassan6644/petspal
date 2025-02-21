import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/app/core/svg_images.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_text_form_field.dart';
import '../../../../main_models/custom_field_model.dart';
import '../../../countries/view/country_selection.dart';
import '../bloc/register_bloc.dart';

class RegisterBody extends StatelessWidget {
  const RegisterBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, AppState>(
      builder: (context, state) {
        return Form(
            key: context.read<RegisterBloc>().formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ///Image Profile
                // Padding(
                //   padding: EdgeInsets.symmetric(
                //     vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                //     horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                //   ),
                //   child: StreamBuilder<File?>(
                //       stream:
                //           context.read<RegisterBloc>().profileImageStream,
                //       builder: (context, snapshot) {
                //         return ProfileImageWidget(
                //             withEdit: true,
                //             imageFile: snapshot.data,
                //             onGet: context
                //                 .read<RegisterBloc>()
                //                 .updateProfileImage);
                //       }),
                // ),

                ///Name
                StreamBuilder<String?>(
                    stream: context.read<RegisterBloc>().nameStream,
                    builder: (context, snapshot) {
                      return CustomTextField(
                        label: getTranslated("name"),
                        hint: getTranslated("enter_your_name"),
                        inputType: TextInputType.name,
                        pSvgIcon: SvgImages.user,
                        nextFocus: context.read<RegisterBloc>().emailNode,
                        onChanged: context.read<RegisterBloc>().updateName,
                        focusNode: context.read<RegisterBloc>().nameNode,
                        validate: (v) {
                          if ((v) != null) {
                            context
                                .read<RegisterBloc>()
                                .name
                                .addError(Validations.name(v) ?? "");
                          }
                          return null;
                        },
                        errorText: snapshot.error,
                        customError: snapshot.hasError,
                      );
                    }),

                ///Mail
                StreamBuilder<String?>(
                    stream: context.read<RegisterBloc>().emailStream,
                    builder: (context, snapshot) {
                      return CustomTextField(
                        onChanged: context.read<RegisterBloc>().updateEmail,
                        focusNode: context.read<RegisterBloc>().emailNode,
                        nextFocus: context.read<RegisterBloc>().phoneNode,
                        label: getTranslated("mail"),
                        hint: getTranslated("enter_your_mail"),
                        inputType: TextInputType.emailAddress,
                        pSvgIcon: SvgImages.mail,
                        validate: (v) {
                          if ((v) != null) {
                            context
                                .read<RegisterBloc>()
                                .email
                                .addError(Validations.mail(v) ?? "");
                          }
                          return null;
                        },
                        errorText: snapshot.error,
                        customError: snapshot.hasError,
                      );
                    }),

                ///Phone
                StreamBuilder<String?>(
                    stream: context.read<RegisterBloc>().phoneStream,
                    builder: (context, snapshot) {
                      return CustomTextField(
                        label: getTranslated("phone"),
                        hint: getTranslated("enter_your_phone"),
                        inputType: TextInputType.phone,
                        pSvgIcon: SvgImages.phone,
                        onChanged: context.read<RegisterBloc>().updatePhone,
                        focusNode: context.read<RegisterBloc>().phoneNode,
                        nextFocus: context.read<RegisterBloc>().countryNode,
                        validate: (v) {
                          if ((v) != null) {
                            context
                                .read<RegisterBloc>()
                                .phone
                                .addError(Validations.phone(v) ?? "");
                          }
                          return null;
                        },
                        errorText: snapshot.error,
                        customError: snapshot.hasError,
                      );
                    }),

                ///Country
                StreamBuilder<CustomFieldModel?>(
                    stream: context.read<RegisterBloc>().countryStream,
                    builder: (context, snapshot) {
                      log(snapshot.data?.name ?? "");
                      return CountrySelection(
                        focusNode: context.read<RegisterBloc>().countryNode,
                        nextFocus: context.read<RegisterBloc>().passwordNode,
                        onSelect: context.read<RegisterBloc>().updateCountry,
                        initialSelection: snapshot.data,
                        validate: (v) {
                          if ((v) != null) {
                            context.read<RegisterBloc>().country.addError(
                                Validations.field(snapshot.data?.name ?? "",
                                        fieldName: getTranslated("country")) ??
                                    "");
                          }
                          return null;
                        },
                        error: snapshot.error,
                        haseError: snapshot.hasError,
                      );
                    }),

                ///Password
                StreamBuilder<String?>(
                    stream: context.read<RegisterBloc>().passwordStream,
                    builder: (context, snapshot) {
                      return CustomTextField(
                        label: getTranslated("password"),
                        hint: getTranslated("enter_your_password"),
                        onChanged: context.read<RegisterBloc>().updatePassword,
                        focusNode: context.read<RegisterBloc>().passwordNode,
                        nextFocus:
                            context.read<RegisterBloc>().confirmPasswordNode,
                        inputType: TextInputType.visiblePassword,
                        isPassword: true,
                        pSvgIcon: SvgImages.lockIcon,
                        validate: (v) {
                          if ((v) != null) {
                            context
                                .read<RegisterBloc>()
                                .password
                                .addError(Validations.firstPassword(v) ?? "");
                          }
                          return null;
                        },
                        errorText: snapshot.error,
                        customError: snapshot.hasError,
                      );
                    }),

                ///Confirm Password
                StreamBuilder<String?>(
                    stream: context.read<RegisterBloc>().confirmPasswordStream,
                    builder: (context, snapshot) {
                      return CustomTextField(
                        label: getTranslated("confirm_password"),
                        hint: getTranslated("enter_confirm_password"),
                        onChanged:
                            context.read<RegisterBloc>().updateConfirmPassword,
                        focusNode:
                            context.read<RegisterBloc>().confirmPasswordNode,
                        inputType: TextInputType.visiblePassword,
                        isPassword: true,
                        pSvgIcon: SvgImages.lockIcon,
                        validate: (v) {
                          if ((v) != null) {
                            context
                                .read<RegisterBloc>()
                                .confirmPassword
                                .addError(Validations.confirmNewPassword(
                                        context
                                            .read<RegisterBloc>()
                                            .password
                                            .valueOrNull,
                                        v) ??
                                    "");
                          }
                          return null;
                        },
                        errorText: snapshot.error,
                        customError: snapshot.hasError,
                        keyboardAction: TextInputAction.done,
                      );
                    }),
              ],
            ));
      },
    );
  }
}
