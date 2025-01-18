import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/common_helper.dart';
import '../helpers/empty_space_helper.dart';
import '../helpers/navigation_helper.dart';
import '../services/product_details_service.dart';
import '../services/wishlist_data_service.dart';
import '../utils/responsive.dart';
import '../widgets/wishlist_view/wishlist_tile.dart';
import 'product_details_view.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () =>
          Provider.of<NavigationHelper>(context, listen: false).setNavIndex(0),
      child: Consumer<WishlistDataService>(
        builder: (context, fProvider, child) {
          return SizedBox(
            height: screenHeight - 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (fProvider.wishlistItems.isNotEmpty)
                  TextButton.icon(
                    onPressed: fProvider.wishlistItems.isEmpty
                        ? () {
                            showToast(asProvider.getString('No item found'),
                                cc.blackColor);
                          }
                        : () {
                            confirmDialogue(
                              context,
                              onPressed: () {
                                fProvider.emptyWishlist();
                                showToast(
                                    asProvider.getString(
                                        'Items removed from wishlist'),
                                    cc.blackColor);
                              },
                            );
                          },
                    icon: const Icon(Icons.cancel_outlined),
                    label: Text(
                      asProvider.getString('Clear cart'),
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: cc.red,
                        decorationThickness: 2,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: cc.red,
                    ),
                  ),
                EmptySpaceHelper.emptywidth(10),
                if (fProvider.wishlistItems.isEmpty)
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: screenHeight / 2.5,
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset('assets/images/empty_favorite.png'),
                      ),
                      Center(
                        child: Text(
                          asProvider.getString('Add items to wishlist'),
                          style: TextStyle(color: cc.greyHint),
                        ),
                      ),
                    ],
                  )),
                if (fProvider.wishlistItems.isNotEmpty)
                  Expanded(
                      child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          itemBuilder: (context, index) {
                            final element =
                                fProvider.wishlistItems.values.toList()[index];
                            return GestureDetector(
                              onTap: () {
                                Provider.of<ProductDetailsService>(context,
                                        listen: false)
                                    .clearProductDetails();
                                Navigator.of(context).pushNamed(
                                    ProductDetailsView.routeName,
                                    arguments: [element.title, element.id]);
                              },
                              child: WishlistTile(
                                  element.id,
                                  element.title,
                                  element.imgUrl,
                                  element.price!,
                                  element.originalPrice,
                                  element.isCartable,
                                  index,
                                  element.vendorId,
                                  element.prodCatData,
                                  element.rating,
                                  element.randomKey,
                                  element.randomSecret,
                                  element.stock),
                            );
                          },
                          separatorBuilder: (context, index) => const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Divider(),
                              ),
                          itemCount: fProvider.wishlistItems.values.length))
              ],
            ),
          );
        },
      ),
    );
  }

  Future confirmDialogue(BuildContext context,
      {required void Function() onPressed}) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(asProvider.getString('Are you sure?')),
              content:
                  Text(asProvider.getString('These Items will be Deleted.')),
              actions: [
                TextButton(
                    onPressed: (() {
                      Navigator.pop(context);
                    }),
                    child: Text(
                      asProvider.getString('No'),
                      style: TextStyle(color: cc.green),
                    )),
                TextButton(
                    onPressed: () {
                      onPressed();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      asProvider.getString('Yes'),
                      style: TextStyle(color: cc.pink),
                    ))
              ],
            ));
  }
}
