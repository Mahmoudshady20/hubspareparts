import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../helpers/common_helper.dart';

class ProductCardSkeleton extends StatelessWidget {
  ProductCardSkeleton({super.key});
  List<Color> colors = [
    const Color(0xff5AB27E),
    const Color(0xffFF8A73),
    const Color(0xffFF5C5D),
  ];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Shimmer.fromColors(
        enabled: true,
        baseColor: cc.greyBorder,
        highlightColor: cc.pureWhite,
        child: Container(
          height: 230,
          width: 170,
          decoration: BoxDecoration(
            color: cc.primaryColor.withValues(alpha: .60),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
