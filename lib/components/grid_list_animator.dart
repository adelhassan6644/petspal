import 'package:flutter/cupertino.dart';
import '../app/core/dimensions.dart';

class GridListAnimatorWidget extends StatelessWidget {
  const GridListAnimatorWidget(
      {this.aspectRatio,
      required this.items,
      super.key,
      this.columnCount,
      this.padding,
      this.controller});
  final List<Widget> items;
  final double? aspectRatio;
  final EdgeInsetsGeometry? padding;
  final int? columnCount;
  final ScrollController? controller;
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: padding ?? EdgeInsets.only(top: 20.h),
      crossAxisCount: columnCount ?? 2,
      controller: controller,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      addAutomaticKeepAlives: true,
      mainAxisSpacing: 16.h,
      childAspectRatio: aspectRatio ?? 0.9,
      crossAxisSpacing: 16.w,
      children: items,
    );
  }
}
