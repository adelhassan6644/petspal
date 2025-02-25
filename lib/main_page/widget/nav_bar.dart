import 'package:flutter/material.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/app/core/extensions.dart';
import 'package:petspal/app/localization/language_constant.dart';
import '../../app/core/styles.dart';
import '../../app/core/svg_images.dart';
import '../bloc/dashboard_bloc.dart';
import 'nav_bar_item.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: DashboardBloc.instance.selectIndexStream,
        builder: (context, snapshot) {
          return Container(
            width: context.width,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
                color: Styles.WHITE_COLOR,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      offset: const Offset(0, -1),
                      spreadRadius: 1,
                      blurRadius: 10)
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            child: SafeArea(
              top: false,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: BottomNavBarItem(
                        label: getTranslated("home", context: context),
                        svgIcon: SvgImages.homeIcon,
                        isSelected: (snapshot.data ?? 0) == 0,
                        onTap: () {
                          DashboardBloc.instance.updateSelectIndex(0);
                        }),
                  ),
                  Expanded(
                    child: BottomNavBarItem(
                      label: getTranslated("marketplace", context: context),
                      svgIcon: SvgImages.marketplace,
                      isSelected: (snapshot.data ?? 0) == 1,
                      onTap: () {
                        DashboardBloc.instance.updateSelectIndex(1);
                      },
                    ),
                  ),
                  Expanded(
                    child: BottomNavBarItem(
                        label: getTranslated("petsgram", context: context),
                        svgIcon: SvgImages.petsgram,
                        isSelected: (snapshot.data ?? 0) == 2,
                        onTap: () {
                          DashboardBloc.instance.updateSelectIndex(2);
                        }),
                  ),
                  Expanded(
                    child: BottomNavBarItem(
                        label: getTranslated("orders", context: context),
                        svgIcon: SvgImages.orders,
                        isSelected: (snapshot.data ?? 0) == 3,
                        onTap: () {
                          DashboardBloc.instance.updateSelectIndex(3);
                        }),
                  ),
                  Expanded(
                    child: BottomNavBarItem(
                      label: getTranslated("more", context: context),
                      svgIcon: SvgImages.settings,
                      isSelected: (snapshot.data ?? 0) == 4,
                      onTap: () {
                        DashboardBloc.instance.updateSelectIndex(4);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
