import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/localization/language_constant.dart';
import 'package:petspal/features/best_seller/bloc/best_seller_bloc.dart';
import 'package:petspal/features/products/model/products_model.dart';
import 'package:petspal/features/products/widgets/product_card.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../data/internet_connection/internet_connection.dart';
import '../../../main_models/search_engine.dart';
import '../../../main_widgets/section_title.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';
import '../repo/best_seller_repo.dart';

class BestSellerSection extends StatelessWidget {
  const BestSellerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          title: getTranslated("best_seller"),
          withView: true,
          onViewTap: () => CustomNavigator.push(Routes.bestSeller),
        ),
        BlocProvider(
          create: (context) => BestSellerBloc(
              repo: sl<BestSellerRepo>(),
              internetConnection: sl<InternetConnection>()),
          // ..add(Click(arguments: SearchEngine())),
          child: BlocBuilder<BestSellerBloc, AppState>(
            builder: (context, state) {
              // if (state is Done) {
              //   List<ProductModel> list = state.list as List<ProductModel>;
              //   return SingleChildScrollView(
              //     scrollDirection: Axis.horizontal,
              //     physics: const BouncingScrollPhysics(),
              //     child: Row(
              //       children: [
              //         SizedBox(width: Dimensions.paddingSizeExtraSmall.w),
              //         ...List.generate(
              //           list.length,
              //           (i) => Padding(
              //             padding: EdgeInsets.symmetric(horizontal: 8.w),
              //             child: ProductCard(
              //               product: list[i],
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //   );
              // }
              // if (state is Loading) {
              //   return SingleChildScrollView(
              //     scrollDirection: Axis.horizontal,
              //     physics: const BouncingScrollPhysics(),
              //     padding: EdgeInsets.symmetric(
              //         vertical: Dimensions.PADDING_SIZE_SMALL.h),
              //     child: Row(
              //       children: [
              //         SizedBox(width: Dimensions.paddingSizeExtraSmall.w),
              //         ...List.generate(
              //           5,
              //           (i) => Padding(
              //             padding: EdgeInsets.symmetric(horizontal: 8.w),
              //             child: CustomShimmerContainer(
              //               height: 220.w,
              //               width: 185.w,
              //               radius: 20.w,
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //   );
              // } else
              {
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
                          child: ProductCard(
                            product: ProductModel(discount: i == 1 ? 10 : null),
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
        ),
      ],
    );
  }
}
