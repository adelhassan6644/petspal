import 'package:petspal/app/core/extensions.dart';
import 'package:petspal/components/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/app/core/styles.dart';
import 'package:petspal/app/core/svg_images.dart';
import 'package:petspal/app/localization/language_constant.dart';
import 'package:petspal/components/custom_images.dart';
import 'package:petspal/components/shimmer/custom_shimmer.dart';
import 'package:petspal/features/maps/bloc/map_bloc.dart';
import 'package:petspal/features/maps/repo/maps_repo.dart';
import 'package:petspal/main_blocs/user_bloc.dart';
import 'package:petspal/navigation/custom_navigation.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/text_styles.dart';
import '../../../data/config/di.dart';
import '../../../main_widgets/guest_mode.dart';
import '../../../main_widgets/profile_image_widget.dart';
import '../../../navigation/routes.dart';
import '../../maps/models/location_model.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, AppState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
            vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///Profile Image Widget
              ProfileImageWidget(
                withEdit: false,
                radius: 30.w,
                image: UserBloc.instance.user?.profileImage ?? "",
              ),
              SizedBox(width: 12.w),
              Expanded(
                  child: InkWell(
                onTap: () {
                  if (UserBloc.instance.isLogin) {
                    CustomNavigator.push(Routes.editProfile);
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///Guest
                    Text(
                      "${getTranslated(DateTime.now().dateFormat(format: "a") == "AM" ? "good_morning" : "good_night", context: context)}, ${UserBloc.instance.user?.name ?? "Guest"}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.w600
                          .copyWith(fontSize: 18, color: Styles.HEADER),
                    ),

                    ///Current Location
                    BlocProvider(
                      create: (context) =>
                          MapBloc(repo: sl<MapsRepo>())..add(Init()),
                      child: BlocBuilder<MapBloc, AppState>(
                        builder: (context, state) {
                          if (state is Done) {
                            LocationModel model = state.model as LocationModel;
                            return Row(
                              children: [
                                customImageIconSVG(
                                    width: 20,
                                    height: 20,
                                    color: Styles.DETAILS_COLOR,
                                    imageName: SvgImages.location),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    model.address ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.w400.copyWith(
                                        fontSize: 14,
                                        color: Styles.DETAILS_COLOR),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Row(
                              children: [
                                customImageIconSVG(
                                    width: 20,
                                    height: 20,
                                    color: Styles.PRIMARY_COLOR,
                                    imageName: SvgImages.location),
                                SizedBox(width: 8.w),
                                CustomShimmerText(width: 120.w),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )),
              SizedBox(width: 12.w),
              customImageIconSVG(
                  onTap: () {
                    if (UserBloc.instance.isLogin) {
                      CustomNavigator.push(Routes.notifications);
                    } else {
                      CustomBottomSheet.show(widget: const GuestMode());
                    }
                  },
                  width: 20,
                  height: 20,
                  color: Styles.PRIMARY_COLOR,
                  imageName: SvgImages.notification),
            ],
          ),
        );
      },
    );
  }
}
