import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/app/core/extensions.dart';
import 'package:petspal/features/maps/bloc/map_bloc.dart';
import 'package:petspal/features/maps/models/location_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_button.dart';
import '../../../navigation/custom_navigation.dart';

class AddressResultWidget extends StatelessWidget {
  const AddressResultWidget({super.key, this.onChange});

  final Function(LocationModel)? onChange;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: -10,
        width: context.width,
        child: Container(
            height: 200.h,
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Styles.WHITE_COLOR,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 5.0,
                      spreadRadius: -1,
                      offset: const Offset(0, 6))
                ]),
            child: BlocBuilder<MapBloc, AppState>(
              builder: (context, state) {
                if (state is Loading) {
                  return Padding(
                      padding: EdgeInsets.only(bottom: 50.h),
                      child: const Center(child: CupertinoActivityIndicator()));
                }
                if (state is Done) {
                  LocationModel model = state.model as LocationModel;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getTranslated("address"),
                        style: AppTextStyles.w600
                            .copyWith(color: Colors.black, fontSize: 14),
                      ),
                      Text(
                        model.address ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.w400.copyWith(
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 13),
                      ),
                      const Expanded(child: SizedBox()),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
                        child: CustomButton(
                          text: getTranslated("confirm"),
                          onTap: () {
                            model.onChange = onChange;
                            onChange?.call(model);
                            CustomNavigator.pop();
                          },
                        ),
                      )
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            )));
  }
}
