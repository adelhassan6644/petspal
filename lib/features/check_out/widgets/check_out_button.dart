import 'package:zurex/app/core/app_state.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/app/localization/language_constant.dart';
import 'package:zurex/components/custom_button.dart';
import 'package:zurex/features/check_out/bloc/coupon_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/core/app_event.dart';
import '../bloc/check_out_bloc.dart';
import '../repo/check_out_product_repo.dart';

class CheckOutButton extends StatelessWidget {
  const CheckOutButton(
      {super.key,
      required this.id,
      required this.isOrder,
      this.onSuccess,
      this.type});
  final int id;
  final CheckOutProductType? type;

  final bool isOrder;
  final Function(dynamic)? onSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckOutBloc, AppState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
              vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
          child: CustomButton(
            text: getTranslated(isOrder ? "check_out" : "purchase"),
            isLoading: state is Loading,
            onTap: () => context.read<CheckOutBloc>().add(Click(arguments: {
                  "id": id,
                  "coupon": context.read<CouponBloc>().couponTEC.text.trim(),
                  if (type != null) "type": type?.name,
                  if (onSuccess != null) "onSuccess": onSuccess
                })),
          ),
        );
      },
    );
  }
}
