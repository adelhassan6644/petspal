import 'package:flutter/material.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/app/core/extensions.dart';
import 'package:zurex/app/core/styles.dart';
import 'package:zurex/app/core/text_styles.dart';
import 'package:zurex/navigation/routes.dart';

import '../../../app/core/svg_images.dart';
import '../../../components/custom_images.dart';
import '../../../components/custom_network_image.dart';
import '../../../navigation/custom_navigation.dart';
import '../../language/bloc/language_bloc.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar(
      {required this.image, required this.name, super.key, required this.id});
  final String image, name;
  final int id;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Styles.BACKGROUND_COLOR,
      leading: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          CustomNavigator.pop();
        },
        child: SizedBox(
          height: 30,
          width: 30,
          child: Center(
            child: RotatedBox(
              quarterTurns: LanguageBloc.instance.isLtr ? 0 : 2,
              child: customImageIconSVG(
                  color: Colors.black, imageName: SvgImages.backArrow),
            ),
          ),
        ),
      ),
      titleSpacing: 0,
      title: GestureDetector(
        onTap: () => CustomNavigator.push(Routes.userProfile,
            arguments: {"id": id, "from_chat": true}),
        child: Row(
          children: [
            CustomNetworkImage.circleNewWorkImage(
              image: image,
              radius: 20,
              color: Styles.HINT_COLOR,
            ),
            SizedBox(
              width: 12.w,
            ),
            Text(
              name,
              style: AppTextStyles.w500.copyWith(
                color: Styles.HEADER,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size(CustomNavigator.navigatorState.currentContext!.width, 50);
}
