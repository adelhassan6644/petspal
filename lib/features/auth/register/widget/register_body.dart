import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/app/core/svg_images.dart';
import 'package:petspal/features/auth/register/enitity/register_entity.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_text_form_field.dart';
import '../../../countries/view/country_selection.dart';
import '../bloc/register_bloc.dart';

class RegisterBody extends StatelessWidget {
  const RegisterBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, AppState>(
      builder: (context, state) {
        return StreamBuilder<RegisterEntity?>(
            stream: context.read<RegisterBloc>().registerEntityStream,
            initialData: RegisterEntity(
              name: TextEditingController(),
              email: TextEditingController(),
              phone: TextEditingController(),
              password: TextEditingController(),
              confirmPassword: TextEditingController(),
            ),
            builder: (context, snapshot) {
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
                      CustomTextField(
                        controller: snapshot.data?.name,
                        label: getTranslated("name"),
                        hint: getTranslated("enter_your_name"),
                        inputType: TextInputType.name,
                        pSvgIcon: SvgImages.user,
                        nextFocus: context.read<RegisterBloc>().emailNode,
                        focusNode: context.read<RegisterBloc>().nameNode,
                        validate: (v) {
                          context.read<RegisterBloc>().updateRegisterEntity(
                              snapshot.data?.copyWith(
                                  nameError: Validations.name(v) ?? ""));
                          return null;
                        },
                        errorText: snapshot.data?.nameError,
                        customError: snapshot.data?.nameError != null &&
                            snapshot.data?.nameError != "",
                      ),

                      ///Mail
                      CustomTextField(
                        controller: snapshot.data?.email,
                        focusNode: context.read<RegisterBloc>().emailNode,
                        nextFocus: context.read<RegisterBloc>().phoneNode,
                        label: getTranslated("mail"),
                        hint: getTranslated("enter_your_mail"),
                        inputType: TextInputType.emailAddress,
                        pSvgIcon: SvgImages.mail,
                        validate: (v) {
                          context.read<RegisterBloc>().updateRegisterEntity(
                              snapshot.data?.copyWith(
                                  emailError: Validations.mail(v) ?? ""));
                          return null;
                        },
                        errorText: snapshot.data?.emailError,
                        customError: snapshot.data?.emailError != null &&
                            snapshot.data?.emailError != "",
                      ),

                      ///Phone
                      CustomTextField(
                        controller: snapshot.data?.phone,
                        label: getTranslated("phone"),
                        hint: getTranslated("enter_your_phone"),
                        inputType: TextInputType.phone,
                        pSvgIcon: SvgImages.phone,
                        focusNode: context.read<RegisterBloc>().phoneNode,
                        nextFocus: context.read<RegisterBloc>().countryNode,
                        validate: (v) {
                          context.read<RegisterBloc>().updateRegisterEntity(
                              snapshot.data?.copyWith(
                                  phoneError: Validations.phone(v) ?? ""));
                          return null;
                        },
                        errorText: snapshot.data?.phoneError,
                        customError: snapshot.data?.phoneError != null &&
                            snapshot.data?.phoneError != "",
                      ),

                      ///Country
                      CountrySelection(
                        initialSelection: snapshot.data?.country,
                        onSelect: (v) {
                          context.read<RegisterBloc>().updateRegisterEntity(
                              snapshot.data?.copyWith(country: v));
                        },
                        focusNode: context.read<RegisterBloc>().countryNode,
                        nextFocus: context.read<RegisterBloc>().passwordNode,
                        validate: (v) {
                          context.read<RegisterBloc>().updateRegisterEntity(
                              snapshot.data?.copyWith(
                                  countryError: Validations.field(
                                          snapshot.data?.country?.name,
                                          fieldName:
                                              getTranslated("country")) ??
                                      ""));
                          return null;
                        },
                        error: snapshot.data?.countryError,
                        haseError: snapshot.data?.countryError != null &&
                            snapshot.data?.countryError != "",
                      ),

                      ///Password
                      CustomTextField(
                        controller: snapshot.data?.password,
                        label: getTranslated("password"),
                        hint: getTranslated("enter_your_password"),
                        focusNode: context.read<RegisterBloc>().passwordNode,
                        nextFocus:
                            context.read<RegisterBloc>().confirmPasswordNode,
                        inputType: TextInputType.visiblePassword,
                        isPassword: true,
                        pSvgIcon: SvgImages.lockIcon,
                        validate: (v) {
                          context.read<RegisterBloc>().updateRegisterEntity(
                              snapshot.data?.copyWith(
                                  passwordError:
                                      Validations.firstPassword(v) ?? ""));
                          return null;
                        },
                        errorText: snapshot.data?.passwordError,
                        customError: snapshot.data?.passwordError != null &&
                            snapshot.data?.passwordError != "",
                      ),

                      ///Confirm Password
                      CustomTextField(
                        controller: snapshot.data?.confirmPassword,
                        label: getTranslated("confirm_password"),
                        hint: getTranslated("enter_confirm_password"),
                        focusNode: context.read<RegisterBloc>().confirmPasswordNode,
                        inputType: TextInputType.visiblePassword,
                        isPassword: true,
                        pSvgIcon: SvgImages.lockIcon,
                        validate: (v) {
                          context.read<RegisterBloc>().updateRegisterEntity(
                              snapshot.data?.copyWith(
                                  confirmPasswordError:
                                      Validations.confirmNewPassword(
                                              snapshot.data?.password?.text.trim(), v) ??
                                          ""));
                          return null;
                        },
                        errorText: snapshot.data?.confirmPasswordError,
                        customError: snapshot.data?.confirmPasswordError != null && snapshot.data?.confirmPasswordError != "",
                        keyboardAction: TextInputAction.done,
                      ),
                    ],
                  ));
            });
      },
    );
  }
}
