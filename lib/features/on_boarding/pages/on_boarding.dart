import 'package:flutter/material.dart';
import 'package:petspal/app/core/extensions.dart';

import '../../../app/core/dimensions.dart';
import '../../../app/core/images.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/step_button.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';
import '../../language/page/language_button_icon.dart';
import '../widgets/step_widget.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  nextPage() {
    pageController.animateToPage(pageController.page!.toInt() + 1,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    currentIndex = pageController.page!.toInt();
  }

  List<String> images = [
    Images.onBoarding1,
    Images.onBoarding2,
    Images.onBoarding3,
  ];

  List<String> titles = [
    "on_boarding_header_1",
    "on_boarding_header_2",
    "on_boarding_header_3",
  ];
  List<String> descriptions = [
    "on_boarding_description_1",
    "on_boarding_description_2",
    "on_boarding_description_3",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  onPageChanged: ((index) => setState(() {
                        currentIndex = index;
                      })),
                  itemBuilder: (_, i) => Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: context.height,
                        width: context.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: AssetImage(images[i]),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: context.toPadding,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ///title
                            Text(
                              getTranslated(titles[i], context: context),
                              textAlign: TextAlign.center,
                              style: AppTextStyles.w900.copyWith(
                                  fontSize: 24, color: Styles.WHITE_COLOR),
                            ),
                            SizedBox(height: 12.h),

                            ///description
                            Text(
                              getTranslated(descriptions[i], context: context),
                              textAlign: TextAlign.center,
                              style: AppTextStyles.w600.copyWith(
                                  fontSize: 14, color: Styles.WHITE_COLOR),
                            ),
                            SizedBox(height: 30.h),
                            StepPointWidget(
                                currentIndex: currentIndex,
                                length: titles.length),
                            SizedBox(height: 120.h + context.bottom),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ///Language Button
                            const LanguageButtonIcon(),

                            ///Skip Button
                            if (currentIndex != 2)
                              InkWell(
                                onTap: () => CustomNavigator.push(Routes.login,
                                    clean: true),
                                child: Text(
                                  getTranslated("skip", context: context),
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.w300.copyWith(
                                      fontSize: 16,
                                      height: 1,
                                      color: Styles.WHITE_COLOR),
                                ),
                              ),
                          ],
                        ),
                        const Spacer(),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              if (currentIndex < 2) {
                                setState(() {
                                  nextPage();
                                });
                              } else {
                                CustomNavigator.push(Routes.login, clean: true);
                              }
                            },
                            child: SizedBox(
                              height: 80,
                              width: 80,
                              child: StepButton(
                                value: ((currentIndex + 1) / 3),
                                backgroundColor: Styles.SMOKED_WHITE_COLOR,
                                foregroundColor: Styles.PRIMARY_COLOR,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///Button Text
  String buttonText(index) {
    switch (index) {
      case 0:
        return "next";
      case 1:
        return "next";
      case 2:
        return "login";
      default:
        return "next";
    }
  }

  ///Button function
  dynamic buttonFunction(index) {
    switch (index) {
      case 0:
        return nextPage();
      case 1:
        return nextPage();
      case 2:
        return CustomNavigator.push(Routes.login, clean: true);
      default:
        return nextPage();
    }
  }
}
