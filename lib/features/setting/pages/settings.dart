import 'package:flutter/material.dart';
import 'package:zurex/app/localization/language_constant.dart';
import 'package:zurex/components/animated_widget.dart';
import 'package:zurex/components/custom_app_bar.dart';
import 'package:zurex/features/setting/widgets/settings_button.dart';

import '../../../app/core/svg_images.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated("settings"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListAnimator(
              data: [
                SettingsButton(
                  title: getTranslated("contact_with_us", context: context),
                  icon: SvgImages.contactWithUs,
                  onTap: () => CustomNavigator.push(Routes.contactWithUs),
                ),
                SettingsButton(
                  title: getTranslated("terms_conditions", context: context),
                  icon: SvgImages.terms,
                  onTap: () => CustomNavigator.push(Routes.terms),
                ),
                SettingsButton(
                  title: getTranslated("privacy_policy", context: context),
                  icon: SvgImages.info,
                  onTap: () => CustomNavigator.push(Routes.privacy),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
