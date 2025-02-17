import 'package:country_codes/country_codes.dart';
import 'package:country_flags/country_flags.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/components/custom_app_bar.dart';
import 'package:zurex/features/auth/forget_password/bloc/forget_password_bloc.dart';
import 'package:zurex/features/auth/forget_password/repo/forget_password_repo.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/svg_images.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/animated_widget.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_text_form_field.dart';
import '../../../../data/config/di.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key, required this.userType});
  final String userType;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordBloc(repo: sl<ForgetPasswordRepo>()),
      child: BlocBuilder<ForgetPasswordBloc, AppState>(
        builder: (context, state) {
          return Scaffold(
            appBar: const CustomAppBar(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: ListAnimator(
                    customPadding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                        vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
                    data: [
                      Center(
                        child: Text(
                          getTranslated("forget_password_header"),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.w600.copyWith(
                            fontSize: 24,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          getTranslated("forget_password_description"),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.w500.copyWith(
                              fontSize: 14, color: Styles.DETAILS_COLOR),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.PADDING_SIZE_DEFAULT.h,
                      ),
                      Form(
                          key: context.read<ForgetPasswordBloc>().formKey,
                          child: Column(
                            children: [
                              ///Mail
                              CustomTextField(
                                controller:
                                    context.read<ForgetPasswordBloc>().mailTEC,
                                focusNode: context
                                    .read<ForgetPasswordBloc>()
                                    .emailNode,
                                label: getTranslated("mail"),
                                hint: getTranslated("enter_your_mail"),
                                inputType: TextInputType.emailAddress,
                                validate: Validations.mail,
                                pSvgIcon: SvgImages.mailIcon,
                              ),

                              ///Phone
                              // CustomTextField(
                              //   controller:
                              //       context.read<ForgetPasswordBloc>().phoneTEC,
                              //   autofillHints: const [
                              //     AutofillHints.telephoneNumber,
                              //     AutofillHints.username,
                              //   ],
                              //   label: getTranslated("phone"),
                              //   hint: getTranslated("enter_your_phone"),
                              //   inputType: TextInputType.phone,
                              //   validate: Validations.phone,
                              //   pSvgIcon: SvgImages.phoneCallIcon,
                              //   sufWidget: StreamBuilder<String?>(
                              //       stream: context
                              //           .read<ForgetPasswordBloc>()
                              //           .countryStream,
                              //       builder: (context, snapshot) {
                              //         return CountryListPick(
                              //             appBar: CustomAppBar(
                              //                 title: getTranslated(
                              //                     "select_your_country")),
                              //             pickerBuilder: (context,
                              //                 CountryCode? countryCode) {
                              //               return Row(
                              //                 mainAxisSize: MainAxisSize.min,
                              //                 mainAxisAlignment:
                              //                     MainAxisAlignment.end,
                              //                 children: [
                              //                   CountryFlag.fromCountryCode(
                              //                     snapshot.data ??
                              //                         countryCode?.code ??
                              //                         "",
                              //                     height: 18,
                              //                     width: 24,
                              //                     shape:
                              //                         const RoundedRectangle(5),
                              //                   ),
                              //                   SizedBox(width: 4.w),
                              //                   Text(
                              //                     CountryCodes.detailsForLocale(
                              //                           Locale.fromSubtags(
                              //                               countryCode:
                              //                                   snapshot.data ??
                              //                                       countryCode
                              //                                           ?.code ??
                              //                                       "SA"),
                              //                         ).dialCode ??
                              //                         "+966",
                              //                     overflow:
                              //                         TextOverflow.ellipsis,
                              //                     maxLines: 1,
                              //                     style: AppTextStyles.w400
                              //                         .copyWith(
                              //                             fontSize: 14,
                              //                             height: 1,
                              //                             color: Styles.HEADER),
                              //                   ),
                              //                 ],
                              //               );
                              //             },
                              //             theme: CountryTheme(
                              //               labelColor: Styles.ACCENT_COLOR,
                              //               alphabetSelectedBackgroundColor:
                              //                   Styles.ACCENT_COLOR,
                              //               isShowFlag: true,
                              //               isShowTitle: true,
                              //               isShowCode: false,
                              //               isDownIcon: true,
                              //               showEnglishName: true,
                              //             ),
                              //             initialSelection:
                              //                 snapshot.data ?? "+966",
                              //             onChanged: (CountryCode? code) {
                              //               context
                              //                   .read<ForgetPasswordBloc>()
                              //                   .updateCountry(code!.code);
                              //             },
                              //             useUiOverlay: true,
                              //             useSafeArea: false);
                              //       }),
                              // ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 24.h,
                                ),
                                child: CustomButton(
                                    text: getTranslated("submit"),
                                    onTap: () {
                                      if (context
                                          .read<ForgetPasswordBloc>()
                                          .formKey
                                          .currentState!
                                          .validate()) {
                                        context
                                            .read<ForgetPasswordBloc>()
                                            .add(Click(arguments: userType));
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
