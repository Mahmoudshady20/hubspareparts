import 'package:flutter/material.dart';
import 'package:safecart/utils/responsive.dart';

import '../helpers/common_helper.dart';

class DotIndicator extends StatelessWidget {
  bool isActive;
  int dotCount;
  DotIndicator(this.isActive, {super.key, this.dotCount = 3});

  @override
  Widget build(BuildContext context) {
    final double width = ((screenWidth / 2.7) / dotCount) < 6
        ? 6
        : ((screenWidth / 4.3) / dotCount);
    return SizedBox(
      height: 6,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        height: 6,
        width: isActive
            ? width + (dotCount * 8)
            : (width - (dotCount * 4)) < 6
                ? 6
                : width - (dotCount * 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isActive ? cc.primaryColor : cc.primaryColor.withOpacity(.2),

          // color: widget.isActive
          //     ? ConstantColors().primaryColor
          //     : ConstantColors().greyDots,
        ),
      ),
    );
  }
}
