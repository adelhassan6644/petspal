import 'package:petspal/app/core/text_styles.dart';
import 'package:petspal/app/localization/language_constant.dart';
import 'package:petspal/components/animated_widget.dart';
import 'package:petspal/features/check_out/bloc/check_out_bloc.dart';
import 'package:petspal/features/check_out/bloc/coupon_bloc.dart';
import 'package:petspal/features/check_out/repo/check_out_product_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../data/config/di.dart';
import '../model/price_details_model.dart';
import '../widgets/check_out_button.dart';
import '../widgets/coupon.dart';
import '../widgets/receipt_details.dart';

class CheckOutProductView extends StatelessWidget {
  const CheckOutProductView(
      {super.key,
      required this.id,
      this.priceDetailsModel,
      required this.type});

  final int id;
  final CheckOutProductType type;
  final PriceDetailsModel? priceDetailsModel;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CheckOutBloc(repo: sl<CheckOutProductRepo>()),
        ),
        BlocProvider(
          create: (context) => CouponBloc(repo: sl<CheckOutProductRepo>()),
        ),
      ],
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 4.h,
            margin: EdgeInsets.only(
              left: Dimensions.PADDING_SIZE_DEFAULT.w,
              right: Dimensions.PADDING_SIZE_DEFAULT.w,
              top: Dimensions.paddingSizeMini.h,
              bottom: Dimensions.PADDING_SIZE_DEFAULT.h,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Styles.HINT_COLOR,
                borderRadius: BorderRadius.circular(100)),
          ),

          ///Title
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
            child: Text(
              getTranslated("check_out"),
              style: AppTextStyles.w600
                  .copyWith(fontSize: 18, color: Styles.HEADER),
            ),
          ),

          ///Body
          Expanded(
              child: ListAnimator(
            data: [
              ///Coupon
              Coupon(
                id: id,
                isOrder: false,
              ),

              ///Receipt Details
              BlocBuilder<CouponBloc, AppState>(
                builder: (context, state) {
                  if (state is Done) {
                    PriceDetailsModel model = state.model as PriceDetailsModel;
                    return ReceiptDetails(priceDetails: model);
                  } else {
                    return ReceiptDetails(priceDetails: priceDetailsModel);
                  }
                },
              ),
            ],
          )),

          ///Action
          CheckOutButton(
            id: id,
            type: type,
            isOrder: false,
          ),
          SizedBox(height: Dimensions.paddingSizeMini.h),
        ],
      ),
    );
  }
}
