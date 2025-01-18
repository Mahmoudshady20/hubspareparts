import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../helpers/common_helper.dart';

class CategoryChipSkeleton extends StatelessWidget {
  const CategoryChipSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      enabled: true,
      baseColor: cc.greyBorder,
      highlightColor: cc.pureWhite,
      child: Container(
        width: 100,
        height: 15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
      ),
    );
  }
}
