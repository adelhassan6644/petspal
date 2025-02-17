import 'package:zurex/app/core/app_state.dart';
import 'package:zurex/app/core/extensions.dart';
import 'package:zurex/components/shimmer/custom_shimmer.dart';
import 'package:zurex/navigation/custom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:zurex/app/localization/language_constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/dimensions.dart';
import '../../../data/config/di.dart';
import '../../../data/internet_connection/internet_connection.dart';
import '../../../main_models/search_engine.dart';
import '../../../main_widgets/section_title.dart';
import '../../../navigation/routes.dart';
import '../bloc/products_bloc.dart';
import '../model/products_model.dart';
import '../repo/products_repo.dart';
import 'product_card.dart';

class TopProductsSection extends StatelessWidget {
  const TopProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsBloc(
          repo: sl<ProductsRepo>(),
          internetConnection: sl<InternetConnection>())
        ..add(Click(arguments: SearchEngine(limit: 5))),
      child: BlocBuilder<ProductsBloc, AppState>(
        builder: (context, state) {
          if (state is Done) {
            List<ProductModel> packages =
                state.data ?? [] as List<ProductModel>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(
                  title: getTranslated("featured_packages"),
                  withView: true,
                  onViewTap: () => CustomNavigator.push(Routes.products),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: Dimensions.paddingSizeExtraSmall.w),
                      ...List.generate(
                          packages.length > 5 ? 5 : packages.length,
                          (i) => Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeMini.w),
                                child: ProductCard(
                                  product: packages[i],
                                ),
                              )),
                    ],
                  ),
                ),
              ],
            );
          }
          if (state is Loading) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(
                  title: getTranslated("featured_packages"),
                  withView: true,
                  onViewTap: () => CustomNavigator.push(Routes.products),
                ),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: Dimensions.paddingSizeExtraSmall.w,
                          ),
                          ...List.generate(
                              5,
                              (i) => Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.paddingSizeMini.w),
                                    child: CustomShimmerContainer(
                                      radius: 12.w,
                                      height: 180.h,
                                      width: context.width * 0.82,
                                    ),
                                  )),
                        ])),
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
