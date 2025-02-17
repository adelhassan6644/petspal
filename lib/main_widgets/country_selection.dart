import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/app/core/svg_images.dart';
import 'package:country_codes/country_codes.dart';
import 'package:country_flags/country_flags.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import '../../../../../app/core/styles.dart';
import '../../../../../app/core/text_styles.dart';
import '../../../../../app/localization/language_constant.dart';
import '../../../../../components/custom_app_bar.dart';
import '../../../../../components/custom_images.dart';
import '../app/core/app_event.dart';
import '../data/config/di.dart';
import '../main_blocs/country_states_bloc.dart';

class CountrySelection extends StatelessWidget {
  const CountrySelection(
      {super.key, required this.onSelect, this.initialSelection});
  final Function(CountryCode?) onSelect;
  final String? initialSelection;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTranslated("country"),
            style:
                AppTextStyles.w600.copyWith(fontSize: 14, color: Styles.HEADER),
          ),
          SizedBox(height: 8.h),
          Container(
            height: 48.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: Styles.LIGHT_BORDER_COLOR,
              ),
              borderRadius: BorderRadius.circular(12.w),
            ),
            child: CountryListPick(
              appBar: CustomAppBar(
                title: getTranslated("select_your_country"),
              ),
              pickerBuilder: (context, CountryCode? countryCode) {
                return Row(
                  children: [
                    customImageIconSVG(
                      imageName: SvgImages.global,
                      color: Styles.HINT_COLOR,
                      height: 16.h,
                      width: 16.w,
                    ),
                    Container(
                      height: 100,
                      width: 1,
                      margin: EdgeInsets.symmetric(horizontal: 14.w),
                      decoration: BoxDecoration(
                          color: Styles.HINT_COLOR,
                          borderRadius: BorderRadius.circular(100)),
                      child: const SizedBox(),
                    ),
                    Expanded(
                      child: Text(
                        initialSelection != null
                            ? CountryCodes.detailsForLocale(Locale.fromSubtags(
                                        countryCode: initialSelection))
                                    .name ??
                                ""
                            : getTranslated("select_your_country"),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: AppTextStyles.w400.copyWith(
                            fontSize: 14,
                            color: initialSelection != null
                                ? Styles.HEADER
                                : Styles.HINT_COLOR),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    if (initialSelection != null)
                      CountryFlag.fromCountryCode(
                        initialSelection ?? "",
                        height: 18,
                        width: 24,
                        shape: const RoundedRectangle(5),
                      ),
                  ],
                );
              },
              theme: CountryTheme(
                labelColor: Styles.ACCENT_COLOR,
                alphabetSelectedBackgroundColor: Styles.ACCENT_COLOR,
                isShowFlag: true,
                isShowTitle: true,
                isShowCode: false,
                isDownIcon: true,
                showEnglishName: true,
              ),
              initialSelection: initialSelection ?? "SA",
              onChanged: (CountryCode? code) {
                onSelect.call(code);
                sl<CountryStatesBloc>().add(Click(arguments: code!.code));
              },
              useUiOverlay: true,
              useSafeArea: true,
            ),
          ),
        ],
      ),
    );
  }
}
