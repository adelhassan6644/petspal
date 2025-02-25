import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/core/extensions.dart';
import 'package:petspal/app/localization/language_constant.dart';
import 'package:petspal/components/custom_app_bar.dart';

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
import '../bloc/categories_bloc.dart';
import '../model/categories_model.dart';
import '../widgets/category_card.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated("categories")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
          Expanded(
            child: BlocBuilder<CategoriesBloc, AppState>(
              builder: (context, state) {
                if (state is Loading) {
                  return GridListAnimatorWidget(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                    aspectRatio: 1.1,
                    items: List.generate(
                      12,
                      (i) => Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomShimmerContainer(
                            height: 130.h,
                            width: context.width,
                            radius: 20.w,
                          ),
                          SizedBox(height: 5.h),
                          CustomShimmerText(
                            height: 16.h,
                            width: 100.w,
                          )
                        ],
                      ),
                    ),
                  );
                }
                if (state is Done) {
                  List<CategoryModel> list = state.list as List<CategoryModel>;
                  return RefreshIndicator(
                    color: Styles.PRIMARY_COLOR,
                    onRefresh: () async {
                      sl<CategoriesBloc>().add(Click());
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: GridListAnimatorWidget(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                            aspectRatio: 1.1,
                            items: List.generate(
                              list.length,
                              (i) => CategoryCard(
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
                      sl<CategoriesBloc>().add(Click());
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
                                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                            aspectRatio: 1.1,
                            items: List.generate(
                              15,
                              (i) => CategoryCard(
                                width: context.width,
                                height: 130.h,
                                model: CategoryModel(),
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
    );
  }
}
