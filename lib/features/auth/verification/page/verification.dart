import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/app/core/app_state.dart';
import 'package:zurex/features/auth/verification/bloc/verification_bloc.dart';
import 'package:zurex/features/auth/verification/model/verification_model.dart';

import '../../../../app/core/app_event.dart';
import '../../../../app/core/dimensions.dart';
import '../../../../app/core/images.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/animated_widget.dart';
import '../../../../components/count_down.dart';
import '../../../../components/custom_app_bar.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_images.dart';
import '../../../../components/custom_pin_code_field.dart';
import '../../../../data/config/di.dart';
import '../repo/verification_repo.dart';

class Verification extends StatefulWidget {
  const Verification({super.key, required this.model});
  final VerificationModel model;

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerificationBloc(repo: sl<VerificationRepo>()),
      child: BlocBuilder<VerificationBloc, AppState>(
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
                                imageName: Images.logo,
                                width: 220.w,
                                height: 70.h)),
                      ),
                      Text(
                        getTranslated(widget.model.withMail
                            ? "verify_mail"
                            : "verify_phone"),
                        style: AppTextStyles.w600.copyWith(
                          fontSize: 24,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeExtraSmall.h),
                        child: RichText(
                          text: TextSpan(
                              text: getTranslated("we_sent"),
                              style: AppTextStyles.w400.copyWith(
                                  fontSize: 14, color: Styles.DETAILS_COLOR),
                              children: [
                                TextSpan(
                                  text:
                                      " ${widget.model.withMail ? widget.model.email : widget.model.phone} ",
                                  style: AppTextStyles.w500.copyWith(
                                    fontSize: 14,
                                    color: Styles.DETAILS_COLOR,
                                  ),
                                ),
                                TextSpan(
                                  text: getTranslated("enter_it_below"),
                                  style: AppTextStyles.w500.copyWith(
                                      fontSize: 14,
                                      color: Styles.DETAILS_COLOR),
                                ),
                              ]),
                        ),
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(
                                  height:
                                      Dimensions.PADDING_SIZE_EXTRA_LARGE.h),
                              Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: CustomPinCodeField(
                                      validation: Validations.code,
                                      controller: context
                                          .read<VerificationBloc>()
                                          .codeTEC)),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                                ),
                                child: CustomButton(
                                    text: getTranslated("submit"),
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<VerificationBloc>().add(
                                            Click(arguments: widget.model));
                                      }
                                    },
                                    isLoading: state is Loading),
                              ),
                              CountDown(
                                onCount: () => context
                                    .read<VerificationBloc>()
                                    .add(Resend(arguments: widget.model)),
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
