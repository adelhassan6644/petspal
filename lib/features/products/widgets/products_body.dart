import 'package:petspal/app/core/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/components/grid_list_animator.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_loading_text.dart';
import '../../../components/empty_widget.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../main_models/search_engine.dart';
import '../bloc/products_bloc.dart';
import '../model/products_model.dart';
import 'product_card.dart';

class ProductsBody extends StatelessWidget {
  const ProductsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ProductsBloc, AppState>(
        builder: (context, state) {
          if (state is Loading) {
            return GridListAnimatorWidget(
              controller: context.read<ProductsBloc>().controller,
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
              items: List.generate(
                16,
                (i) => CustomShimmerContainer(
                  height: 180.h,
                  width: context.width,
                  radius: 12.w,
                ),
              ),
            );
          }
          if (state is Done) {
            List<ProductModel> products = state.list as List<ProductModel>;
            return RefreshIndicator(
              color: Styles.PRIMARY_COLOR,
              onRefresh: () async {
                context
                    .read<ProductsBloc>()
                    .add(Click(arguments: SearchEngine()));
              },
              child: Column(
                children: [
                  Expanded(
                    child: GridListAnimatorWidget(
                        controller: context.read<ProductsBloc>().controller,
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                        items: List.generate(products.length,
                            (i) => ProductCard(product: products[i]))),
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
                    .read<ProductsBloc>()
                    .add(Click(arguments: SearchEngine()));
              },
              child: Column(
                children: [
                  Expanded(
                    child: ListAnimator(
                      controller: context.read<ProductsBloc>().controller,
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
    );
  }
}
