import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/app/core/extensions.dart';
import 'package:petspal/app/core/text_styles.dart';
import 'package:petspal/features/language/bloc/language_bloc.dart';
import 'package:petspal/features/products/widgets/price_card.dart';
import 'package:petspal/main_blocs/user_bloc.dart';
import 'package:flutter/material.dart';

import '../../../app/core/styles.dart';
import '../../../app/core/svg_images.dart';
import '../../../components/custom_bottom_sheet.dart';
import '../../../components/custom_images.dart';
import '../../../components/custom_network_image.dart';
import '../../../data/config/di.dart';
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
      alignment:
          sl<LanguageBloc>().isLtr ? Alignment.topRight : Alignment.topLeft,
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
          child: Container(
            width: 185.w,
            decoration: BoxDecoration(
                color: Styles.WHITE_COLOR,
                border: Border.all(color: Styles.LIGHT_BORDER_COLOR),
                borderRadius: BorderRadius.circular(20.w)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomNetworkImage.containerNewWorkImage(
                    radius: 20.w,
                    width: context.width,
                    height: 100.h,
                    image: product.image ?? ""),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name ?? "Product",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: AppTextStyles.w600
                            .copyWith(fontSize: 16, color: Styles.HEADER),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                product.category?.name ?? "Category",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: AppTextStyles.w400.copyWith(
                                    fontSize: 14, color: Styles.SUBTITLE),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: customImageIconSVG(
                                  imageName: SvgImages.fillStar,
                                  width: 16.w,
                                  height: 16.w),
                            ),
                            Text(
                              "${product.avgRate ?? 0}",
                              maxLines: 1,
                              style: AppTextStyles.w600.copyWith(
                                  fontSize: 14, color: Styles.SUBTITLE),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: PriceCard(
                              price: product.price ?? 1,
                              priceAfterDiscount: product.priceAfter ?? 0,
                              fontSize: 14,
                              discountFontSize: 12,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          customContainerSvgIcon(
                              onTap: () {},
                              backGround: Styles.PRIMARY_COLOR,
                              color: Styles.WHITE_COLOR,
                              width: 32.w,
                              height: 32.w,
                              radius: 12.w,
                              padding: 8.w,
                              imageName: SvgImages.addCart),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        if (product.discount != null)
        DiscountWidget(discount: product.discount),
      ],
    );
  }
}
