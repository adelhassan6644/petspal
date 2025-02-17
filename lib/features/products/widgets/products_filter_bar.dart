import 'dart:async';
import 'package:petspal/app/core/extensions.dart';
import 'package:petspal/features/products/bloc/products_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/app/core/svg_images.dart';
import 'package:petspal/app/localization/language_constant.dart';
import 'package:petspal/components/custom_text_form_field.dart';
import 'package:petspal/main_models/search_engine.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../categories/view/categories_view.dart';

class ProductsFilterBar extends StatefulWidget {
  const ProductsFilterBar({super.key});

  @override
  State<ProductsFilterBar> createState() => _ProductsFilterBarState();
}

class _ProductsFilterBarState extends State<ProductsFilterBar> {
  Timer? timer;

  @override
  void initState() {
    context.read<ProductsBloc>().searchTEC = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, AppState>(builder: (context, state) {
      return StreamBuilder(
        stream: context.read<ProductsBloc>().goingDownStream,
        builder: (context, snapshot) {
          return AnimatedCrossFade(
              crossFadeState: snapshot.data == true
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 400),
              firstChild: SizedBox(width: context.width),
              secondChild: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                ),
                child: CustomTextField(
                  hint: getTranslated("search_hint"),
                  controller: context.read<ProductsBloc>().searchTEC,
                  pSvgIcon: SvgImages.search,
                  withLabel: false,
                  onChanged: (v) {
                    if (timer != null) if (timer!.isActive) timer!.cancel();
                    timer = Timer(
                      const Duration(milliseconds: 400),
                          () {
                        context
                            .read<ProductsBloc>()
                            .add(Click(arguments: SearchEngine()));
                      },
                    );
                  },
                  onSubmit: (v) {
                    context
                        .read<ProductsBloc>()
                        .add(Click(arguments: SearchEngine()));
                  },
                ),
              ),);
        },
      );
    });
  }
}
