import 'dart:developer';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/components/custom_images.dart';
import 'package:petspal/navigation/custom_navigation.dart';
import '../app/core/styles.dart';
import '../app/core/svg_images.dart';
import '../data/config/di.dart';
import '../features/language/bloc/language_bloc.dart';

class FilteredBackIcon extends StatelessWidget {
  const FilteredBackIcon({super.key, this.onTap});
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: sl<LanguageBloc>().isLtr ? 0 : 2,
      child: customContainerSvgIcon(
        onTap: () {
          CustomNavigator.pop();
        },
        imageName: SvgImages.backArrow,
        width: 40.w,
        height: 40.w,
        padding: 10.w,
        radius: 16.w,
        backGround: Styles.WHITE_COLOR,
        borderColor: Color(0xFFFFF6F1),
        color: Color(0xFF7E8AA3),
      ),
    );
  }
}
