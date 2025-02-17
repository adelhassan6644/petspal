import 'package:zurex/app/core/app_state.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/core/app_event.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_button.dart';
import '../bloc/edit_profile_bloc.dart';

class EditProfileActions extends StatelessWidget {
  const EditProfileActions({super.key, required this.fromComplete});
  final bool fromComplete;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileBloc, AppState>(
      builder: (context, state) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: 12.h, horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
            child: CustomButton(
                text: getTranslated("confirm"),
                onTap: () {
                  if (context
                      .read<EditProfileBloc>()
                      .formKey
                      .currentState!
                      .validate()) {
                    context
                        .read<EditProfileBloc>()
                        .add(Click(arguments: fromComplete));
                  }
                },
                isLoading: state is Loading),
          ),
        );
      },
    );
  }
}
