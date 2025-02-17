import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/app/core/extensions.dart';
import 'package:zurex/helpers/pickers/view/image_picker_helper.dart';

import '../../../app/core/styles.dart';
import '../../../app/core/svg_images.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_images.dart';
import '../bloc/contact_with_us_bloc.dart';

class ContactWithUsImage extends StatelessWidget {
  const ContactWithUsImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${getTranslated("upload_image")} (${getTranslated("optional")})",
          style:
              AppTextStyles.w600.copyWith(fontSize: 16, color: Styles.HEADER),
        ),
        SizedBox(
          height: 12.h,
        ),
        StreamBuilder(
            stream: context.read<ContactWithUsBloc>().imageStream,
            builder: (_, snapshot) {
              return GestureDetector(
                onTap: () => ImagePickerHelper.openGallery(
                    onGet: context.read<ContactWithUsBloc>().updateImage),
                child: DottedBorder(
                  color: Styles.HINT_COLOR,
                  strokeCap: StrokeCap.square,
                  borderType: BorderType.RRect,
                  dashPattern: const [10, 10],
                  radius: const Radius.circular(15),
                  child: Container(
                      width: context.width,
                      height: 100.h,
                      decoration: BoxDecoration(
                        color: Styles.WHITE_COLOR,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: snapshot.hasData
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.file(
                                      snapshot.data!,
                                      width: context.width,
                                      height: 100.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Styles.BLACK.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    width: context.width,
                                    height: 100.h,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        customImageIconSVG(
                                            imageName: SvgImages.uploadDocument,
                                            height: 24.h,
                                            width: 24.w,
                                            color: Styles.DETAILS_COLOR),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  customImageIconSVG(
                                      imageName: SvgImages.uploadDocument,
                                      height: 24.h,
                                      width: 24.w,
                                      color: Styles.DETAILS_COLOR),
                                  SizedBox(height: 8.h),
                                  Text(
                                    getTranslated("upload_image"),
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.w400.copyWith(
                                        fontSize: 12,
                                        color: Styles.DETAILS_COLOR),
                                  ),
                                ],
                              ),
                      )),
                ),
              );
            }),
      ],
    );
  }
}
