import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../helpers/common_helper.dart';
import '../../utils/responsive.dart';

class SliderTwoSkeleton extends StatelessWidget {
  SliderTwoSkeleton({super.key});

  List colors1 = [
    const Color(0xffFFECF0),
  ];

  @override
  Widget build(BuildContext context) {
    getScreenSize(context);

    return Shimmer.fromColors(
      enabled: true,
      baseColor: cc.greyBorder,
      highlightColor: cc.pureWhite,
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 180,
        width: screenWidth / 1.25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colors1.first,
        ),
      ),
    );
  }
}
