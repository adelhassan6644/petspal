import 'dart:io';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/app/core/svg_images.dart';
import 'package:petspal/components/animated_widget.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_text_form_field.dart';
import '../../../../main_widgets/country_selection.dart';
import '../../../../main_widgets/profile_image_widget.dart';
import '../bloc/register_bloc.dart';

class RegisterBody extends StatefulWidget {
  const RegisterBody({super.key});

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final FocusNode nameNode = FocusNode();
  final FocusNode emailNode = FocusNode();
  final FocusNode phoneNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final FocusNode confirmPasswordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<RegisterBloc, AppState>(
        builder: (context, state) {
          return ListAnimator(
            customPadding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
            data: [
              Form(
                  key: context.read<RegisterBloc>().formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///Image Profile
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                        ),
                        child: StreamBuilder<File?>(
                            stream:
                                context.read<RegisterBloc>().profileImageStream,
                            builder: (context, snapshot) {
                              return ProfileImageWidget(
                                  withEdit: true,
                                  imageFile: snapshot.data,
                                  onGet: context
                                      .read<RegisterBloc>()
                                      .updateProfileImage);
                            }),
                      ),

                      ///Name
                      CustomTextField(
                        controller: context.read<RegisterBloc>().nameTEC,
                        focusNode: nameNode,
                        nextFocus: emailNode,
                        label: getTranslated("name"),
                        hint: getTranslated("enter_your_name"),
                        inputType: TextInputType.name,
                        validate: Validations.name,
                        pSvgIcon: SvgImages.user,
                      ),

                      ///Mail
                      CustomTextField(
                        controller: context.read<RegisterBloc>().mailTEC,
                        focusNode: emailNode,
                        nextFocus: phoneNode,
                        label: getTranslated("mail"),
                        hint: getTranslated("enter_your_mail"),
                        inputType: TextInputType.emailAddress,
                        validate: Validations.mail,
                        pSvgIcon: SvgImages.mailIcon,
                      ),

                      ///Phone
                      CustomTextField(
                        controller: context.read<RegisterBloc>().phoneTEC,
                        focusNode: phoneNode,
                        label: getTranslated("phone"),
                        hint: getTranslated("enter_your_phone"),
                        inputType: TextInputType.phone,
                        validate: Validations.phone,
                        pSvgIcon: SvgImages.phoneCallIcon,
                      ),

                      ///Country
                      StreamBuilder<CountryCode?>(
                          stream: context.read<RegisterBloc>().countryStream,
                          builder: (context, snapshot) {
                            return CountrySelection(
                              initialSelection: snapshot.data?.code,
                              onSelect: (v) =>
                                  context.read<RegisterBloc>().updateCountry(v),
                            );
                          }),

                      ///Password
                      CustomTextField(
                        controller: context.read<RegisterBloc>().passwordTEC,
                        label: getTranslated("password"),
                        hint: getTranslated("enter_your_password"),
                        focusNode: passwordNode,
                        nextFocus: confirmPasswordNode,
                        inputType: TextInputType.visiblePassword,
                        validate: Validations.firstPassword,
                        isPassword: true,
                        pSvgIcon: SvgImages.lockIcon,
                      ),

                      ///Confirm Password
                      CustomTextField(
                        controller:
                            context.read<RegisterBloc>().confirmPasswordTEC,
                        label: getTranslated("confirm_password"),
                        hint: getTranslated("enter_confirm_password"),
                        focusNode: confirmPasswordNode,
                        inputType: TextInputType.visiblePassword,
                        validate: (v) => Validations.confirmPassword(
                            context
                                .read<RegisterBloc>()
                                .passwordTEC
                                .text
                                .trim(),
                            v),
                        isPassword: true,
                        pSvgIcon: SvgImages.lockIcon,
                      ),
                    ],
                  )),
            ],
          );
        },
      ),
    );
  }
}
