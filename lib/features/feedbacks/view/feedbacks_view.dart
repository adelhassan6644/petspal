import 'package:zurex/app/core/app_state.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/components/animated_widget.dart';
import 'package:zurex/features/feedbacks/bloc/feedbacks_bloc.dart';
import 'package:zurex/features/feedbacks/view/send_feedback_view.dart';
import 'package:zurex/features/feedbacks/widgets/feedback_card.dart';
import 'package:zurex/main_models/search_engine.dart';
import 'package:zurex/navigation/custom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_bottom_sheet.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_loading_text.dart';
import '../../../components/empty_widget.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../navigation/routes.dart';
import '../model/feedback_model.dart';

class FeedbacksView extends StatelessWidget {
  const FeedbacksView(
      {super.key,
      required this.id,
      this.canRate = true,
      this.showRateButton = true});

  final int id;
  final bool canRate;
  final bool showRateButton;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbacksBloc, AppState>(
      builder: (context, state) {
        if (state is Done) {
          List<FeedbackModel> items = (state.data ?? [] as List<FeedbackModel>);
          return RefreshIndicator(
            color: Styles.PRIMARY_COLOR,
            onRefresh: () async {
              context
                  .read<FeedbacksBloc>()
                  .add(Click(arguments: SearchEngine(id: "$id")));
            },
            child: Column(
              children: [
                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
                Expanded(
                  child: ListAnimator(
                      controller: context.read<FeedbacksBloc>().controller,
                      customPadding: EdgeInsets.symmetric(
                        vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                      ),
                      data: List.generate(
                          items.length, (i) => FeedbackCard(item: items[i]))),
                ),
                CustomLoadingText(
                  loading: state.loading,
                ),

                ///Send Feedback
                if (showRateButton)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                      vertical: Dimensions.PADDING_SIZE_SMALL.h,
                    ),
                    child: CustomButton(
                        text: getTranslated(
                            !context.read<FeedbacksBloc>().repo.isLogin
                                ? "login_to_add_feedback"
                                : canRate
                                    ? "give_us_your_feedback"
                                    : "cant_add_feedback"),
                        backgroundColor: canRate
                            ? Styles.PRIMARY_COLOR
                            : Styles.PRIMARY_COLOR.withOpacity(0.1),
                        textColor:
                            canRate ? Styles.WHITE_COLOR : Styles.PRIMARY_COLOR,
                        onTap: () {
                          if (context.read<FeedbacksBloc>().repo.isLogin) {
                            if (canRate) {
                              CustomBottomSheet.general(
                                  widget: SendFeedbackView(
                                data: {
                                  "id": id,
                                  "onSuccess": (v) => context
                                      .read<FeedbacksBloc>()
                                      .add(
                                          Update(arguments: v as FeedbackModel))
                                },
                              ));
                            }
                          } else {
                            CustomNavigator.push(Routes.login, clean: true);
                          }
                        }),
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
          return Column(
            children: [
              Expanded(
                child: ListAnimator(
                  customPadding: EdgeInsets.symmetric(
                    vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                    horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                  ),
                  data: [
                    SizedBox(height: 100.h),
                    EmptyState(
                      txt: getTranslated("there_is_no_feedbacks"),
                      subText: getTranslated("give_us_your_feedback"),
                    ),
                  ],
                ),
              ),

              ///Send Feedback
              if (showRateButton)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                    vertical: Dimensions.PADDING_SIZE_SMALL.h,
                  ),
                  child: CustomButton(
                      text: getTranslated(
                          !context.read<FeedbacksBloc>().repo.isLogin
                              ? "login_to_add_feedback"
                              : canRate
                                  ? "give_us_your_feedback"
                                  : "cant_add_feedback"),
                      backgroundColor: canRate
                          ? Styles.PRIMARY_COLOR
                          : Styles.PRIMARY_COLOR.withOpacity(0.1),
                      textColor:
                          canRate ? Styles.WHITE_COLOR : Styles.PRIMARY_COLOR,
                      onTap: () {
                        if (context.read<FeedbacksBloc>().repo.isLogin) {
                          if (canRate) {
                            CustomBottomSheet.general(
                                widget: SendFeedbackView(
                              data: {
                                "id": id,
                                "onSuccess": (v) => context
                                    .read<FeedbacksBloc>()
                                    .add(Update(arguments: v as FeedbackModel))
                              },
                            ));
                          }
                        } else {
                          CustomNavigator.push(Routes.login, clean: true);
                        }
                      }),
                ),
            ],
          );
        }
        if (state is Error) {
          return RefreshIndicator(
            color: Styles.PRIMARY_COLOR,
            onRefresh: () async {
              context
                  .read<FeedbacksBloc>()
                  .add(Click(arguments: SearchEngine(id: "$id")));
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
                      SizedBox(height: 100.h),
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
    );
  }
}
