import 'package:flutter/material.dart';
import 'package:safecart/utils/responsive.dart';
import 'package:shimmer/shimmer.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';

class OrderTileSkeleton extends StatelessWidget {
  const OrderTileSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      enabled: true,
      baseColor: cc.greyBorder,
      highlightColor: cc.pureWhite,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            EmptySpaceHelper.emptyHight(4),
            Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
            ),
            EmptySpaceHelper.emptyHight(4),
            Row(
              children: [
                Container(
                  width: screenWidth / 3.7,
                  height: 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                ),
                EmptySpaceHelper.emptywidth(4),
                Container(
                  width: screenWidth / 3.7,
                  height: 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 40,
                  height: 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
