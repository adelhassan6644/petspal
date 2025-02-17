import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/app/core/app_state.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/app/localization/language_constant.dart';
import 'package:zurex/components/animated_widget.dart';
import 'package:zurex/components/custom_app_bar.dart';
import 'package:zurex/components/custom_button.dart';
import '../../../app/core/app_event.dart';
import '../../../data/config/di.dart';
import '../bloc/contact_with_us_bloc.dart';
import '../repo/contact_with_us_repo.dart';
import '../widgets/contact_way_type.dart';
import '../widgets/contact_with_us_image.dart';
import '../widgets/contact_with_us_type.dart';

class AppFeedbackPage extends StatelessWidget {
  const AppFeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated("contact_with_us"),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => ContactWithUsBloc(repo: sl<ContactWithUsRepo>()),
          child: BlocBuilder<ContactWithUsBloc, AppState>(
            builder: (context, state) {
              return Form(
                key: context.read<ContactWithUsBloc>().formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: ListAnimator(
                        customPadding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                        data: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.h),
                            child: const ContactWithUsType(),
                          ),
                          const ContactWithUsImage(),
                          SizedBox(height: 24.h),
                          const ContactWayType(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                        vertical: Dimensions.PADDING_SIZE_DEFAULT.w,
                      ),
                      child: CustomButton(
                        text: getTranslated("submit"),
                        isLoading: state is Loading,
                        onTap: () {
                          if (context
                              .read<ContactWithUsBloc>()
                              .formKey
                              .currentState!
                              .validate()) {
                            context.read<ContactWithUsBloc>().add(Click());
                          }
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
