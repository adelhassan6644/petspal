import 'package:zurex/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../app/core/app_event.dart';
import '../../../../../app/localization/language_constant.dart';
import '../../../../../data/config/di.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../components/animated_widget.dart';
import '../../../components/empty_widget.dart';
import '../../../data/internet_connection/internet_connection.dart';
import '../../../main_models/question_model.dart';
import '../bloc/faqs_bloc.dart';
import '../repo/faqs_repo.dart';
import '../../../main_widgets/question_card.dart';

class FaqsPage extends StatelessWidget {
  const FaqsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated("faqs")),
      body: BlocProvider(
        create: (context) => FaqsBloc(
            repo: sl<FaqsRepo>(), internetConnection: sl<InternetConnection>())
          ..add(Click()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
            Expanded(
              child: BlocBuilder<FaqsBloc, AppState>(
                builder: (context, state) {
                  if (state is Loading) {
                    return ListAnimator(
                      customPadding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                      data: List.generate(
                        8,
                        (i) => QuestionCardShimmer(),
                      ),
                    );
                  }
                  if (state is Done) {
                    List<QuestionModel> questions =
                        state.list as List<QuestionModel>;
                    return ListAnimator(
                      customPadding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                      data: List.generate(
                        questions.length,
                        (i) =>
                            QuestionCard(index: i + 1, question: questions[i]),
                      ),
                    );
                  }
                  if (state is Error || state is Empty) {
                    return RefreshIndicator(
                      color: Styles.PRIMARY_COLOR,
                      onRefresh: () async {
                        context.read<FaqsBloc>().add(Click());
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: ListAnimator(
                              customPadding: EdgeInsets.symmetric(
                                  vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
                              data: [
                                SizedBox(height: 50.h),
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
                    return SizedBox();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
