import 'dart:ui';

import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/app/core/extensions.dart';
import 'package:zurex/app/core/text_styles.dart';
import 'package:zurex/features/products/widgets/price_card.dart';
import 'package:zurex/main_blocs/user_bloc.dart';
import 'package:flutter/material.dart';

import '../../../app/core/styles.dart';
import '../../../components/custom_bottom_sheet.dart';
import '../../../components/custom_network_image.dart';
import '../../../main_widgets/discount_widget.dart';
import '../../../main_widgets/guest_mode.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';
import '../model/products_model.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            if (UserBloc.instance.isLogin) {
              CustomNavigator.push(Routes.productDetails,
                  arguments: product.id);
            } else {
              CustomBottomSheet.show(widget: const GuestMode());
            }
          },
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: CustomNetworkImage.containerNewWorkImage(
                    onTap: () {
                      if (UserBloc.instance.isLogin) {
                        CustomNavigator.push(Routes.productDetails,
                            arguments: product.id);
                      } else {
                        CustomBottomSheet.show(widget: const GuestMode());
                      }
                    },
                    radius: 8.w,
                    width: context.width,
                    height: context.height,
                    image: product.image ?? ""),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.w),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name ?? "product",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: AppTextStyles.w700.copyWith(
                                    fontSize: 16, color: Styles.HEADER),
                              ),
                              SizedBox(height: 4.h),
                              PriceCard(
                                price: product.price,
                                priceAfterDiscount: product.priceAfter,
                                fontSize: 14,
                                discountFontSize: 12,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.circular(100),
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Transform.rotate(
                                angle: -0.5,
                                child: const Icon(
                                  Icons.arrow_forward,
                                  size: 20,
                                  color: Styles.PRIMARY_COLOR,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (product.discount != null)
          Positioned(
            top: 12,
            right: 1,
            child: DiscountWidget(discount: product.discount),
          ),
      ],
    );
  }
}
