import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/core/extensions.dart';
import 'package:petspal/app/localization/language_constant.dart';
import 'package:petspal/components/custom_app_bar.dart';
import 'package:petspal/features/cart/model/receipt_details_model.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/images.dart';
import '../../../app/core/styles.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_button.dart';
import '../../../components/empty_widget.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/coupon_bloc.dart';
import '../model/cart_model.dart';
import '../repo/cart_repo.dart';
import '../widgets/cart_body.dart';
import '../widgets/cart_items.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated("cart"),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => CouponBloc(repo: sl<CartRepo>()),
          child: BlocBuilder<CartBloc, AppState>(
            builder: (context, state) {
              if (state is Loading) {
                return Column(
                  children: [
                    ///Cart Items
                    ListAnimator(
                      customPadding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                        vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                      ),
                      data: List.generate(
                        2,
                        (i) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: CustomShimmerContainer(
                            height: 120.h,
                            width: context.width,
                            radius: 14,
                          ),
                        ),
                      ),
                    ),

                    ///Coupon
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                      child: CustomShimmerContainer(
                        height: 65.h,
                        width: context.width,
                        radius: 12,
                      ),
                    ),

                    ///Receipt Details
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                            vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
                        child: CustomShimmerContainer(
                          height: 65.h,
                          width: context.width,
                          radius: 12,
                        ),
                      ),
                    ),

                    ///Button
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                      child: CustomShimmerContainer(
                        height: 65.h,
                        width: context.width,
                        radius: 12,
                      ),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
                  ],
                );
              }
              if (state is Done) {
                CartModel model = state.model as CartModel;
                return Column(
                  children: [
                    CartItems(items: model.items ?? []),
                    CartBody(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                      ),
                      child: BlocBuilder<CouponBloc, AppState>(
                        builder: (context, state) {
                          return CustomButton(
                              text: getTranslated("proceed_to_check_out"),
                              onTap: () => CustomNavigator.push(Routes.checkOut,
                                      arguments: {
                                        "coupon": context
                                            .read<CouponBloc>()
                                            .couponTEC
                                            .text
                                            .trim(),
                                      }));
                        },
                      ),
                    ),
                    SizedBox(height: Dimensions.paddingSizeExtraSmall.h),
                  ],
                );
              }
              if (state is Empty) {
                return Column(
                  children: [
                    Expanded(
                      child: ListAnimator(
                        customPadding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                          vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                        ),
                        data: [
                          SizedBox(height: 40.h),
                          EmptyState(
                            txt: getTranslated("cart_empty_header"),
                            subText: getTranslated("cart_empty_description"),
                            // img: Images.emptyCart,
                            imgHeight: context.height * 0.2,
                          ),
                          SizedBox(height: 40.h),
                          CustomButton(
                              text: getTranslated("explore"),
                              onTap: () => CustomNavigator.push(
                                  Routes.dashboard,
                                  arguments: 0,
                                  clean: true))
                        ],
                      ),
                    ),
                  ],
                );
              }
              if (state is Error) {
                return RefreshIndicator(
                  color: Styles.PRIMARY_COLOR,
                  onRefresh: () async {
                    sl<CartBloc>().add(Get());
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: ListAnimator(
                          customPadding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                            vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                          ),
                          data: [
                            SizedBox(
                              height: 50.h,
                            ),
                            EmptyState(
                              txt: getTranslated("something_went_wrong"),
                              imgHeight: context.height * 0.2,
                              img: Images.failCart,
                            ),
                            SizedBox(height: 40.h),
                            CustomButton(
                                text: getTranslated("refresh"),
                                onTap: () => sl<CartBloc>().add(Get()))
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Column(
                  children: [
                    CartItems(
                      items: [
                        CartItemModel(),
                        CartItemModel(),
                        CartItemModel(),
                      ],
                    ),
                    CartBody(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                      ),
                      child: BlocBuilder<CouponBloc, AppState>(
                        builder: (context, state) {
                          return CustomButton(
                              text: getTranslated("proceed_to_check_out"),
                              onTap: () => CustomNavigator.push(Routes.checkOut,
                                      arguments: {
                                        "coupon": context
                                            .read<CouponBloc>()
                                            .couponTEC
                                            .text
                                            .trim(),
                                      }));
                        },
                      ),
                    ),
                    SizedBox(height: Dimensions.paddingSizeExtraSmall.h),
                  ],
                );

                return SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}
