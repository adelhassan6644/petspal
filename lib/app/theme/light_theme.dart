import 'package:flutter/material.dart';
import '../core/app_strings.dart';
import '../core/dimensions.dart';
import '../core/styles.dart';
import '../core/text_styles.dart';

ThemeData light(fontFamily) => ThemeData(
      fontFamily: fontFamily,
      useMaterial3: true,
      primaryColor: Styles.PRIMARY_COLOR,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
          primary: Styles.PRIMARY_COLOR, secondary: Styles.PRIMARY_COLOR),
      scaffoldBackgroundColor: Colors.white,
      focusColor: const Color(0xFFADC4C8),
      hintColor: Styles.HINT_COLOR,
      disabledColor: Styles.DISABLED,
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
        textStyle: AppTextStyles.w400.copyWith(
          color: Styles.WHITE_COLOR,
        ),
      )),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        },
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
            color: Styles.PRIMARY_COLOR,
            fontSize: 25,
            fontFamily: AppStrings.arFontFamily),
      ),
      textTheme: const TextTheme(
        labelLarge: TextStyle(color: Styles.PRIMARY_COLOR),
        displayLarge: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: Dimensions.FONT_SIZE_DEFAULT,
          fontFamily: AppStrings.arFontFamily,
        ),
        displayMedium: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: Dimensions.FONT_SIZE_DEFAULT,
          fontFamily: AppStrings.arFontFamily,
        ),
        displaySmall: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: Dimensions.FONT_SIZE_DEFAULT,
          fontFamily: AppStrings.arFontFamily,
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: Dimensions.FONT_SIZE_DEFAULT,
          fontFamily: AppStrings.arFontFamily,
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: Dimensions.FONT_SIZE_DEFAULT,
          fontFamily: AppStrings.arFontFamily,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: Dimensions.FONT_SIZE_DEFAULT,
          fontFamily: AppStrings.arFontFamily,
        ),
        bodySmall: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: Dimensions.FONT_SIZE_DEFAULT,
          fontFamily: AppStrings.arFontFamily,
        ),
        titleMedium: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          fontFamily: AppStrings.arFontFamily,
        ),
        bodyMedium: TextStyle(fontSize: 12.0),
        bodyLarge: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          fontFamily: AppStrings.arFontFamily,
        ),
      ),
    );
