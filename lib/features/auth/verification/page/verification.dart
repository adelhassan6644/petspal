import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/features/auth/verification/bloc/verification_bloc.dart';
import 'package:petspal/features/auth/verification/model/verification_model.dart';

import '../../../../app/core/app_event.dart';
import '../../../../app/core/dimensions.dart';
import '../../../../app/core/images.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/animated_widget.dart';
import '../../../../components/count_down.dart';
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
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(Images.authBG),
              )),
              child: SafeArea(
                child: Column(
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
                                    vertical:
                                        Dimensions.PADDING_SIZE_DEFAULT.h),
                                child: customImageIcon(
                                    imageName: Images.authLogo,
                                    width: 230.w,
                                    height: 130.h)),
                          ),
                          Text(
                            getTranslated("verify_header"),
                            style: AppTextStyles.w700.copyWith(
                              fontSize: 24,
                              color: Styles.HEADER,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: Text(
                              getTranslated("verify_title"),
                              style: AppTextStyles.w600
                                  .copyWith(fontSize: 20, color: Styles.TITLE),
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                                text: getTranslated("verify_description"),
                                style: AppTextStyles.w500.copyWith(
                                    fontSize: 16, color: Styles.SUBTITLE),
                                children: [
                                  TextSpan(
                                    text: " ${widget.model.email} ",
                                    style: AppTextStyles.w500.copyWith(
                                      fontSize: 16,
                                      color: Styles.SUBTITLE,
                                    ),
                                  ),
                                ]),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 6.h),
                                    child: Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: CustomPinCodeField(
                                            validation: Validations.code,
                                            controller: context
                                                .read<VerificationBloc>()
                                                .codeTEC)),
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

                    ///Action
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                        vertical: Dimensions.paddingSizeMini.h,
                      ),
                      child: CustomButton(
                          text: getTranslated("verify"),
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<VerificationBloc>()
                                  .add(Click(arguments: widget.model));
                            }
                          },
                          isLoading: state is Loading),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
