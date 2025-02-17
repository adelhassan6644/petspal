import 'package:zurex/app/core/extensions.dart';
import 'package:zurex/components/animated_widget.dart';
import 'package:zurex/components/custom_app_bar.dart';
import 'package:zurex/features/my_cars/bloc/my_cars_bloc.dart';
import 'package:zurex/features/my_cars/widgets/my_car_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../app/core/app_event.dart';
import '../../../../../app/localization/language_constant.dart';
import '../../../../../main_models/search_engine.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../components/custom_loading_text.dart';
import '../../../components/empty_widget.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../model/cars_model.dart';

class MyCarsPage extends StatelessWidget {
  const MyCarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated("my_cars"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
          Expanded(
            child: BlocBuilder<MyCarsBloc, AppState>(
              builder: (context, state) {
                if (state is Loading) {
                  return ListAnimator(
                    controller: context.read<MyCarsBloc>().controller,
                    customPadding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                    data: List.generate(
                      10,
                      (i) => CustomShimmerContainer(
                        height: 120.h,
                        width: context.width,
                        radius: 12.w,
                      ),
                    ),
                  );
                }
                if (state is Done) {
                  List<CarModel> cars = state.list as List<CarModel>;
                  return RefreshIndicator(
                    color: Styles.PRIMARY_COLOR,
                    onRefresh: () async {
                      context
                          .read<MyCarsBloc>()
                          .add(Click(arguments: SearchEngine()));
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: ListAnimator(
                              controller: context.read<MyCarsBloc>().controller,
                              customPadding: EdgeInsets.symmetric(
                                  horizontal:
                                      Dimensions.PADDING_SIZE_DEFAULT.w),
                              data: List.generate(
                                  cars.length, (i) => MyCarCard(car: cars[i]))),
                        ),
                        CustomLoadingText(loading: state.loading),
                      ],
                    ),
                  );
                }
                if (state is Error || state is Empty) {
                  return RefreshIndicator(
                    color: Styles.PRIMARY_COLOR,
                    onRefresh: () async {
                      context
                          .read<MyCarsBloc>()
                          .add(Click(arguments: SearchEngine()));
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: ListAnimator(
                            controller: context.read<MyCarsBloc>().controller,
                            customPadding: EdgeInsets.symmetric(
                              vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                            ),
                            data: [
                              SizedBox(height: 50.h),
                              EmptyState(
                                  txt: state is Error
                                      ? getTranslated("something_went_wrong")
                                      : null),
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
}
