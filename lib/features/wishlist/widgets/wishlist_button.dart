import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/features/products/model/products_model.dart';
import 'package:petspal/features/wishlist/bloc/wishlist_bloc.dart';
import '../../../app/core/app_core.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/svg_images.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_images.dart';
import '../../../data/config/di.dart';
import '../../../main_blocs/user_bloc.dart';

class WishlistButton extends StatelessWidget {
  final ProductModel? product;
  final double size;
  const WishlistButton({super.key, this.product, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistBloc, AppState>(
      builder: (context, state) {
        bool isFav = false;
        if (state is Done) {
          List<ProductModel> products = state.list as List<ProductModel>;
          isFav = products
                  .map((e) => e.id)
                  .toList()
                  .indexWhere((e) => e == product?.id) !=
              -1;
        }
        return customImageIconSVG(
            onTap: () {
              if (UserBloc.instance.isLogin) {
                sl<WishlistBloc>().add(Update(arguments: {
                  "isFav": isFav,
                  "product": product,
                }));
              } else {
                AppCore.showToast(getTranslated("you_have_to_login_first"));
              }
            },
            width: size.w,
            height: size.w,
            // backGround: Colors.black.withOpacity(0.1),
            color: isFav ? Styles.ERORR_COLOR : Styles.HINT_COLOR,
            imageName: isFav ? SvgImages.fillFav : SvgImages.fav);
      },
    );
  }
}
