import 'package:flutter/material.dart';
import 'package:safecart/utils/responsive.dart';
import 'package:shimmer/shimmer.dart';

import '../../helpers/common_helper.dart';

class HomePageTitleSkeleton extends StatelessWidget {
  const HomePageTitleSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Shimmer.fromColors(
          enabled: true,
          baseColor: cc.greyBorder,
          highlightColor: cc.pureWhite,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 30,
              width: screenWidth / 2.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
