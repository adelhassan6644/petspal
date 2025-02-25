import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/core/dimensions.dart';
import '../app/core/app_state.dart';
import '../app/core/styles.dart';
import '../app/core/svg_images.dart';
import '../app/core/text_styles.dart';
import '../components/custom_bottom_sheet.dart';
import '../components/custom_images.dart';
import '../features/cart/bloc/cart_bloc.dart';
import '../main_blocs/user_bloc.dart';
import '../main_widgets/guest_mode.dart';
import '../navigation/custom_navigation.dart';
import '../navigation/routes.dart';

class CustomCartIcon extends StatelessWidget {
  const CustomCartIcon({super.key, this.fomCart = false});
  final bool fomCart;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, AppState>(
      builder: (context, state) {
        return Badge(
          smallSize: 10,
          largeSize: 20,
          isLabelVisible: state is Done ? true : false,
          label: Text(
            "${state is Done ? state.list?.length ?? 0 : 0}",
            style: AppTextStyles.w400
                .copyWith(color: Styles.WHITE_COLOR, fontSize: 12),
          ),
          child: customContainerSvgIcon(
              onTap: () {
                if (UserBloc.instance.isLogin) {
                  fomCart
                      ? CustomNavigator.pop()
                      : CustomNavigator.push(Routes.cart);
                } else {
                  CustomBottomSheet.show(widget: const GuestMode());
                }
              },
              width: 40.w,
              height: 40.w,
              radius: 16.w,
              padding: 10.w,
              backGround: Styles.WHITE_COLOR,
              color: Styles.PRIMARY_COLOR,
              imageName: SvgImages.cart),
        );
      },
    );
  }
}
