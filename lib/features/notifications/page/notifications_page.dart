import 'package:petspal/app/core/extensions.dart';
import 'package:petspal/features/notifications/model/notifications_model.dart';
import 'package:petspal/features/notifications/repo/notifications_repo.dart';
import 'package:petspal/features/notifications/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/images.dart';
import '../../../app/core/styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_app_bar.dart';
import '../../../components/custom_loading_text.dart';
import '../../../components/empty_widget.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../main_models/search_engine.dart';
import '../bloc/notifications_bloc.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late ScrollController controller;

  @override
  void initState() {
    controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated("notifications"),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => NotificationsBloc(repo: sl<NotificationsRepo>())
            ..customScroll(controller)
            ..add(Get(arguments: SearchEngine())),
          child: BlocBuilder<NotificationsBloc, AppState>(
            builder: (context, state) {
              if (state is Loading) {
                return Column(
                  children: [
                    Expanded(
                      child: ListAnimator(data: [
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
                        ...List.generate(
                          10,
                          (i) => Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                              vertical: Dimensions.paddingSizeMini.h,
                            ),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Styles.WHITE_COLOR, width: 1))),
                            child: CustomShimmerContainer(
                              height: 80.h,
                              width: context.width,
                              radius: 14,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ],
                );
              }
              if (state is Done) {
                List<NotificationModel> list =
                    state.list as List<NotificationModel>;
                return RefreshIndicator(
                  color: Styles.PRIMARY_COLOR,
                  onRefresh: () async {
                    context
                        .read<NotificationsBloc>()
                        .add(Get(arguments: SearchEngine()));
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: ListAnimator(controller: controller, data: [
                          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
                          ...List.generate(
                              list.length,
                              (i) => NotificationCard(
                                    notification: list[i],
                                    withBorder: i != (list.length - 1),
                                  )),
                        ]),
                      ),
                      CustomLoadingText(
                        loading: state.loading,
                      ),
                    ],
                  ),
                );
              }
              if (state is Empty || State is Error) {
                return RefreshIndicator(
                  color: Styles.PRIMARY_COLOR,
                  onRefresh: () async {
                    context
                        .read<NotificationsBloc>()
                        .add(Get(arguments: SearchEngine()));
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: ListAnimator(
                          customPadding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                          data: [
                            SizedBox(
                              height: 50.h,
                            ),
                            EmptyState(
                              img: Images.emptyNotifications,
                              imgHeight: 175.h,
                              imgWidth: 140.w,
                              txt: state is Error
                                  ? getTranslated("something_went_wrong")
                                  : getTranslated("no_notifications"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
