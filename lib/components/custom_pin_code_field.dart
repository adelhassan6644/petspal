import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/app/core/extensions.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../app/core/styles.dart';
import '../app/core/text_styles.dart';

class CustomPinCodeField extends StatelessWidget {
  final void Function(String?)? onSave;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validation;

  const CustomPinCodeField(
      {super.key,
      this.onSave,
      this.validation,
      this.onChanged,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      validator: validation,
      cursorColor: Styles.PRIMARY_COLOR,
      backgroundColor: Colors.transparent,
      autoDisposeControllers: false,
      autoDismissKeyboard: true,
      enableActiveFill: true,
      controller: controller,
      enablePinAutofill: true,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
      textStyle: AppTextStyles.w600.copyWith(
        color: Styles.HEADER,
      ),
      pastedTextStyle: AppTextStyles.w600.copyWith(color: Styles.HEADER),
      textInputAction: TextInputAction.done,
      pinTheme: PinTheme(
        borderWidth: 1,
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(10),
        fieldHeight: 50.h,
        fieldWidth: 50.w,
        fieldOuterPadding: EdgeInsets.symmetric(horizontal: 4.w),
        activeFillColor: Styles.PRIMARY_COLOR.withOpacity(0.1),
        activeColor: Styles.PRIMARY_COLOR,
        inactiveColor: Styles.LIGHT_BORDER_COLOR,
        inactiveFillColor: Colors.transparent,
        selectedFillColor: Colors.transparent,
        selectedColor: Styles.PRIMARY_COLOR,
        disabledColor: Styles.ERORR_COLOR,
        errorBorderColor: Styles.ERORR_COLOR,
      ),
      appContext: context,
      length: 6,
      onSaved: onSave,
      onChanged: (v) {
        onChanged?.call(v);
      },
      errorTextSpace: (context.width - (5 * 50.w)) / 4,
    );
  }
}
