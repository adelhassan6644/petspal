import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/features/auth/reset_password/bloc/reset_password_bloc.dart';
import 'package:petspal/features/auth/reset_password/repo/reset_password_repo.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/images.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/animated_widget.dart';
import '../../../../components/back_icon.dart';
import '../../../../components/custom_button.dart';
import '../../../../data/config/di.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';
import '../../verification/model/verification_model.dart';
import '../widgets/reset_password_body.dart';
import '../widgets/reset_password_header.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key, required this.data});
  final VerificationModel data;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordBloc(repo: sl<ResetPasswordRepo>()),
      child: BlocBuilder<ResetPasswordBloc, AppState>(
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
                              ///Header
                              ResetPasswordHeader(),

                              ///Body
                              ResetPasswordBody(),

                              ///Confirm
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        Dimensions.PADDING_SIZE_DEFAULT.h),
                                child: CustomButton(
                                    text: getTranslated("confirm_password"),
                                    onTap: () {
                                      context
                                          .read<ResetPasswordBloc>()
                                          .formKey
                                          .currentState!
                                          .validate();
                                      if (context
                                          .read<ResetPasswordBloc>()
                                          .isBodyValid()) {
                                        CustomNavigator.push(Routes.login,
                                            clean: true);
                                      }
                                      // context
                                      //     .read<ResetPasswordBloc>()
                                      //     .add(Click(
                                      //         arguments: data));
                                    },
                                    isLoading: state is Loading),
                              ),
                            ],
                          ),
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
