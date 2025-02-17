import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/app/core/app_state.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/app/core/svg_images.dart';
import 'package:zurex/components/custom_images.dart';
import 'package:zurex/main_blocs/user_bloc.dart';
import 'package:zurex/navigation/custom_navigation.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../data/config/di.dart';
import '../../../main_widgets/profile_image_widget.dart';
import '../../../navigation/routes.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, AppState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            if (sl<UserBloc>().isLogin) {
              CustomNavigator.push(Routes.editProfile);
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ProfileImageWidget(
                  withEdit: false,
                  image: UserBloc.instance.user?.profileImage ?? "",
                  radius: 35.w,
                ),
                SizedBox(height: 8.w),

                ///Name
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      UserBloc.instance.isLogin
                          ? UserBloc.instance.user?.name ?? ""
                          : "Guest",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.w900.copyWith(
                        color: Styles.HEADER,
                        height: 1,
                        fontSize: 16,
                      ),
                    ),
                    // Flexible(
                    //   child: Padding(
                    //     padding: EdgeInsets.symmetric(horizontal: 4.w),
                    //     child: CountryFlag.fromCountryCode(
                    //       UserBloc.instance.user?.countryCode ?? "SA",
                    //       height: 14,
                    //       width: 24,
                    //       shape: const RoundedRectangle(2),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(width: 12.w),
                    if (sl<UserBloc>().isLogin)
                      customImageIconSVG(
                          imageName: SvgImages.edit,
                          width: 16.w,
                          height: 16.h,
                          onTap: () => CustomNavigator.push(Routes.editProfile))
                  ],
                ),
                SizedBox(height: 8.h),

                ///Phone
                if (sl<UserBloc>().isLogin)
                  Text(
                    "+966${UserBloc.instance.isLogin ? UserBloc.instance.user?.phone ?? "" : "00000000"}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.w400.copyWith(
                      color: Styles.TITLE,
                      height: 1,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
