import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/app/core/dimensions.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/animated_widget.dart';
import '../../../../components/custom_app_bar.dart';
import '../../../../components/custom_button.dart';
import '../../../../data/config/di.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/images.dart';
import '../bloc/change_password_bloc.dart';
import '../repo/change_password_repo.dart';
import '../widgets/change_password_body.dart';
import '../widgets/change_password_header.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePasswordBloc(repo: sl<ChangePasswordRepo>()),
      child: BlocBuilder<ChangePasswordBloc, AppState>(
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
                          ///Header
                          ChangePasswordHeader(),

                          ///Body
                          ChangePasswordBody(),

                          ///Confirm
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
                            child: CustomButton(
                                text: getTranslated("confirm_password"),
                                onTap: () {
                                  context
                                      .read<ChangePasswordBloc>()
                                      .formKey
                                      .currentState!
                                      .validate();
                                  if (context
                                      .read<ChangePasswordBloc>()
                                      .isBodyValid()) {
                                    context.read<ChangePasswordBloc>().add(Click());
                                  }
                                },
                                isLoading: state is Loading),
                          ),
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
