import 'package:petspal/app/localization/language_constant.dart';
import 'package:petspal/features/categories/bloc/categories_bloc.dart';
import 'package:petspal/features/categories/repo/categories_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../data/internet_connection/internet_connection.dart';
import '../model/categories_model.dart';

class CategoriesTabBar extends StatelessWidget {
  const CategoriesTabBar(
      {super.key, required this.onSelect, this.selectedValue});

  final Function(int?) onSelect;
  final int? selectedValue;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, AppState>(
      builder: (context, state) {
        if (state is Done) {
          List<CategoryModel> data = state.list as List<CategoryModel>;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.PADDING_SIZE_SMALL.h),
            child: Row(
              children: [
                SizedBox(width: Dimensions.paddingSizeExtraSmall.w),
                ...List.generate(data.length, (i) {
                  context
                      .read<CategoriesBloc>()
                      .globalKeys
                      .add(GlobalKey(debugLabel: "$i"));
                  if (data[i].id == selectedValue) {
                    context.read<CategoriesBloc>().animatedRowScroll(i);
                  }
                  return InkWell(
                    key: context.read<CategoriesBloc>().globalKeys[i],
                    onTap: () => onSelect.call(data[i].id),
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: data[i].id == selectedValue
                            ? Styles.PRIMARY_COLOR
                            : Styles.PRIMARY_COLOR.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      margin: EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeMini.w),
                      padding: EdgeInsets.symmetric(
                          horizontal: 22.w, vertical: 6.h),
                      child: Text(
                        data[i].name == "all"
                            ? getTranslated("all")
                            : data[i].name ?? "",
                        style: AppTextStyles.w600.copyWith(
                            fontSize: 14,
                            color: data[i].id == selectedValue
                                ? Styles.WHITE_COLOR
                                : Styles.PRIMARY_COLOR),
                      ),
                    ),
                  );
                })
              ],
            ),
          );
        }
        if (state is Loading) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.PADDING_SIZE_SMALL.h),
            child: Row(
              children: [
                SizedBox(width: Dimensions.paddingSizeExtraSmall.w),
                ...List.generate(
                  8,
                      (i) => Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeMini.w),
                    child: CustomShimmerContainer(
                      width: 100.w,
                      height: 35,
                      radius: 100,
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
