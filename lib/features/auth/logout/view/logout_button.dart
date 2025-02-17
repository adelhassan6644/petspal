import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zurex/app/core/app_state.dart';
import 'package:zurex/navigation/custom_navigation.dart';
import 'package:zurex/navigation/routes.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/dimensions.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/svg_images.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_images.dart';
import '../../../../data/config/di.dart';
import '../bloc/logout_bloc.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogoutBloc, AppState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            if (sl<LogoutBloc>().isLogin) {
              sl<LogoutBloc>().add(Click());
            } else {
              CustomNavigator.push(Routes.login);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.PADDING_SIZE_SMALL.h,
                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
            margin: EdgeInsets.symmetric(
                vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.w),
              color: (sl<LogoutBloc>().isLogin
                      ? Styles.ERORR_COLOR
                      : Styles.ACTIVE)
                  .withOpacity(0.1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customImageIconSVG(
                    imageName: sl<LogoutBloc>().isLogin
                        ? SvgImages.logout
                        : SvgImages.login,
                    height: 25.w,
                    width: 25.w,
                    color: sl<LogoutBloc>().isLogin
                        ? Styles.ERORR_COLOR
                        : Styles.ACTIVE),
                SizedBox(width: 12.w),
                state is Loading
                    ? const SpinKitThreeBounce(
                        color: Styles.ERORR_COLOR, size: 25)
                    : Flexible(
                        child: Text(
                            getTranslated(
                                sl<LogoutBloc>().isLogin ? "logout" : "login",
                                context: context),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.w500.copyWith(
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis,
                                color: sl<LogoutBloc>().isLogin
                                    ? Styles.ERORR_COLOR
                                    : Styles.ACTIVE)),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
