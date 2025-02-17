import 'package:petspal/app/core/extensions.dart';
import 'package:petspal/app/localization/language_constant.dart';
import 'package:petspal/components/empty_widget.dart';
import 'package:petspal/components/grid_list_animator.dart';
import 'package:petspal/features/categories/bloc/categories_bloc.dart';
import 'package:petspal/features/categories/model/categories_model.dart';
import 'package:petspal/features/categories/repo/categories_repo.dart';
import 'package:petspal/features/categories/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/main_widgets/section_title.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../data/internet_connection/internet_connection.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesBloc(
          repo: sl<CategoriesRepo>(),
          internetConnection: sl<InternetConnection>())
        ..add(Click()),
      child: Column(
        children: [
          SectionTitle(title: getTranslated("zurex_services")),
          BlocBuilder<CategoriesBloc, AppState>(
            builder: (context, state) {
              if (state is Done) {
                List<CategoryModel> list = state.list as List<CategoryModel>;
                return GridListAnimatorWidget(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                  aspectRatio: 0.9,
                  items: List.generate(
                    list.length,
                    (i) => CategoryCard(
                      model: list[i],
                    ),
                  ),
                );
              }
              if (state is Loading) {
                return GridListAnimatorWidget(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                  aspectRatio: 0.9,
                  items: List.generate(
                      4,
                      (i) => CustomShimmerContainer(
                            height: 120.h,
                            width: context.width,
                            radius: 12.w,
                          )),
                );
              } else {
                return GridListAnimatorWidget(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                  aspectRatio: 0.95,
                  items: List.generate(
                    4,
                    (i) => CategoryCard(
                      model: CategoryModel(),
                    ),
                  ),
                );
                return EmptyState();
              }
            },
          ),
        ],
      ),
    );
  }
}
