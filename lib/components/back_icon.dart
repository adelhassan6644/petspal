import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:zurex/navigation/custom_navigation.dart';
import '../app/core/styles.dart';

class FilteredBackIcon extends StatelessWidget {
  const FilteredBackIcon({super.key, this.onTap});
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call() ?? CustomNavigator.pop(),
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(100)),
            child: const Icon(
              Icons.arrow_back,
              size: 20,
              color: Styles.PRIMARY_COLOR,
            ),
          ),
        ),
      ),
    );
  }
}
