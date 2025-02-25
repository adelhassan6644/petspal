import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/features/vendors/bloc/vendors_bloc.dart';
import 'package:petspal/features/vendors/model/vendors_model.dart';
import 'package:petspal/features/vendors/repo/vendors_repo.dart';
import 'package:petspal/main_widgets/section_title.dart';
import 'package:petspal/navigation/custom_navigation.dart';
import 'package:petspal/navigation/routes.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';

import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../data/internet_connection/internet_connection.dart';
import 'vendor_card.dart';

class VendorsSection extends StatelessWidget {
  const VendorsSection({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          title: title,
          withView: true,
          onViewTap: () => CustomNavigator.push(Routes.vendors),
        ),
        BlocProvider(
          create: (context) => VendorsBloc(
              repo: sl<VendorsRepo>(),
              internetConnection: sl<InternetConnection>()),
          // ..add(Click(arguments: SearchEngine())),
          child: BlocBuilder<VendorsBloc, AppState>(
            builder: (context, state) {
              if (state is Done) {
                List<VendorModel> list = state.list as List<VendorModel>;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      SizedBox(width: Dimensions.paddingSizeExtraSmall.w),
                      ...List.generate(
                        list.length,
                        (i) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: VendorCard(
                            model: list[i],
                          ),
                        ),
                      )
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
                        5,
                        (i) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: CustomShimmerContainer(
                            height: 130.w,
                            width: 160.w,
                            radius: 20.w,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      SizedBox(width: Dimensions.paddingSizeExtraSmall.w),
                      ...List.generate(
                        5,
                        (i) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: VendorCard(
                            model: VendorModel(),
                          ),
                        ),
                      )
                    ],
                  ),
                );
                return SizedBox();
              }
            },
          ),
        ),
      ],
    );
  }
}
