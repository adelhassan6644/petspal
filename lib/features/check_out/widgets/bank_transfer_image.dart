import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/app/core/extensions.dart';
import 'package:zurex/features/check_out/bloc/check_out_bloc.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/core/styles.dart';
import '../../../app/core/svg_images.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_images.dart';
import '../../../helpers/pickers/view/image_picker_helper.dart';

class BankTransferImage extends StatelessWidget {
  const BankTransferImage({super.key, this.show = false});
  final bool show;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
        crossFadeState:
            show ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 400),
        firstChild: SizedBox(width: context.width),
        secondChild: StreamBuilder(
            stream: context.read<CheckOutBloc>().imageStream,
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
                  Text(
                    getTranslated("please_upload_bank_transfer_image"),
                    style: AppTextStyles.w500
                        .copyWith(fontSize: 14, color: Styles.TITLE),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: GestureDetector(
                      onTap: () => ImagePickerHelper.showOptionDialog(
                          onGet: context.read<CheckOutBloc>().updateImage),
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
                              // color: Styles.WHITE_COLOR,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: snapshot.hasData
                                  ? Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.file(
                                            snapshot.data!,
                                            width: context.width,
                                            height: 100.h,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Styles.BLACK.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          width: context.width,
                                          height: 100.h,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              customImageIconSVG(
                                                  imageName: SvgImages.gallery,
                                                  height: 24.h,
                                                  width: 24.w,
                                                  color: Styles.DETAILS_COLOR),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                    ),
                  ),
                ],
              );
            }));
  }
}
