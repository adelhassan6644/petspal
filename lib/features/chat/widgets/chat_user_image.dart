import 'package:flutter/material.dart';
import 'package:zurex/app/core/dimensions.dart';

import '../../../app/core/styles.dart';
import '../../../components/custom_network_image.dart';

class ChatUserImage extends StatelessWidget {
  const ChatUserImage(
      {super.key, required this.image, this.withPadding = false});
  final String image;
  final bool withPadding;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (withPadding)
          SizedBox(
            width: 12.w,
          ),
        CustomNetworkImage.circleNewWorkImage(
          image: image,
          radius: 20,
          color: Styles.HINT_COLOR,
        ),
      ],
    );
  }
}
