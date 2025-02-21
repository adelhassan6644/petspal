import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/components/custom_app_bar.dart';
import 'package:petspal/features/auth/verification/bloc/verification_bloc.dart';
import 'package:petspal/features/auth/verification/model/verification_model.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/dimensions.dart';
import '../../../../app/core/images.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/animated_widget.dart';
import '../../../../components/back_icon.dart';
import '../../../../components/count_down.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_pin_code_field.dart';
import '../../../../data/config/di.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';
import '../repo/verification_repo.dart';
import '../widgets/verification_header.dart';

class Verification extends StatelessWidget {
  const Verification({super.key, required this.model});
  final VerificationModel model;

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
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: ListAnimator(
                            customPadding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                                vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
                            data: [
                              VerificationHeader(email: model.email ?? ""),
                              Form(
                                  key: context.read<VerificationBloc>().formKey,
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
                                            .add(Resend(arguments: model)),
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
                                if (context
                                    .read<VerificationBloc>()
                                    .formKey
                                    .currentState!
                                    .validate()) {
                                  CustomNavigator.push(Routes.resetPassword,
                                      arguments: model);
                                  // context
                                  //     .read<VerificationBloc>()
                                  //     .add(Click(arguments: model));
                                }
                              },
                              isLoading: state is Loading),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                          vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FilteredBackIcon(),
                        ],
                      ),
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
