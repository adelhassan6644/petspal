import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/features/product_details/bloc/product_details_bloc.dart';
import 'package:petspal/features/product_details/model/product_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/core/styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_button.dart';


class PackageDetailsAction extends StatelessWidget {
  const PackageDetailsAction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsBloc, AppState>(
      builder: (context, state) {
        if (state is Done) {
          ProductDetailsModel model = state.model as ProductDetailsModel;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
              vertical: Dimensions.paddingSizeExtraSmall.h,
            ),
            child: CustomButton(
              text: getTranslated("purchase"),
              backgroundColor: Styles.PRIMARY_COLOR,
              textColor: Styles.WHITE_COLOR,
              onTap: () {

              },
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
