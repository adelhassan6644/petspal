import 'package:flutter/cupertino.dart';

import '../../../app/core/styles.dart';


class StepPointWidget extends StatelessWidget {
  const StepPointWidget(
      {super.key, required this.currentIndex, this.length, this.color});
  final int currentIndex;
  final int? length;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            length ?? 3,
            (index) => Padding(
                  padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
                  child: AnimatedContainer(
                    height: 10,
                    width: currentIndex == index ? 10 : 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                        color: currentIndex == index
                            ? color ?? Styles.PRIMARY_COLOR
                            : Styles.WHITE_COLOR,
                       ),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeIn,
                  ),
                )));
  }
}
