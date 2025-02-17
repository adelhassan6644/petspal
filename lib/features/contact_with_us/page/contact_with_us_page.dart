import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/app/core/svg_images.dart';
import 'package:petspal/app/core/text_styles.dart';
import 'package:petspal/components/custom_images.dart';
import '../../../app/core/images.dart';
import '../../../app/core/styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_app_bar.dart';
import '../../../data/config/di.dart';
import '../../setting/bloc/setting_bloc.dart';

class ContactWithUsPage extends StatelessWidget {
  const ContactWithUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated("contact_with_us"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
            vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
                  child: customImageIcon(
                      imageName: Images.logo, width: 220.w, height: 70.h)),
            ),
            Text(
              getTranslated("contact_with_us_description"),
              textAlign: TextAlign.start,
              style: AppTextStyles.w600
                  .copyWith(fontSize: 16, color: Styles.HEADER),
            ),
            SizedBox(height: 24.h),
            Text(
              getTranslated("contact_with_us_via"),
              textAlign: TextAlign.start,
              style: AppTextStyles.w400
                  .copyWith(fontSize: 14, color: Styles.DETAILS_COLOR),
            ),
            SizedBox(height: 12.h),
            Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                runSpacing: 12.h,
                spacing: 16.w,
                children: [
                  // if (sl<SettingBloc>().model?.social?.phone != null)
                  customContainerSvgIcon(
                      onTap: () => launchUrl(
                          Uri.parse(
                              "tel://${sl<SettingBloc>().model?.social?.phone}"),
                          mode: LaunchMode.externalApplication),
                      imageName: SvgImages.phoneCallIcon,
                      backGround: Styles.PRIMARY_COLOR,
                      color: Styles.WHITE_COLOR,
                      width: 50.w,
                      height: 50.w,
                      padding: 12.w,
                      radius: 100.w),
                  SizedBox(width: 16.w),
                  // if (sl<SettingBloc>().model?.social?.mail != null)
                  customContainerSvgIcon(
                      onTap: () => launchUrl(
                          Uri.parse(
                              "mailto:${sl<SettingBloc>().model?.social?.mail ?? "petspal@gmail.com"}"),
                          mode: LaunchMode.externalApplication),
                      imageName: SvgImages.mail,
                      backGround: Styles.PRIMARY_COLOR,
                      color: Styles.WHITE_COLOR,
                      width: 50.w,
                      height: 50.w,
                      padding: 12.w,
                      radius: 100.w),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Divider(
                    color: Styles.HINT_COLOR,
                    height: 12.h,
                  )),
                  Text(
                    "  ${getTranslated("or")}  ",
                    style: AppTextStyles.w500
                        .copyWith(fontSize: 14, color: Styles.HINT_COLOR),
                  ),
                  Expanded(
                      child: Divider(
                    color: Styles.HINT_COLOR,
                    height: 12.h,
                  )),
                ],
              ),
            ),
            Text(
              "${getTranslated("contact_with_us_via")} ${getTranslated("social_media")}",
              textAlign: TextAlign.start,
              style: AppTextStyles.w400
                  .copyWith(fontSize: 14, color: Styles.DETAILS_COLOR),
            ),
            SizedBox(height: 16.h),
            Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                runSpacing: 12.h,
                spacing: 12.w,
                children: [
                  // if (sl<SettingBloc>().model?.social?.whatsApp != null)
                  customImageIcon(
                      imageName: Images.whatsApp,
                      width: 50.w,
                      height: 50.w,
                      onTap: () async {
                        launchUrl(
                          Uri.parse(
                            'whatsapp://send?phone=${sl<SettingBloc>().model?.social?.whatsApp}',
                          ),
                        );
                      }),
                  // if (sl<SettingBloc>().model?.social?.tiktok != null)
                  customImageIcon(
                    imageName: Images.tiktok,
                    width: 50.w,
                    height: 50.w,
                    onTap: () async {
                      launchUrl(
                          Uri.parse(
                              sl<SettingBloc>().model?.social?.tiktok ?? ""),
                          mode: LaunchMode.externalApplication);
                    },
                  ),
                  // if (sl<SettingBloc>().model?.social?.snapchat != null)
                  customImageIcon(
                    imageName: Images.snapchat,
                    width: 50.w,
                    height: 50.w,
                    onTap: () async {
                      launchUrl(
                          Uri.parse(
                              sl<SettingBloc>().model?.social?.snapchat ?? ""),
                          mode: LaunchMode.externalApplication);
                    },
                  ),
                  // if (sl<SettingBloc>().model?.social?.instagram != null)
                  customImageIcon(
                    imageName: Images.instagram,
                    width: 50.w,
                    height: 50.w,
                    onTap: () async {
                      launchUrl(
                          Uri.parse(
                              sl<SettingBloc>().model?.social?.instagram ?? ""),
                          mode: LaunchMode.externalApplication);
                    },
                  ),
                  // if (sl<SettingBloc>().model?.social?.twitter != null)
                  customImageIcon(
                    imageName: Images.twitter,
                    width: 50.w,
                    height: 50.w,
                    onTap: () async {
                      launchUrl(
                          Uri.parse(
                              sl<SettingBloc>().model?.social?.twitter ?? ""),
                          mode: LaunchMode.externalApplication);
                    },
                  ),
                  // if (sl<SettingBloc>().model?.social?.website != null)
                  customContainerSvgIcon(
                    imageName: SvgImages.language,
                    color: Styles.WHITE_COLOR,
                    backGround: Styles.PRIMARY_COLOR,
                    width: 50.w,
                    height: 50.w,
                    radius: 100,
                    padding: 8.w,
                    onTap: () async {
                      launchUrl(
                          Uri.parse(
                              sl<SettingBloc>().model?.social?.twitter ?? ""),
                          mode: LaunchMode.externalApplication);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
