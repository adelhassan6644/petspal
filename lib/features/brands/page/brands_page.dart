import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/core/extensions.dart';
import 'package:petspal/app/localization/language_constant.dart';
import 'package:petspal/components/custom_app_bar.dart';
import 'package:petspal/main_models/search_engine.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_loading_text.dart';
import '../../../components/empty_widget.dart';
import '../../../components/grid_list_animator.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../data/internet_connection/internet_connection.dart';
import '../bloc/brands_bloc.dart';
import '../model/brands_model.dart';
import '../repo/brands_repo.dart';
import '../widgets/brand_card.dart';

class BrandsPage extends StatelessWidget {
  const BrandsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated("brands")),
      body: BlocProvider(
        create: (context) => BrandsBloc(
            repo: sl<BrandsRepo>(),
            internetConnection: sl<InternetConnection>()),
        // ..add(Click(arguments: SearchEngine())),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
              Expanded(
                child: BlocBuilder<BrandsBloc, AppState>(
                  builder: (context, state) {
                    if (state is Loading) {
                      return GridListAnimatorWidget(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                        aspectRatio: 1,
                        columnCount: 3,
                        items: List.generate(
                          12,
                          (i) => CustomShimmerContainer(
                            height: 130.h,
                            width: context.width,
                            radius: 20.w,
                          ),
                        ),
                      );
                    }
                    if (state is Done) {
                      List<BrandModel> list = state.list as List<BrandModel>;
                      return RefreshIndicator(
                        color: Styles.PRIMARY_COLOR,
                        onRefresh: () async {
                          context
                              .read<BrandsBloc>()
                              .add(Click(arguments: SearchEngine()));
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: GridListAnimatorWidget(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions.PADDING_SIZE_DEFAULT.w),
                                aspectRatio: 1,
                                columnCount: 3,
                                controller:
                                    context.read<BrandsBloc>().controller,
                                items: List.generate(
                                  list.length,
                                  (i) => BrandCard(
                                    model: list[i],
                                  ),
                                ),
                              ),
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
                              .read<BrandsBloc>()
                              .add(Click(arguments: SearchEngine()));
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: ListAnimator(
                                customPadding: EdgeInsets.symmetric(
                                    vertical:
                                        Dimensions.PADDING_SIZE_DEFAULT.h),
                                data: [
                                  SizedBox(height: 50.h),
                                  EmptyState(
                                      txt: state is Error
                                          ? getTranslated(
                                              "something_went_wrong")
                                          : null),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return RefreshIndicator(
                        color: Styles.PRIMARY_COLOR,
                        onRefresh: () async {},
                        child: Column(
                          children: [
                            Expanded(
                              child: GridListAnimatorWidget(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions.PADDING_SIZE_DEFAULT.w),
                                aspectRatio: 1,
                                columnCount: 3,
                                items: List.generate(
                                  15,
                                  (i) => BrandCard(
                                    model: BrandModel(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      return const SizedBox();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
