import 'dart:io';
import 'package:country_flags/country_flags.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/app/core/svg_images.dart';
import 'package:petspal/components/animated_widget.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_text_form_field.dart';
import '../../../../main_widgets/profile_image_widget.dart';
import '../bloc/edit_profile_bloc.dart';

class EditProfileBody extends StatefulWidget {
  const EditProfileBody({super.key, required this.fromComplete});
  final bool fromComplete;

  @override
  State<EditProfileBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<EditProfileBody> {
  final FocusNode nameNode = FocusNode();
  final FocusNode emailNode = FocusNode();
  final FocusNode phoneNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<EditProfileBloc, AppState>(
        builder: (context, state) {
          return ListAnimator(
            customPadding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
            data: [
              Form(
                  key: context.read<EditProfileBloc>().formKey,
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
                            stream: context
                                .read<EditProfileBloc>()
                                .profileImageStream,
                            builder: (context, snapshot) {
                              return ProfileImageWidget(
                                  withEdit: true,
                                  imageFile: snapshot.data,
                                  onGet: context
                                      .read<EditProfileBloc>()
                                      .updateProfileImage);
                            }),
                      ),

                      ///Name
                      CustomTextField(
                        controller: context.read<EditProfileBloc>().nameTEC,
                        focusNode: nameNode,
                        nextFocus: emailNode,
                        label: getTranslated("name"),
                        hint: getTranslated("enter_your_name"),
                        inputType: TextInputType.name,
                        validate: Validations.name,
                        pSvgIcon: SvgImages.user,
                      ),

                      ///Phone
                      // if (!widget.fromComplete)
                      CustomTextField(
                        controller: context.read<EditProfileBloc>().phoneTEC,
                        focusNode: phoneNode,
                        label: getTranslated("phone"),
                        hint: getTranslated("enter_your_phone"),
                        inputType: TextInputType.phone,
                        validate: Validations.phone,
                        // pSvgIcon: SvgImages.phoneCallIcon,
                        isEnabled: false,
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

                      ///Mail
                      CustomTextField(
                        controller: context.read<EditProfileBloc>().mailTEC,
                        focusNode: emailNode,
                        nextFocus: phoneNode,
                        label: getTranslated("mail"),
                        hint: getTranslated("enter_your_mail"),
                        inputType: TextInputType.emailAddress,
                        validate: Validations.mail,
                        pSvgIcon: SvgImages.mailIcon,
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
