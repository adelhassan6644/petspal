import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/data/internet_connection/internet_connection.dart';
import 'package:petspal/features/best_seller/bloc/best_seller_bloc.dart';
import 'package:petspal/features/best_seller/repo/best_seller_repo.dart';
import 'package:petspal/features/products/model/products_model.dart';
import 'package:petspal/features/products/widgets/product_card.dart';
import 'package:petspal/main_models/search_engine.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_app_bar.dart';
import '../../../components/custom_loading_text.dart';
import '../../../components/empty_widget.dart';
import '../../../components/grid_list_animator.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';

class BestSellerPage extends StatelessWidget {
  const BestSellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated("best_seller")),
      body: BlocProvider(
        create: (context) => BestSellerBloc(
            repo: sl<BestSellerRepo>(),
            internetConnection: sl<InternetConnection>()),
        // ..add(Click(arguments: SearchEngine())),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
            Expanded(
              child: BlocBuilder<BestSellerBloc, AppState>(
                builder: (context, state) {
                  if (state is Loading) {
                    return GridListAnimatorWidget(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                      aspectRatio: 0.78,
                      items: List.generate(
                        12,
                        (i) => CustomShimmerContainer(
                          height: 220.w,
                          width: 185.w,
                          radius: 20.w,
                        ),
                      ),
                    );
                  }
                  if (state is Done) {
                    List<ProductModel> list = state.list as List<ProductModel>;
                    return RefreshIndicator(
                      color: Styles.PRIMARY_COLOR,
                      onRefresh: () async {
                        context
                            .read<BestSellerBloc>()
                            .add(Click(arguments: SearchEngine()));
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: GridListAnimatorWidget(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      Dimensions.PADDING_SIZE_DEFAULT.w),
                              aspectRatio: 0.78,
                              items: List.generate(
                                list.length,
                                (i) => ProductCard(
                                  product: list[i],
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
                            .read<BestSellerBloc>()
                            .add(Click(arguments: SearchEngine()));
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
                                  horizontal:
                                      Dimensions.PADDING_SIZE_DEFAULT.w),
                              aspectRatio: 0.78,
                              items: List.generate(
                                15,
                                (i) => ProductCard(
                                  product: ProductModel(),
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
    );
  }
}
