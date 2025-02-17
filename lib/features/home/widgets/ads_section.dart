import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/app/core/app_state.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/app/core/extensions.dart';
import 'package:zurex/components/shimmer/custom_shimmer.dart';
import 'package:zurex/features/home/model/ads_model.dart';

import '../../../app/core/styles.dart';
import '../../../components/custom_network_image.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';
import '../bloc/home_ads_bloc.dart';

class AdsSection extends StatelessWidget {
  const AdsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeAdsBloc, AppState>(
      builder: (context, state) {
        if (state is Done) {
          AdsModel model = state.model as AdsModel;
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CarouselSlider.builder(
                options: CarouselOptions(
                  height: 175.h,
                  disableCenter: true,
                  pageSnapping: true,
                  autoPlay: true,
                  aspectRatio: 1,
                  viewportFraction: 0.8,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    context.read<HomeAdsBloc>().updateIndex(index);
                  },
                ),
                disableGesture: true,
                itemCount: model.data?.length ?? 0,
                itemBuilder: (context, index, _) {
                  return CustomNetworkImage.containerNewWorkImage(
                    // onTap: () => CustomNavigator.push(Routes.talents,
                    //     arguments: model.data?[index].expertise),
                    image: model.data?[index].image ?? "",
                    height: 175.h,
                    width: context.width,
                    radius: 24.w,
                    fit: BoxFit.cover,
                  );
                },
                carouselController:
                    context.read<HomeAdsBloc>().bannerController,
              ),
              Positioned(
                bottom: 8,
                child: StreamBuilder(
                    stream: context.read<HomeAdsBloc>().indexStream,
                    builder: (_, snapshot) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          model.data?.length ?? 0,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: EdgeInsets.symmetric(horizontal: 2.w),
                            decoration: BoxDecoration(
                              color: index == snapshot.data
                                  ? Styles.PRIMARY_COLOR
                                  : Styles.WHITE_COLOR,
                              borderRadius: BorderRadius.circular(100.w),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          );
        }
        if (state is Loading) {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
            child: CustomShimmerContainer(
              height: 175.h,
              width: context.width,
              radius: 24.w,
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
