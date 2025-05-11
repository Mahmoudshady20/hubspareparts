import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../services/product_details_service.dart';

class ProductRatingScore extends StatelessWidget {
  const ProductRatingScore({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Consumer<ProductDetailsService>(
        builder: (context, pdProvider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            if (pdProvider.productDetails!.reviewsCount != null &&
                pdProvider.productDetails!.reviewsCount != 0.0)
              RatingBar.builder(
                ignoreGestures: true,
                itemSize: 17,
                initialRating:
                    pdProvider.productDetails!.reviewsAvgRating != null
                        ? pdProvider.productDetails!.reviewsAvgRating ?? 0.0
                        : 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                itemBuilder: (context, _) => SvgPicture.asset(
                  'assets/icons/star.svg',
                  color: cc.orangeRating,
                ),
                onRatingUpdate: (rating) {},
              ),
            if (pdProvider.productDetails!.reviewsCount != null &&
                pdProvider.productDetails!.reviewsCount != 0.0)
              EmptySpaceHelper.emptywidth(10),
            if (pdProvider.productDetails!.reviewsCount != null &&
                pdProvider.productDetails!.reviewsCount != 0.0)
              Text(
                  "( ${(pdProvider.productDetails!.reviewsCount ?? 0).toString()} )"),
            if (pdProvider.productDetails!.reviewsCount != null &&
                pdProvider.productDetails!.reviewsCount != 0.0)
              const Spacer(),
            if (pdProvider.productDetails!.campaignProduct != null)
              SlideCountdownSeparated(
                showZeroValue: true,
                separator: '',
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 1,
                      color: cc.greyBorder,
                    )),
                style: TextStyle(
                    color: cc.blackColor.withValues(alpha: .8),
                    fontWeight: FontWeight.bold),
                duration: (pdProvider.productDetails!.campaignProduct!.endDate
                            ?.isAfter(now) ??
                        false)
                    ? pdProvider.productDetails!.campaignProduct!.endDate!
                        .difference(now)
                    : const Duration(seconds: 1),
              ),
          ],
        ),
      );
    });
  }
}
