import 'package:zurex/app/localization/language_constant.dart';
import 'package:zurex/components/animated_widget.dart';
import 'package:zurex/components/custom_app_bar.dart';
import 'package:zurex/features/check_out/repo/check_out_request_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/config/di.dart';
import '../bloc/check_out_bloc.dart';
import '../bloc/coupon_bloc.dart';
import '../widgets/check_out_button.dart';
import '../widgets/coupon.dart';
import '../widgets/payment_method.dart';
import '../widgets/receipt_details.dart';

class CheckOutRequestPage extends StatelessWidget {
  const CheckOutRequestPage({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated("check_out"),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CheckOutBloc(repo: sl<CheckOutRequestRepo>()),
          ),
          BlocProvider(
            create: (context) => CouponBloc(repo: sl<CheckOutRequestRepo>()),
          ),
        ],
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListAnimator(
                  data: [
                    ///Payment Method
                    const PaymentMethod(),

                    ///Coupon
                    Coupon(
                      id: 1,
                      isOrder: true,
                    ),

                    ReceiptDetails()
                  ],
                ),
              ),
              CheckOutButton(
                id: 0,
                onSuccess: data["onSuccess"],
                isOrder: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
