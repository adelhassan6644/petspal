import 'package:flutter/material.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/features/chat/model/message_model.dart';
import '../../../../components/custom_network_image.dart';
import '../../../../components/image_pop_up_viewer.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({super.key, required this.message});
  final MessageItem message;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            barrierColor: Colors.black.withOpacity(0.75),
            builder: (context) {
              return ImagePopUpViewer(
                image: message.message ?? "",
                isFromInternet: true,
                title: "",
              );
            });
      },
      child: FittedBox(
        child: CustomNetworkImage.containerNewWorkImage(
          image: message.message ?? "",
          height: 120.h,
          width: 180.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
