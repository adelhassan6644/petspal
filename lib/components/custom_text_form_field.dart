import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/app/core/extensions.dart';
import 'package:petspal/app/core/text_styles.dart';
import '../app/core/styles.dart';
import '../app/core/svg_images.dart';
import 'custom_error_widget.dart';
import 'custom_images.dart';

class CustomTextField extends StatefulWidget {
  final IconData? suffixIcon;
  final TextInputAction keyboardAction;
  final Color? iconColor;
  final TextInputType? inputType;
  final String? hint;
  final String? label;
  final void Function(String)? onChanged;
  final bool isPassword;
  final FocusNode? focusNode, nextFocus;
  final FormFieldValidator<String>? validate;
  final int? maxLines;
  final int? minLines;
  final TextEditingController? controller;
  final bool keyboardPadding;
  final bool withLabel;
  final bool readOnly;
  final int? maxLength;
  final bool obscureText;
  final bool? autoFocus;
  final bool? alignLabel;
  final dynamic errorText;
  final String? initialValue;
  final bool isEnabled;
  final bool? alignLabelWithHint;
  final bool? withPadding;
  final bool withWidth;
  final bool? customError;
  final GestureTapCallback? onTap;
  final Color? onlyBorderColor;
  final List<TextInputFormatter>? formattedType;
  final Alignment? align;
  final Function(dynamic)? onTapOutside;
  final double? height;
  final Iterable<String>? autofillHints;
  final String? sufSvgIcon, sufAssetIcon;
  final String? pAssetIcon, pSvgIcon;
  final Color? pIconColor, sIconColor;
  final Widget? prefixWidget, sufWidget;
  final void Function(String)? onSubmit;

