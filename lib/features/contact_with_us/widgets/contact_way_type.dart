import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/svg_images.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/core/validation.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_text_form_field.dart';
import '../bloc/contact_with_us_bloc.dart';

class ContactWayType extends StatelessWidget {
  const ContactWayType({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ContactWays?>(
        stream: context.read<ContactWithUsBloc>().contactTypeStream,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTranslated("contact_information"),
                style: AppTextStyles.w600
                    .copyWith(fontSize: 16, color: Styles.HEADER),
              ),
              SizedBox(
                height: 12.h,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                    ContactWays.values.length,
                    (index) => GestureDetector(
                      onTap: () => context
                          .read<ContactWithUsBloc>()
                          .updateContactType(ContactWays.values[index]),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                            vertical: 8.h),
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color:
                                    snapshot.data == ContactWays.values[index]
                                        ? Styles.PRIMARY_COLOR
                                        : Styles.BORDER_COLOR),
                            color: snapshot.data == ContactWays.values[index]
                                ? Styles.PRIMARY_COLOR
                                : Styles.WHITE_COLOR),
                        child: Text(
                          "${getTranslated("by")} ${getTranslated(ContactWays.values[index].name)}",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.w500.copyWith(
                              fontSize: 14,
                              color: snapshot.data == ContactWays.values[index]
                                  ? Styles.WHITE_COLOR
                                  : Styles.PRIMARY_COLOR),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              CustomTextField(
                  controller: context.read<ContactWithUsBloc>().contactTEC,
                  hint: getTranslated("please_enter_the_way_to_contact_you"),
                  inputType: inputType(snapshot.data ?? ContactWays.whatsapp),
                  validate:
                      validationType(snapshot.data ?? ContactWays.whatsapp),
                  pSvgIcon: icon(snapshot.data ?? ContactWays.whatsapp),
                  formattedType: snapshot.data != ContactWays.email
                      ? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
                      : null,
                  pIconColor: Styles.DISABLED)
            ],
          );
        });
  }

  validationType(ContactWays type) {
    switch (type) {
      case ContactWays.whatsapp:
        return Validations.phone;
      case ContactWays.email:
        return Validations.mail;
      case ContactWays.phone:
        return Validations.phone;
    }
  }

  inputType(ContactWays type) {
    switch (type) {
      case ContactWays.whatsapp:
        return const TextInputType.numberWithOptions(
            signed: false, decimal: false);
      case ContactWays.email:
        return TextInputType.emailAddress;
      case ContactWays.phone:
        return const TextInputType.numberWithOptions(
            signed: false, decimal: false);
    }
  }

  icon(ContactWays type) {
    switch (type) {
      case ContactWays.whatsapp:
        return SvgImages.whatsApp;
      case ContactWays.email:
        return SvgImages.mailIcon;
      case ContactWays.phone:
        return SvgImages.phoneCallIcon;
    }
  }
}
