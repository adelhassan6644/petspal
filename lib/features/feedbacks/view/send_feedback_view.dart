import 'package:zurex/app/core/app_state.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/app/core/validation.dart';
import 'package:zurex/components/animated_widget.dart';
import 'package:zurex/components/custom_button.dart';
import 'package:zurex/features/feedbacks/bloc/send_feedback_bloc.dart';
import 'package:zurex/features/feedbacks/repo/feedbacks_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/svg_images.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_images.dart';
import '../../../components/custom_text_form_field.dart';
import '../../../data/config/di.dart';
import '../../../navigation/custom_navigation.dart';

class SendFeedbackView extends StatelessWidget {
  const SendFeedbackView({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: BlocProvider(
        create: (context) => SendFeedbacksBloc(repo: sl<FeedbacksRepo>()),
        child: BlocBuilder<SendFeedbacksBloc, AppState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
              child: Form(
                key: context.read<SendFeedbacksBloc>().formKey,
                child: Column(
                  children: [
                    Container(
                      width: 60.w,
                      height: 4.h,
                      margin: EdgeInsets.only(
                        left: Dimensions.PADDING_SIZE_DEFAULT.w,
                        right: Dimensions.PADDING_SIZE_DEFAULT.w,
                        top: Dimensions.paddingSizeMini.h,
                        bottom: Dimensions.PADDING_SIZE_DEFAULT.h,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Styles.HINT_COLOR,
                          borderRadius: BorderRadius.circular(100)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getTranslated("give_us_your_feedback"),
                          style: AppTextStyles.w500.copyWith(
                            fontSize: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => CustomNavigator.pop(),
                          child: const Icon(
                            Icons.clear,
                            size: 24,
                            color: Styles.DISABLED,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: const Divider(
                        color: Styles.BORDER_COLOR,
                      ),
                    ),
                    Expanded(
                        child: ListAnimator(
                      data: [
                        ///Rate Count
                        StreamBuilder<int?>(
                            stream:
                                context.read<SendFeedbacksBloc>().rattingStream,
                            builder: (context, snapshot) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  5,
                                  (index) => Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4.w),
                                    child: GestureDetector(
                                      onTap: () => context
                                          .read<SendFeedbacksBloc>()
                                          .updateRatting((index)),
                                      child: customImageIconSVG(
                                        height: 35,
                                        width: 35,
                                        imageName: (snapshot.data ?? -1) < index
                                            ? SvgImages.emptyStar
                                            : SvgImages.fillStar,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),

                        ///Feedback
                        CustomTextField(
                          controller:
                              context.read<SendFeedbacksBloc>().feedbackTEC,
                          label: getTranslated("feedback"),
                          hint: getTranslated("enter_your_feedback"),
                          maxLines: 5,
                          minLines: 5,
                          inputType: TextInputType.text,
                          validate: Validations.feedBack,
                        ),
                      ],
                    )),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_SMALL.h),
                      child: CustomButton(
                        text: getTranslated("submit"),
                        isLoading: state is Loading,
                        onTap: () {
                          if (context
                              .read<SendFeedbacksBloc>()
                              .formKey
                              .currentState!
                              .validate()) {
                            context
                                .read<SendFeedbacksBloc>()
                                .add(Click(arguments: data));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
