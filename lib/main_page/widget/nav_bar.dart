import 'package:flutter/material.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/app/core/extensions.dart';
import 'package:zurex/app/localization/language_constant.dart';
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
                      offset: const Offset(0, -2),
                      spreadRadius: 2,
                      blurRadius: 20)
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: (snapshot.data ?? 0) == 0 ? 3 : 2,
                        child: BottomNavBarItem(
                            label: getTranslated("home", context: context),
                            svgIcon: SvgImages.homeIcon,
                            isSelected: (snapshot.data ?? 0) == 0,
                            onTap: () {
                              DashboardBloc.instance.updateSelectIndex(0);
                            }),
                      ),
                      Expanded(
                        flex: (snapshot.data ?? 0) == 1 ? 3 : 2,
                        child: BottomNavBarItem(
                          label: getTranslated("my_cars", context: context),
                          svgIcon: SvgImages.car,
                          isSelected: (snapshot.data ?? 0) == 1,
                          onTap: () {
                            DashboardBloc.instance.updateSelectIndex(1);
                          },
                        ),
                      ),
                      Expanded(
                        flex: (snapshot.data ?? 0) == 2 ? 3 : 2,
                        child: BottomNavBarItem(
                            label: getTranslated("requests", context: context),
                            svgIcon: SvgImages.requests,
                            isSelected: (snapshot.data ?? 0) == 2,
                            onTap: () {
                              DashboardBloc.instance.updateSelectIndex(2);
                            }),
                      ),
                      Expanded(
                        flex: (snapshot.data ?? 0) == 3 ? 3 : 2,
                        child: BottomNavBarItem(
                          label: getTranslated("more", context: context),
                          svgIcon: SvgImages.setting,
                          isSelected: (snapshot.data ?? 0) == 3,
                          onTap: () {
                            DashboardBloc.instance.updateSelectIndex(3);
                          },
                        ),
                      ),
                    ]),
              ));
        });
  }
}
