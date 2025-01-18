import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/rtl_service.dart';
import 'package:shimmer/shimmer.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import 'package:safecart/utils/responsive.dart';

class ProductDetailsSkeleton extends StatelessWidget {
  const ProductDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    return Shimmer.fromColors(
      enabled: true,
      baseColor: cc.greyBorder,
      highlightColor: cc.pureWhite,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 300,
                margin: const EdgeInsets.symmetric(),
                width: double.infinity,
                color: cc.red),
            // ProductDetailsImages(),
            EmptySpaceHelper.emptyHight(20),
            Container(
              height: 12,
              width: screenWidth / 3.5,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: cc.greyBorder2),
            ),
            EmptySpaceHelper.emptyHight(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 15,
                    width: screenWidth / 1.3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: cc.greyBorder2),
                  ),
                ],
              ),
            ),

            EmptySpaceHelper.emptyHight(20),
            ...Iterable.generate(3).map(
              (e) => Container(
                height: 10,
                width: screenWidth -
                    Random()
                        .nextInt(
                          100,
                        )
                        .toDouble(),
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: cc.greyBorder2),
              ),
            ),
            EmptySpaceHelper.emptyHight(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FittedBox(
                fit: BoxFit.none,
                child: Row(children: [
                  ...Iterable.generate(5).map(
                    (e) => Container(
                      height: 39,
                      width: 39,
                      margin: EdgeInsets.only(
                          top: 7,
                          right: rtlProvider.langRtl ? 4 : 17,
                          left: rtlProvider.langRtl ? 17 : 4),
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(10),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            EmptySpaceHelper.emptyHight(20),
            Container(
              height: 10,
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: cc.greyBorder2),
            ),
            Container(
              height: 10,
              width: 160,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: cc.greyBorder2),
            ),
            EmptySpaceHelper.emptyHight(20),

            Container(
              height: 12,
              width: screenWidth - 80,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: cc.greyBorder2),
            ),
            EmptySpaceHelper.emptyHight(16),
            Container(
              height: 12,
              width: screenWidth - 60,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: cc.greyBorder2),
            ),
            EmptySpaceHelper.emptyHight(16),
            Container(
              height: 12,
              width: screenWidth - 40,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: cc.greyBorder2),
            ),
            EmptySpaceHelper.emptyHight(16),

            // ProductDetailsCartButton(1, () {}),
          ],
        ),
      ),
    );
  }
}
