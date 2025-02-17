import 'package:zurex/app/core/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/features/categories/view/categories_tab_bar.dart';

import '../../../app/core/app_event.dart';
import '../../../main_models/search_engine.dart';
import '../bloc/products_bloc.dart';
import 'products_filter_bar.dart';

class ProductsHeader extends StatelessWidget {
  const ProductsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Product Filter Bar
          const ProductsFilterBar(),

          ///Category Filter
          BlocBuilder<ProductsBloc, AppState>(
            builder: (context, state) {
              return StreamBuilder<int?>(
                  stream: context.read<ProductsBloc>().selectCategoryStream,
                  builder: (context, snapshot) {
                    return CategoriesTabBar(
                      selectedValue: snapshot.data,
                      onSelect: (v) {
                        if (context.read<ProductsBloc>().state is! Loading) {
                          context.read<ProductsBloc>().updateSelectCategory(v);
                          context
                              .read<ProductsBloc>()
                              .add(Click(arguments: SearchEngine()));
                        }
                      },
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}
