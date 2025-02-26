import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/app/core/extensions.dart';
import 'package:petspal/components/shimmer/custom_shimmer.dart';
import 'package:petspal/navigation/custom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:petspal/app/localization/language_constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/dimensions.dart';
import '../../../components/grid_list_animator.dart';
import '../../../data/config/di.dart';
import '../../../data/internet_connection/internet_connection.dart';
import '../../../main_models/search_engine.dart';
import '../../../main_widgets/section_title.dart';
import '../../../navigation/routes.dart';
import '../bloc/products_bloc.dart';
import '../model/products_model.dart';
import '../repo/products_repo.dart';
import 'product_card.dart';

class ProductsSection extends StatelessWidget {
  const ProductsSection({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsBloc(
          repo: sl<ProductsRepo>(),
          internetConnection: sl<InternetConnection>()),
      // ..add(Click(arguments: SearchEngine(limit: 5))),
      child: Column(
        children: [
          SectionTitle(
            title: title,
            withView: true,
            onViewTap: () => CustomNavigator.push(Routes.products),
          ),
          BlocBuilder<ProductsBloc, AppState>(
            builder: (context, state) {
              // if (state is Done) {
              //   List<ProductModel> products =
              //       state.data ?? [] as List<ProductModel>;
              //   return GridListAnimatorWidget(
              //     padding: EdgeInsets.symmetric(
              //         horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
              //     aspectRatio: 0.78,
              //     items: List.generate(
              //       6,
              //       (i) => ProductCard(
              //         product: products[i],
              //       ),
              //     ),
              //   );
              // }
              // if (state is Loading) {
              //   return GridListAnimatorWidget(
              //     padding: EdgeInsets.symmetric(
              //         horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
              //     aspectRatio: 0.78,
              //     items: List.generate(
              //         5,
              //         (i) => Padding(
              //               padding: EdgeInsets.symmetric(
              //                   horizontal: Dimensions.paddingSizeMini.w),
              //               child: CustomShimmerContainer(
              //                 radius: 12.w,
              //                 height: 180.h,
              //                 width: context.width * 0.82,
              //               ),
              //             )),
              //   );
              // }
              // else
              {
                return GridListAnimatorWidget(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                  aspectRatio: 0.78,
                  items: List.generate(
                    6,
                    (i) => ProductCard(
                      product: ProductModel(),
                    ),
                  ),
                );
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
