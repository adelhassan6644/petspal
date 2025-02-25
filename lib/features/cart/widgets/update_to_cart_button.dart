import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/core/dimensions.dart';
import '../../../app/core/app_core.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../data/config/di.dart';
import '../bloc/cart_bloc.dart';

class UpdateToCartButton extends StatefulWidget {
  const UpdateToCartButton(
      {super.key,
      required this.quantity,
      required this.stock,
      required this.id,
      required this.isHorizontal});

  final int quantity;
  final int stock;
  final int id;
  final bool isHorizontal;

  @override
  State<UpdateToCartButton> createState() => _UpdateToCartButtonState();
}

class _UpdateToCartButtonState extends State<UpdateToCartButton> {
  late int quantity;
  @override
  void initState() {
    quantity = widget.quantity;
    super.initState();
  }

  _onIncrement() {
    if (widget.stock > quantity) {
      setState(() => quantity++);
      sl<CartBloc>()
          .add(Update(arguments: {"cartId": widget.id, "quantity": quantity}));
    } else {
      AppCore.showToast(getTranslated("stock_validation"));
    }
  }

  _onDecrement() {
    if (quantity > 1) {
      setState(() => quantity--);
      sl<CartBloc>()
          .add(Update(arguments: {"cartId": widget.id, "quantity": quantity}));
    } else {
      sl<CartBloc>().add(Delete(arguments: widget.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 2.w,
        vertical: 2.w,
      ),
      decoration: BoxDecoration(
          color: Styles.WHITE_COLOR,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Styles.LIGHT_BORDER_COLOR)),
      child: BlocBuilder<CartBloc, AppState>(
        builder: (context, state) {
          return widget.isHorizontal
              ? Row(
                  children: [
                    InkWell(
                      onTap: _onIncrement,
                      child: Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                            color: Styles.PRIMARY_COLOR.withOpacity(0.15),
                            shape: BoxShape.circle),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: Styles.PRIMARY_COLOR,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Text(
                        "$quantity",
                        style: AppTextStyles.w500
                            .copyWith(fontSize: 18, color: Styles.WHITE_COLOR),
                      ),
                    ),
                    InkWell(
                      onTap: _onDecrement,
                      child: Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                          color: Styles.ERORR_COLOR,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          (quantity > 1)
                              ? Icons.minimize_outlined
                              : Icons.restore_from_trash_sharp,
                          color: Styles.WHITE_COLOR,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: _onIncrement,
                      child: Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                          color: Styles.PRIMARY_COLOR.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: Styles.PRIMARY_COLOR,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: Text(
                        "$quantity",
                        style: AppTextStyles.w500
                            .copyWith(fontSize: 14, color: Styles.HEADER),
                      ),
                    ),
                    InkWell(
                      onTap: _onDecrement,
                      child: Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                          color: Styles.ERORR_COLOR,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            (quantity > 1)
                                ? Icons.minimize_outlined
                                : Icons.restore_from_trash_sharp,
                            color: Styles.WHITE_COLOR,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
