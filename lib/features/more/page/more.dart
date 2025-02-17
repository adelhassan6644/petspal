import 'dart:io';

import 'package:share_plus/share_plus.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/app/localization/language_constant.dart';
import 'package:petspal/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/components/animated_widget.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/svg_images.dart';
import '../../../components/custom_simple_dialog.dart';
import '../../../data/config/di.dart';
import '../../../main_blocs/user_bloc.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';
import '../../auth/deactivate_account/view/deactivate_account.dart';
import '../../auth/logout/view/logout_button.dart';
import '../../language/bloc/language_bloc.dart';
import '../../language/page/language_button.dart';
import '../../notifications/bloc/turn_notification_bloc.dart';
import '../../notifications/repo/notifications_repo.dart';
import '../../profile/bloc/profile_bloc.dart';
import '../widgets/more_button.dart';
import '../widgets/more_card.dart';
import '../widgets/profile_card.dart';

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  void initState() {
    ///To Update Balance
    if (sl<ProfileBloc>().isLogin) {
      sl<ProfileBloc>().add(Get());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LanguageBloc, AppState>(
        builder: (context, state) {
          return Stack(
            children: [
              CustomAppBar(withBack: false),
              SafeArea(
                child: Column(
                  children: [
                    ///Profile Card
                    Padding(
                      padding: EdgeInsets.only(
                          top: Dimensions.PADDING_SIZE_EXTRA_LARGE.h),
                      child: const ProfileCard(),
                    ),

                    ///Body
                    Expanded(
                      child: BlocBuilder<UserBloc, AppState>(
                        builder: (context, state) {
                          return ListAnimator(
                            data: [

                              if (UserBloc.instance.isLogin)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                                  vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: MoreCard(
                                      title: getTranslated("cash_back",
                                          context: context),
                                      subTitle: getTranslated("balance",
                                          context: context),
                                      value:
                                          "${sl<UserBloc>().user?.balance ?? 0} ${getTranslated("sar", context: context)}",
                                      icon: SvgImages.money,
                                      color: Styles.GREEN,
                                      onTap: () => CustomNavigator.push(
                                          Routes.transactions),
                                    )),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                        child: MoreCard(
                                      title: getTranslated("support_services",
                                          context: context),
                                      subTitle: getTranslated("request",
                                          context: context),
                                      value:
                                          "${sl<UserBloc>().user?.balance ?? 0}",
                                      icon: SvgImages.request,
                                      color: Color(0xFF00A7AD),
                                      onTap: () {},
                                    )),
                                  ],
                                ),
                              ),

                              ///Notification && Turn Notification
                              if (UserBloc.instance.isLogin)
                              BlocProvider(
                                create: (context) => TurnNotificationsBloc(
                                    repo: sl<NotificationsRepo>()),
                                child: BlocBuilder<TurnNotificationsBloc,
                                    AppState>(
                                  builder: (context, state) {
                                    return MoreButton(
                                      title: getTranslated("notifications",
                                          context: context),
                                      icon: SvgImages.notification,
                                      action: SizedBox(
                                        height: 10,
                                        child: Switch(
                                          value: context
                                              .read<TurnNotificationsBloc>()
                                              .isTurnOn,
                                          inactiveThumbColor:
                                              Styles.WHITE_COLOR,
                                          inactiveTrackColor:
                                              Styles.BORDER_COLOR,
                                          onChanged: (v) {
                                            context
                                                .read<TurnNotificationsBloc>()
                                                .add(Turn());
                                          },
                                          trackOutlineColor: WidgetStateProperty
                                              .resolveWith<Color?>(
                                                  (Set<WidgetState> states) {
                                            return context
                                                    .read<
                                                        TurnNotificationsBloc>()
                                                    .isTurnOn
                                                ? Styles.PRIMARY_COLOR
                                                : Styles.BORDER_COLOR;
                                          }),
                                          trackOutlineWidth: WidgetStateProperty
                                              .resolveWith<double?>(
                                                  (Set<WidgetState> states) {
                                            return 1.0;
                                          }),
                                        ),
                                      ),
                                      onTap: () => CustomNavigator.push(
                                          Routes.notifications),
                                    );
                                  },
                                ),
                              ),

                              ///Language
                              const LanguageButton(),



                              ///Contact With Us
                              MoreButton(
                                title: getTranslated("contact_with_us",
                                    context: context),
                                icon: SvgImages.contactWithUs,
                                onTap: () =>
                                    CustomNavigator.push(Routes.contactWithUs),
                              ),

                              ///Terms && Conditions
                              MoreButton(
                                title: getTranslated("terms_conditions",
                                    context: context),
                                icon: SvgImages.terms,
                                onTap: () => CustomNavigator.push(Routes.terms),
                              ),

                              ///Privacy && Policy
                              MoreButton(
                                title: getTranslated("privacy_policy",
                                    context: context),
                                icon: SvgImages.lockIcon,
                                onTap: () =>
                                    CustomNavigator.push(Routes.privacy),
                              ),

                              ///FAQS
                              MoreButton(
                                title: getTranslated("faqs", context: context),
                                icon: SvgImages.faqs,
                                onTap: () => CustomNavigator.push(Routes.faqs),
                              ),

                              // ///Tips && Articles
                              // MoreButton(
                              //   title: getTranslated("tips_and_articles",
                              //       context: context),
                              //   icon: SvgImages.tips,
                              //   onTap: () => CustomNavigator.push(Routes.tips),
                              // ),

                              ///Share
                              MoreButton(
                                title: getTranslated("share", context: context),
                                icon: SvgImages.share,
                                iconColor: Styles.GREEN,
                                withBottomBorder: UserBloc.instance.isLogin,
                                onTap: () => Share.share(Platform.isIOS
                                    ? "https://apps.apple.com/eg/app/blue-art/id6670496496"
                                    : "PetsPal"),
                              ),

                              ///Delete Account
                              if (UserBloc.instance.isLogin)
                                MoreButton(
                                    title: getTranslated("deactivate_account",
                                        context: context),
                                    icon: SvgImages.trash,
                                    iconColor: Styles.ERORR_COLOR,
                                    withBottomBorder: false,
                                    onTap: () =>
                                        CustomSimpleDialog.parentSimpleDialog(
                                          canDismiss: false,
                                          withContentPadding: false,
                                          customWidget: DeactivateAccount(),
                                        )),

                              const LogOutButton(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
