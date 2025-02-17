import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/components/animated_widget.dart';
import 'package:petspal/components/custom_app_bar.dart';
import 'package:petspal/features/feedbacks/bloc/feedbacks_bloc.dart';
import 'package:petspal/features/feedbacks/widgets/feedback_card.dart';
import 'package:petspal/main_models/search_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_loading_text.dart';
import '../../../components/empty_widget.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../model/feedback_model.dart';
import '../repo/feedbacks_repo.dart';

class MyFeedbacksPage extends StatelessWidget {
  const MyFeedbacksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated("my_feedbacks"),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => FeedbacksBloc(repo: sl<FeedbacksRepo>())
            ..add(
                Click(arguments: SearchEngine(id: sl<FeedbacksRepo>().userId))),
          child: BlocBuilder<FeedbacksBloc, AppState>(
            builder: (context, state) {
              if (state is Done) {
                List<FeedbackModel> items =
                    (state.data ?? [] as List<FeedbackModel>);
                return RefreshIndicator(
                  color: Styles.PRIMARY_COLOR,
                  onRefresh: () async {
                    context.read<FeedbacksBloc>().add(Click(
                        arguments:
                            SearchEngine(id: sl<FeedbacksRepo>().userId)));
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: ListAnimator(
                            controller:
                                context.read<FeedbacksBloc>().controller,
                            customPadding: EdgeInsets.symmetric(
                              vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                              horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                            ),
                            data: [
                              SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT.h),
                              ...List.generate(items.length,
                                  (i) => FeedbackCard(item: items[i]))
                            ]),
                      ),
                      CustomLoadingText(
                        loading: state.loading,
                      ),
                    ],
                  ),
                );
              }
              if (state is Loading) {
                return ListAnimator(
                    customPadding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                    data: [
                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
                      ...List.generate(
                          10,
                          (i) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 6.h),
                                child: CustomShimmerContainer(
                                  height: 80.h,
                                  radius: 12,
                                ),
                              )),
                    ]);
              }
              if (state is Empty) {
                return RefreshIndicator(
                  color: Styles.PRIMARY_COLOR,
                  onRefresh: () async {
                    context.read<FeedbacksBloc>().add(Click(
                        arguments:
                            SearchEngine(id: sl<FeedbacksRepo>().userId)));
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: ListAnimator(
                          customPadding: EdgeInsets.symmetric(
                            vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                          ),
                          data: [
                            SizedBox(
                              height: 50.h,
                            ),
                            EmptyState(
                              txt: getTranslated("there_is_no_feedbacks"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (state is Error) {
                return RefreshIndicator(
                  color: Styles.PRIMARY_COLOR,
                  onRefresh: () async {
                    context.read<FeedbacksBloc>().add(Click(
                        arguments:
                            SearchEngine(id: sl<FeedbacksRepo>().userId)));
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: ListAnimator(
                          customPadding: EdgeInsets.symmetric(
                            vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                          ),
                          data: [
                            SizedBox(
                              height: 50.h,
                            ),
                            EmptyState(
                              txt: getTranslated("no_result_found"),
                              subText: getTranslated("something_went_wrong"),
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
        ),
      ),
    );
  }
}
