import 'package:petspal/app/core/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:readmore/readmore.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/images.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_images.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';
import '../bloc/notifications_bloc.dart';
import '../model/notifications_model.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    this.notification,
    this.withBorder = true,
  });

  final NotificationModel? notification;
  final bool withBorder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsBloc, AppState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
            vertical: Dimensions.paddingSizeMini.h,
          ),
          child: Slidable(
            key: ValueKey(notification?.id),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.3,
              children: [
                SlidableAction(
                  onPressed: (context) => context
                      .read<NotificationsBloc>()
                      .add(Delete(arguments: notification?.id)),
                  backgroundColor: Styles.RED_COLOR,
                  foregroundColor: Colors.white,
                  label: getTranslated("delete"),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                if (notification?.keyId != null &&
                    notification?.key == "order") {
                } else if (notification?.key == "transaction") {
                  CustomNavigator.push(Routes.transactions);
                } else if (notification?.key == "feedback") {
                  CustomNavigator.push(Routes.myFeedbacks);
                }

                if (notification?.isRead != true) {
                  context
                      .read<NotificationsBloc>()
                      .add(Read(arguments: notification?.id ?? ""));
                }
              },
              child: Container(
                width: context.width,
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                    vertical: Dimensions.PADDING_SIZE_SMALL.h),
                decoration: BoxDecoration(
                    color: notification?.isRead == true
                        ? Styles.WHITE_COLOR
                        : Styles.PRIMARY_COLOR.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Styles.LIGHT_BORDER_COLOR)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    customContainerImage(
                      backGroundColor: notification?.isRead != true
                          ? Styles.WHITE_COLOR
                          : Styles.PRIMARY_COLOR.withOpacity(0.1),
                      imageName: Images.appLogo,
                      radius: 100,
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            notification?.title ?? "Notification Title",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.w500
                                .copyWith(fontSize: 14, color: Styles.HEADER),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: ReadMoreText(
                              notification?.body ?? "Notification Message",
                              style: AppTextStyles.w500
                                  .copyWith(fontSize: 12, color: Styles.TITLE),
                              trimLines: 2,
                              colorClickableText: Colors.pink,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: getTranslated("show_more"),
                              trimExpandedText: getTranslated("show_less"),
                              textAlign: TextAlign.start,
                              moreStyle: AppTextStyles.w600.copyWith(
                                  fontSize: 14, color: Styles.PRIMARY_COLOR),
                              lessStyle: AppTextStyles.w600.copyWith(
                                  fontSize: 14, color: Styles.PRIMARY_COLOR),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  notification?.createdTime ?? "since 4 h",
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: AppTextStyles.w400.copyWith(
                                      fontSize: 12,
                                      color: Styles.DETAILS_COLOR),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  " - ${notification?.createdAt ?? "12-8-2024"}",
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: AppTextStyles.w400.copyWith(
                                      fontSize: 12,
                                      color: Styles.DETAILS_COLOR),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
