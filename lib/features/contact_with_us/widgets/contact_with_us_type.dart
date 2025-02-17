import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/app/core/styles.dart';
import 'package:zurex/app/core/text_styles.dart';
import 'package:zurex/app/core/validation.dart';
import 'package:zurex/app/localization/language_constant.dart';
import 'package:zurex/components/custom_text_form_field.dart';

import '../../../app/core/svg_images.dart';
import '../bloc/contact_with_us_bloc.dart';

class ContactWithUsType extends StatelessWidget {
  const ContactWithUsType({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProblemType?>(
        stream: context.read<ContactWithUsBloc>().problemTypeStream,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTranslated("contact_purpose"),
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
                    ProblemType.values.length,
                    (index) => GestureDetector(
                      onTap: () => context
                          .read<ContactWithUsBloc>()
                          .updateProblemType(ProblemType.values[index]),
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
                                    snapshot.data == ProblemType.values[index]
                                        ? Styles.PRIMARY_COLOR
                                        : Styles.BORDER_COLOR),
                            color: snapshot.data == ProblemType.values[index]
                                ? Styles.PRIMARY_COLOR
                                : Styles.WHITE_COLOR),
                        child: Text(
                          getTranslated(ProblemType.values[index].name),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.w500.copyWith(
                              fontSize: 14,
                              color: snapshot.data == ProblemType.values[index]
                                  ? Styles.WHITE_COLOR
                                  : Styles.PRIMARY_COLOR),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              CustomTextField(
                controller: context.read<ContactWithUsBloc>().descriptionTEC,
                hint: getTranslated("please_describe_what_you_want_in_detail"),
                borderRadius: 12,
                // pSvgIcon: SvgImages.desc,
                validate: Validations.field,
                maxLines: 5,
                minLines: 5,
              )
            ],
          );
        });
  }
}
