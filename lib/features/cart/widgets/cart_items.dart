import 'package:flutter/material.dart';
import '../../../app/core/dimensions.dart';
import '../../../components/animated_widget.dart';
import '../model/cart_model.dart';
import 'cart_item.dart';

class CartItems extends StatelessWidget {
  const CartItems({super.key, required this.items});
  final List<CartItemModel> items;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListAnimator(
        customPadding: EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
          vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
        ),
        data: List.generate(
          items.length,
          (i) => CartItem(
            item: items[i],
          ),
        ),
      ),
    );
  }
}
