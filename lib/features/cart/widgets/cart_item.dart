import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/features/cart/widgets/update_to_cart_button.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_network_image.dart';
import '../../../data/config/di.dart';
import '../../../main_widgets/discount_widget.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';
import '../../products/widgets/price_card.dart';
import '../bloc/cart_bloc.dart';
import '../model/cart_model.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.item});
  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(item.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        children: [
          SlidableAction(
            onPressed: (context) =>
                sl<CartBloc>().add(Delete(arguments: item.id)),
            backgroundColor: Styles.RED_COLOR,
            foregroundColor: Colors.white,
            label: getTranslated("delete"),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => CustomNavigator.push(Routes.productDetails,
            arguments: {"id": item.product?.id, "from_cart": true}),
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(
              color: Styles.LIGHT_BORDER_COLOR,
            ),
            boxShadow: [
              BoxShadow(
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(1, 1),
                  color: Colors.black.withOpacity(0.06))
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    CustomNetworkImage.containerNewWorkImage(
                      height: 100.h,
                      width: double.infinity,
                      radius: 12.w,
                      image: item.product?.image ?? "",
                    ),
                    if (item.product?.discount != null)
                      Positioned(
                        top: 12,
                        right: 1,
                        child: DiscountWidget(
                            discount: item.product?.discount ?? 2),
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ///Name
                          Text(
                            item.product?.name ?? "Item Tile",
                            style: AppTextStyles.w600
                                .copyWith(fontSize: 14, color: Styles.HEADER),
                          ),
                          SizedBox(height: 4.h),

                          ///Price
                          PriceCard(
                            price: item.product?.price,
                            priceAfterDiscount: item.product?.priceAfter,
                            fontSize: 14,
                            discountFontSize: 12,
                          ),
                        ],
                      )),
                      SizedBox(width: 8.w),
                      UpdateToCartButton(
                        quantity: item.quantity ?? 0,
                        stock: (item.product?.quantity ?? 0),
                        id: item.id ?? 0,
                        isHorizontal: false,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
