import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../helpers/common_helper.dart';
import '../../utils/responsive.dart';

class SliderOneSkeleton extends StatelessWidget {
  const SliderOneSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    getScreenSize(context);

    return Shimmer.fromColors(
      enabled: true,
      baseColor: cc.greyBorder,
      highlightColor: cc.pureWhite,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.only(left: 20, right: 20),
        // height: 15,
        width: screenWidth / 5,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: cc.sliderOneBackground,
        ),
        child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: const []),
      ),
    );
  }
}
