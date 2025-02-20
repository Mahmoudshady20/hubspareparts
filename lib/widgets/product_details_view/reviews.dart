import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/product_details_service.dart';
import 'package:safecart/views/all_reviews_view.dart';
import 'package:safecart/widgets/all_reviews_view/review_tile.dart';
import 'package:safecart/widgets/all_reviews_view/write_review.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../helpers/common_helper.dart';

class Reviews extends StatelessWidget {
  Reviews({super.key});
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      //Dropdown
      margin: const EdgeInsets.only(bottom: 20, top: 8),
      child: Builder(builder: (context) {
        return Consumer<ProductDetailsService>(
            builder: (context, pdProvider, child) {
          return Column(
            children: [
              if (!pdProvider.userAlredyrated && pdProvider.userHasItem)
                WriteReview(pdProvider.productDetails?.id),
              ...descriptions(pdProvider, context),
            ],
          );
        });
      }),
    );
  }

  List<Widget> descriptions(
      ProductDetailsService pdProvider, BuildContext context) {
    List<Widget> reviewList = [];
    int index = 0;

    for (var element in pdProvider.productDetails!.reviews!) {
      if (pdProvider.productDetails!.reviews!.length > 4 && index == 4) {
        reviewList.add(
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AllReviewsView(),
              ));
            },
            style: OutlinedButton.styleFrom(
                backgroundColor: cc.primaryColor.withOpacity(0.03),
                foregroundColor: cc.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
            child: Text(
              AppLocalizations.of(context)!.show_all,
              style: TextStyle(
                color: cc.primaryColor,
              ),
            ),
          ),
        );
        break;
      }
      index++;
      reviewList.add(
        ReviewTile(
            userName: element.user?.name,
            reviewText: element.reviewText ?? '',
            profileImage: element.user?.profileImage,
            rating: element.rating,
            createdAt: element.createdAt),
      );
    }

    return reviewList.isEmpty
        ? [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Text(
                'No Review submitted yet',
                style: TextStyle(
                    color: cc.greyHint,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
          ]
        : reviewList;
  }
}
