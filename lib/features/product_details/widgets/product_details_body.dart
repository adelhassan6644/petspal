import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/app/core/extensions.dart';
import 'package:petspal/components/shimmer/custom_shimmer.dart';
import 'package:petspal/features/products/widgets/price_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_network_image.dart';
import '../../../components/empty_widget.dart';
import '../bloc/product_details_bloc.dart';
import '../model/product_details_model.dart';

class ProductDetailsBody extends StatelessWidget {
  const ProductDetailsBody({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ProductDetailsBloc, AppState>(
        builder: (context, state) {
          if (state is Done) {
            ProductDetailsModel model = state.model as ProductDetailsModel;
            return ListAnimator(
              customPadding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
              ),
              data: [
                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),

                ///Product Image
                CustomNetworkImage.containerNewWorkImage(
                    width: context.width,
                    height: context.height * 0.25,
                    radius: 12.w,
                    image: model.product?.image ?? ""),

                ///Product Name
                Padding(
                  padding: EdgeInsets.only(
                    top: Dimensions.PADDING_SIZE_DEFAULT.h,
                  ),
                  child: Text(
                    model.product?.name ?? "",
                    style: AppTextStyles.w600
                        .copyWith(fontSize: 22, color: Styles.HEADER),
                  ),
                ),

                ///Product Price
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeMini.h),
                  child: PriceCard(
                    price: model.product?.price,
                    priceAfterDiscount: model.product?.priceAfter,
                  ),
                ),

                ///Product Description
                ReadMoreText(
                  model.product?.description ?? "",
                  style: AppTextStyles.w400
                      .copyWith(fontSize: 16, color: Styles.DETAILS_COLOR),
                  trimLines: 2,
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: getTranslated("show_more"),
                  trimExpandedText: getTranslated("show_less"),
                  textAlign: TextAlign.start,
                  moreStyle: AppTextStyles.w600
                      .copyWith(fontSize: 14, color: Styles.PRIMARY_COLOR),
                  lessStyle: AppTextStyles.w600
                      .copyWith(fontSize: 14, color: Styles.PRIMARY_COLOR),
                ),

                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
              ],
            );
          }
          if (state is Loading) {
            return ListAnimator(
              customPadding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
              ),
              data: [
                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),

                ///Product Image
                CustomShimmerContainer(
                  width: context.width,
                  height: context.height * 0.25,
                  radius: 12.w,
                ),

                ///Product Name
                Padding(
                  padding: EdgeInsets.only(
                    top: Dimensions.PADDING_SIZE_DEFAULT.h,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: Dimensions.PADDING_SIZE_DEFAULT.h,
                            bottom: Dimensions.paddingSizeMini.h),
                        child: CustomShimmerText(
                          width: context.width * 0.6,
                          height: 22.h,
                        ),
                      ),
                    ],
                  ),
                ),

                ///Product Price
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeMini.h),
                  child: CustomShimmerText(
                    width: context.width * 0.6,
                    height: 22.h,
                  ),
                ),

                ///Product Description
                ...List.generate(
                  5,
                  (i) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: CustomShimmerText(
                      width: context.width,
                      height: 14.h,
                    ),
                  ),
                ),

                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
              ],
            );
          }
          if (state is Error || state is Empty) {
            return RefreshIndicator(
              color: Styles.PRIMARY_COLOR,
              onRefresh: () async {
                context.read<ProductDetailsBloc>().add(Click(arguments: id));
              },
              child: Column(
                children: [
                  Expanded(
                    child: ListAnimator(
                      customPadding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                      ),
                      data: [
                        SizedBox(
                          height: 50.h,
                        ),
                        EmptyState(
                          txt: getTranslated("no_result_found"),
                          subText: state is Error
                              ? getTranslated("something_went_wrong")
                              : getTranslated("no_result_found_description"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
