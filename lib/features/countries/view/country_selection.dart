import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/app/core/svg_images.dart';
import 'package:flutter/material.dart';
import 'package:petspal/components/custom_single_selector.dart';
import 'package:petspal/features/countries/bloc/countries_bloc.dart';
import 'package:petspal/features/countries/repo/countries_repo.dart';
import 'package:petspal/main_models/custom_field_model.dart';
import '../../../../../../../app/localization/language_constant.dart';
import '../../../app/core/app_core.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_notification.dart';
import '../../../app/core/styles.dart';
import '../../../components/custom_bottom_sheet.dart';
import '../../../components/custom_text_form_field.dart';
import '../../../data/config/di.dart';
import '../../../navigation/custom_navigation.dart';

class CountrySelection extends StatelessWidget {
  const CountrySelection(
      {super.key,
      required this.onSelect,
      this.initialSelection,
      this.error = "",
      required this.focusNode,
      this.nextFocus,
      this.haseError = false,
      this.validate});

  final Function(CustomFieldModel?) onSelect;
  final CustomFieldModel? initialSelection;
  final dynamic error;
  final FocusNode? focusNode, nextFocus;
  final bool haseError;
  final String? Function(String?)? validate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CountriesBloc(repo: sl<CountriesRepo>()),
      // ..add(Click()),
      child: BlocBuilder<CountriesBloc, AppState>(
        builder: (context, state) {
          return CustomTextField(
            label: getTranslated("country"),
            hint: getTranslated("select_your_country"),
            pSvgIcon: SvgImages.country,
            controller: TextEditingController(text: initialSelection?.name),
            onTap: () {
              if (state is Done) {
                List<CustomFieldModel> list =
                    state.list as List<CustomFieldModel>;
                CustomBottomSheet.show(
                  label: getTranslated("select_your_country"),
                  onConfirm: () => CustomNavigator.pop(),
                  widget: CustomSingleSelector(
                    list: list,
                    initialValue: initialSelection?.id,
                    onConfirm: (v) {
                      onSelect.call(v);
                    },
                  ),
                );
              }
              if (state is Loading) {
                AppCore.showSnackBar(
                    notification: AppNotification(
                  message: getTranslated("loading"),
                  backgroundColor: Styles.PENDING,
                ));
              }
              if (state is Error) {
                AppCore.showSnackBar(
                    notification: AppNotification(
                  message: getTranslated("something_went_wrong"),
                  backgroundColor: Styles.ERORR_COLOR,
                ));
              }
              if (state is Empty) {
                AppCore.showSnackBar(
                    notification: AppNotification(
                  message: getTranslated("there_is_no_countries"),
                  backgroundColor: Styles.PENDING,
                ));
              } else {
                CustomBottomSheet.show(
                  label: getTranslated("select_your_country"),
                  onConfirm: () => CustomNavigator.pop(),
                  widget: CustomSingleSelector(
                    list: [
                      CustomFieldModel(id: 1, name: "Egypt", code: "EG"),
                      CustomFieldModel(id: 2, name: "Saudi Arabia", code: "SA"),
                      CustomFieldModel(id: 3, name: "Kuwait", code: "KU"),
                      CustomFieldModel(
                          id: 4, name: "United Arab Emirates", code: "UA"),
                    ],
                    initialValue: initialSelection?.id,
                    onConfirm: (v) {
                      onSelect.call(v);
                    },
                  ),
                );
              }
            },
            readOnly: true,
            focusNode: focusNode,
            nextFocus: nextFocus,
            validate: validate,
            errorText: error,
            customError: haseError,
          );
        },
      ),
    );
  }
}
