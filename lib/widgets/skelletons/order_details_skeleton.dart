import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';

class OrderDetailsViewSkeleton extends StatelessWidget {
  const OrderDetailsViewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    // final tracker =
    // (ModalRoute.of(context)!.settings.arguments! as List)[0] as String;
    return Shimmer.fromColors(
      enabled: true,
      baseColor: cc.greyBorder,
      highlightColor: cc.pureWhite,
      child: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
          ),
          EmptySpaceHelper.emptyHight(10),
          infoRows(),
          EmptySpaceHelper.emptyHight(10),
          infoRows(),
          EmptySpaceHelper.emptyHight(10),
          infoRows(),
          EmptySpaceHelper.emptyHight(10),
          infoRows(),
          EmptySpaceHelper.emptyHight(10),
          infoRows(),
        ],
      ),
    );
  }

  infoRows() {
    return Row(
      children: [
        Container(
          width: 120,
          height: 18,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: cc.blackColor,
          ),
        ),
        const Spacer(),
        Container(
          width: 40,
          height: 18,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: cc.blackColor,
          ),
        ),
      ],
    );
  }
}
