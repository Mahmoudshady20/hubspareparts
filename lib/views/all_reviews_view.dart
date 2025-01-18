import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/helpers/empty_space_helper.dart';
import 'package:safecart/services/product_details_service.dart';
import 'package:safecart/widgets/all_reviews_view/review_tile.dart';
import 'package:safecart/widgets/common/custom_app_bar.dart';

class AllReviewsView extends StatelessWidget {
  static const routeName = 'all_reviews_view';
  const AllReviewsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar().appBarTitled(context, "All Reviews", () {
        Navigator.of(context).pop();
      }),
      body: Consumer<ProductDetailsService>(
          builder: (context, pdProvider, child) {
        return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final element = pdProvider.productDetails!.reviews![index];
              return ReviewTile(
                  userName: element.user?.name,
                  reviewText: element.reviewText ?? '',
                  profileImage: element.user?.image,
                  rating: element.rating,
                  createdAt: element.createdAt);
            },
            separatorBuilder: (context, index) =>
                EmptySpaceHelper.emptyHight(0),
            itemCount: pdProvider.productDetails!.reviews!.length);
      }),
    );
  }
}