  const CustomTextField({
    super.key,
    this.height,
    this.sufAssetIcon,
    this.pAssetIcon,
    this.pSvgIcon,
    this.pIconColor,
    this.sIconColor,
    this.sufWidget,
    this.prefixWidget,
    this.suffixIcon,
    this.sufSvgIcon,
    this.keyboardAction = TextInputAction.next,
    this.align,
    this.inputType,
    this.hint,
    this.alignLabelWithHint,
    this.onChanged,
    this.autofillHints,
    this.validate,
    this.obscureText = false,
    this.isPassword = false,
    this.withWidth = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.isEnabled = true,
    this.withPadding = true,
    this.alignLabel = false,
    this.controller,
    this.errorText = "",
    this.maxLength,
    this.formattedType,
    this.focusNode,
    this.nextFocus,
    this.iconColor,
    this.keyboardPadding = false,
    this.autoFocus,
    this.initialValue,
    this.onlyBorderColor,
    this.customError = false,
    this.withLabel = false,
    this.label,
    this.onTap,
    this.onTapOutside,
    this.onSubmit,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isHidden = true;
  bool _isFocus = false;

  _visibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  void initState() {
    widget.focusNode?.addListener(() {
      _onFocus();
    });
    super.initState();
  }

  _onFocus() {
    setState(() {
      _isFocus = widget.focusNode?.hasFocus == true;
    });
  }

  activationColor() {
    return ((widget.customError == true &&
            widget.errorText != null &&
            widget.errorText != "")
        ? Styles.ERORR_COLOR
        : _isFocus
            ? Styles.PRIMARY_COLOR
            : Styles.BORDER_COLOR);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          Container(
            width: widget.withWidth ? context.width * .8 : context.width,
            decoration: BoxDecoration(
                color: Styles.WHITE_COLOR,
                border: Border.all(
                  color: activationColor(),
                ),
                borderRadius: BorderRadius.circular(15.0)),
            height: widget.height ?? 65,
            child: Center(
              child: TextFormField(
                autofillHints: widget.autofillHints,
                focusNode: widget.focusNode,
                onFieldSubmitted: (v) {
                  widget.onSubmit?.call(v);
                  setState(() {
                    _isFocus = false;
                  });
                  FocusScope.of(context).requestFocus(widget.nextFocus);
                },
                initialValue: widget.initialValue,
                textInputAction: widget.keyboardAction,
                textAlignVertical: widget.inputType == TextInputType.phone
                    ? TextAlignVertical.center
                    : TextAlignVertical.top,
                onTap: () {
                  widget.onTap?.call();
                },
                onTapOutside: (v) {
                  widget.onTapOutside?.call(v);
                  setState(() {
                    _isFocus = false;
                  });
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                autofocus: widget.autoFocus ?? false,
                maxLength: widget.maxLength,
                readOnly: widget.readOnly,
                obscureText:
                    widget.isPassword == true ? _isHidden : widget.obscureText,
                obscuringCharacter: "*",
                controller: widget.controller,
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                validator: widget.validate,
                keyboardType: widget.inputType,
                onChanged: widget.onChanged,
                inputFormatters: widget.inputType == TextInputType.phone
                    ? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
                    : widget.formattedType ?? [],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  color: Styles.HEADER,
                ),
                scrollPhysics: const BouncingScrollPhysics(),
                scrollPadding: EdgeInsets.only(
                    bottom: widget.keyboardPadding ? context.bottom : 0.0),
                decoration: InputDecoration(
                  enabled: widget.isEnabled,
                  labelText: widget.label,
                  hintText: widget.hint ?? '',
                  errorText: null,
                  alignLabelWithHint:
                      widget.alignLabelWithHint ?? widget.alignLabel,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  errorMaxLines: 2,
                  labelStyle: AppTextStyles.w600.copyWith(
                      color: Styles.PRIMARY_COLOR,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  floatingLabelStyle: AppTextStyles.w600.copyWith(
                      color: Styles.PRIMARY_COLOR,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintStyle: AppTextStyles.w600.copyWith(
                      color: Styles.HINT_COLOR,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                  prefixIcon: widget.prefixWidget ??
                      (widget.pAssetIcon != null
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Image.asset(
                                widget.pAssetIcon!,
                                height: 20.h,
                                width: 20.w,
                                color: widget.pIconColor ?? activationColor(),
                              ),
                            )
                          : widget.pSvgIcon != null
                              ? Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.w),
                                  child: customImageIconSVG(
                                    imageName: widget.pSvgIcon!,
                                    color:
                                        widget.pIconColor ?? activationColor(),
                                    height: 20.h,
                                    width: 20.w,
                                  ),
                                )
                              : const SizedBox()),
                  suffixIcon: widget.sufWidget != null
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: widget.sufWidget)
                      : (widget.sufAssetIcon != null
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Image.asset(
                                widget.sufAssetIcon!,
                                height: 20.h,
                                width: 20.w,
                                color: widget.sIconColor ?? activationColor(),
                              ),
                            )
                          : widget.sufSvgIcon != null
                              ? Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  child: customImageIconSVG(
                                    imageName: widget.sufSvgIcon!,
                                    color:
                                        widget.sIconColor ?? activationColor(),
                                    height: 20.h,
                                    width: 20.w,
                                  ),
                                )
                              : widget.isPassword == true
                                  ? IconButton(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      onPressed: _visibility,
                                      alignment: Alignment.center,
                                      icon: _isHidden
                                          ? customImageIconSVG(
                                              imageName:
                                                  SvgImages.hiddenEyeIcon,
                                              height: 16.55.h,
                                              width: 19.59.w,
                                              color: const Color(0xFF8B97A3),
                                            )
                                          : customImageIconSVG(
                                              imageName: SvgImages.eyeIcon,
                                              height: 16.55.h,
                                              width: 19.59.w,
                                              color: Styles.PRIMARY_COLOR,
                                            ),
                                    )
                                  : null),
                  prefixIconConstraints: BoxConstraints(maxHeight: 25.h),
                  suffixIconConstraints: BoxConstraints(maxHeight: 25.h),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                ),
              ),
            ),
          ),
          if (widget.customError == true &&
              widget.errorText != null &&
              widget.errorText != "")
            CustomErrorWidget(error: widget.errorText),
        ],
      ),
    );
  }
}
