import 'package:petspal/app/localization/language_constant.dart';
import 'package:petspal/features/categories/bloc/categories_bloc.dart';
import 'package:petspal/features/categories/model/categories_model.dart';
import 'package:petspal/features/categories/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/main_widgets/section_title.dart';
import 'package:petspal/navigation/custom_navigation.dart';
import 'package:petspal/navigation/routes.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';

import '../../../components/shimmer/custom_shimmer.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          title: getTranslated("shop_by_pets"),
          withView: true,
          onViewTap: () => CustomNavigator.push(Routes.categories),
        ),
        BlocBuilder<CategoriesBloc, AppState>(
          builder: (context, state) {
            if (state is Done) {
              List<CategoryModel> list = state.list as List<CategoryModel>;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    SizedBox(width: Dimensions.paddingSizeExtraSmall.w),
                    ...List.generate(
                      list.length,
                      (i) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: CategoryCard(
                          model: list[i],
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
            if (state is Loading) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                    vertical: Dimensions.PADDING_SIZE_SMALL.h),
                child: Row(
                  children: [
                    SizedBox(width: Dimensions.paddingSizeExtraSmall.w),
                    ...List.generate(
                      5,
                      (i) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomShimmerContainer(
                              height: 80.w,
                              width: 80.w,
                              radius: 20.w,
                            ),
                            SizedBox(height: 4.h),
                            CustomShimmerText(
                              height: 16.h,
                              width: 60.w,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    SizedBox(width: Dimensions.paddingSizeExtraSmall.w),
                    ...List.generate(
                      5,
                      (i) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: CategoryCard(
                          model: CategoryModel(),
                        ),
                      ),
                    )
                  ],
                ),
              );
              return SizedBox();
            }
          },
        ),
      ],
    );
  }
}
