import 'package:zurex/app/core/app_state.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/app/core/svg_images.dart';
import 'package:zurex/app/localization/language_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../components/custom_text_form_field.dart';
import '../bloc/coupon_bloc.dart';

class Coupon extends StatelessWidget {
  const Coupon({super.key, this.id, required this.isOrder});
  final int? id;
  final bool isOrder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
      child: BlocBuilder<CouponBloc, AppState>(
        builder: (context, state) {
          return Column(
            children: [
              StreamBuilder<String?>(
                  stream: context.read<CouponBloc>().couponStream,
                  builder: (context, snapshot) {
                    return Column(
                      children: [
                        CustomTextField(
                          hint: getTranslated("enter_coupon"),
                          pSvgIcon: SvgImages.voucher,
                          onChanged: (v) {
                            context.read<CouponBloc>().updateCoupon(v);
                            if (v.isEmpty || v == "") {
                              context.read<CouponBloc>().add(Update());
                            }
                          },
                          controller: context.read<CouponBloc>().couponTEC,
                          sufWidget: InkWell(
                            onTap: () {
                              if ((state is Done || state is Error) &&
                                  (snapshot.hasData &&
                                      snapshot.data!.isNotEmpty)) {
                                context.read<CouponBloc>().add(Update());
                              } else {
                                if (context
                                    .read<CouponBloc>()
                                    .couponTEC
                                    .text
                                    .isNotEmpty) {
                                  context
                                      .read<CouponBloc>()
                                      .add(Click(arguments: id));
                                }
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                state is Loading
                                    ? const SpinKitThreeBounce(
                                        color: Styles.PRIMARY_COLOR,
                                        size: 18,
                                      )
                                    : Text(
                                        getTranslated(((state is Done ||
                                                    state is Error) &&
                                                (snapshot.hasData &&
                                                    snapshot.data!.isNotEmpty))
                                            ? "cancel"
                                            : "apply"),
                                        style: AppTextStyles.w600.copyWith(
                                            fontSize: 13,
                                            color: (snapshot.hasData &&
                                                    snapshot.data!.isNotEmpty)
                                                ? Styles.PRIMARY_COLOR
                                                : Styles.HINT_COLOR),
                                      )
                              ],
                            ),
                          ),
                        ),
                        if ((state is Done || state is Error) &&
                            (snapshot.hasData && snapshot.data!.isNotEmpty))
                          Row(
                            children: [
                              if (state is Error)
                                const Icon(
                                  Icons.error,
                                  size: 18,
                                  color: Styles.IN_ACTIVE,
                                ),
                              if (state is Done)
                                const Icon(
                                  Icons.check_circle,
                                  size: 18,
                                  color: Styles.ACTIVE,
                                ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  getTranslated(state is Done
                                      ? "coupon_applied_successfully"
                                      : "coupon_is_not_valid"),
                                  style: AppTextStyles.w400.copyWith(
                                    fontSize: 13,
                                    color: (state is Done
                                        ? Styles.ACTIVE
                                        : Styles.IN_ACTIVE),
                                  ),
                                ),
                              )
                            ],
                          )
                      ],
                    );
                  }),
            ],
          );
        },
      ),
    );
  }
}
