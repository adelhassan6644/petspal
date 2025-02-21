import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/dimensions.dart';
import '../../../../app/core/images.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/animated_widget.dart';
import '../../../../data/config/di.dart';
import '../bloc/login_bloc.dart';
import '../repo/login_repo.dart';
import '../widgets/login_body.dart';
import '../widgets/login_header.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(repo: sl<LoginRepo>())..add(Remember()),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(Images.authBG),
          )),
          child: SafeArea(
            child: Column(
              children: [
                ///Body
                Expanded(
                  child: ListAnimator(
                    customPadding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                    data: [
                      LoginHeader(),
                      LoginBody(),
                    ],
                  ),
                ),

                ///Guest Mode
                GestureDetector(
                  onTap: () => context.read<LoginBloc>().add(Add()),
                  child: Text(
                    getTranslated("continue_as_a_guest"),
                    style: AppTextStyles.w600
                        .copyWith(fontSize: 14, color: Styles.PRIMARY_COLOR),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
