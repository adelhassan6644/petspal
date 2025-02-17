import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/app/core/styles.dart';
import 'package:zurex/app/localization/language_constant.dart';
import 'package:zurex/components/custom_app_bar.dart';
import 'package:zurex/components/shimmer/custom_shimmer.dart';
import 'package:zurex/features/chats/bloc/chats_bloc.dart';
import 'package:zurex/main_models/search_engine.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_loading_text.dart';
import '../../../components/empty_widget.dart';
import '../../../data/config/di.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats>
    with AutomaticKeepAliveClientMixin<Chats> {
  late ScrollController controller;

  @override
  void initState() {
    sl<ChatsBloc>().add(Click(arguments: SearchEngine()));
    controller = ScrollController();
    controller.addListener(() {
      sl<ChatsBloc>().customScroll(controller);
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated("messages"),
        withBack: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatsBloc, AppState>(
              builder: (context, state) {
                if (state is Loading) {
                  return ListAnimator(
                    customPadding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                    data: List.generate(
                        8, (index) => const _LoadingShimmerWidget()),
                  );
                }
                if (state is Done) {
                  return RefreshIndicator(
                    color: Styles.PRIMARY_COLOR,
                    onRefresh: () async {
                      sl<ChatsBloc>().add(Click(arguments: SearchEngine()));
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: ListAnimator(
                            controller: controller,
                            customPadding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                            data: state.cards,
                          ),
                        ),
                        CustomLoadingText(
                          loading: state.loading,
                        ),
                      ],
                    ),
                  );
                }
                if (state is Error || state is Empty) {
                  return RefreshIndicator(
                    color: Styles.PRIMARY_COLOR,
                    onRefresh: () async {
                      sl<ChatsBloc>().add(Click(arguments: SearchEngine()));
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: ListAnimator(
                            customPadding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                              vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                            ),
                            data: [
                              SizedBox(
                                height: 50.h,
                              ),
                              EmptyState(
                                txt: state is Error
                                    ? getTranslated("something_went_wrong")
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _LoadingShimmerWidget extends StatelessWidget {
  const _LoadingShimmerWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.PADDING_SIZE_DEFAULT.w,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
      ),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Styles.BORDER_COLOR))),
      child: Row(
        children: [
          CustomShimmerCircleImage(
            diameter: 50.w,
          ),
          SizedBox(width: 12.w),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomShimmerContainer(
                width: 100.w,
                height: 18,
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  CustomShimmerContainer(
                    width: 120.w,
                    height: 14,
                  ),
                  SizedBox(width: 16.h),
                  CustomShimmerContainer(
                    width: 80.w,
                    height: 14,
                  ),
                ],
              ),
            ],
          ))
        ],
      ),
    );
  }
}
