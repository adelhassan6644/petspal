import 'package:petspal/app/core/text_styles.dart';
import 'package:petspal/app/localization/language_constant.dart';
import 'package:petspal/features/check_out/bloc/check_out_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import 'bank_transfer_image.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
          vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
      color: Styles.SMOKED_WHITE_COLOR,
      child: StreamBuilder(
          stream: context.read<CheckOutBloc>().paymentTypeStream,
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslated("payment_method"),
                  style: AppTextStyles.w600
                      .copyWith(fontSize: 18, color: Styles.HEADER),
                ),
                SizedBox(height: 8.h),
                ...List.generate(
                  PaymentType.values.length,
                  (i) => _SelectedMethod(
                    method: PaymentType.values[i],
                    isSelected: PaymentType.values[i] == snapshot.data,
                    onSelect: context.read<CheckOutBloc>().updatePaymentType,
                  ),
                ),

                ///Bank Transfer
                BankTransferImage(
                    show: PaymentType.byBankTransfer == snapshot.data),
              ],
            );
          }),
    );
  }
}

class _SelectedMethod extends StatelessWidget {
  const _SelectedMethod(
      {required this.method, required this.isSelected, required this.onSelect});
  final PaymentType method;
  final bool isSelected;
  final Function(PaymentType) onSelect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelect(method),
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                isSelected
                    ? Icons.radio_button_checked_outlined
                    : Icons.radio_button_off,
                size: 18,
                color: isSelected ? Styles.PRIMARY_COLOR : Styles.TITLE),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                getTranslated(method.name),
                style: AppTextStyles.w500.copyWith(
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  color: isSelected ? Styles.PRIMARY_COLOR : Styles.TITLE,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
