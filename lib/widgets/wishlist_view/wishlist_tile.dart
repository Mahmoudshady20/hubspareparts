import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/cart_data_service.dart';
import 'package:safecart/widgets/wishlist_view/wishlist_to_cart.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../services/product_details_service.dart';
import '../../services/rtl_service.dart';
import '../../services/wishlist_data_service.dart';
import 'package:safecart/utils/responsive.dart';
import '../common/custom_icon_button.dart';
import '../common/image_loading_failed.dart';

class WishlistTile extends StatelessWidget {
  dynamic id;
  String title;
  String image;
  double salePrice;
  double? originalPrice;
  bool? inventorySet;
  int index;
  dynamic vendorId;
  dynamic prodCatData;
  double rating;
  dynamic randomKey;
  dynamic randomSecret;
  dynamic stock;

  WishlistTile(
      this.id,
      this.title,
      this.image,
      this.salePrice,
      this.originalPrice,
      this.inventorySet,
      this.index,
      this.vendorId,
      this.prodCatData,
      this.rating,
      this.randomKey,
      this.randomSecret,
      this.stock,
      {super.key});
  List colors = [
    const Color(0xffFFE3F0),
    const Color(0xffD6EFFF),
    const Color(0xffF2F3F5),
  ];

  @override
  Widget build(BuildContext context) {
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    print((screenWidth / 4 + 50));
    return Container(
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
                height: screenWidth / 4,
                width: screenWidth / 4,
                color: colors[index % colors.length],
                child: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      ImageLoadingFailed(size: screenWidth / 4),
                  errorWidget: (context, url, error) =>
                      ImageLoadingFailed(size: screenWidth / 4),
                )),
          ),
          EmptySpaceHelper.emptywidth(10),
          SizedBox(
            // height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: screenWidth - (screenWidth / 4 + 50),
                  child: Column(
                    children: [
                      if (rating > 0)
                        Row(children: [
                          SvgPicture.asset(
                            'assets/icons/star.svg',
                            color: rating <= 0 ? cc.cardGreyHint : null,
                          ),
                          EmptySpaceHelper.emptywidth(4),
                          Text(
                            rating.toStringAsFixed(1),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ]),
                      EmptySpaceHelper.emptyHight(8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth - (screenWidth / 4 + 50),
                            child: Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          const Spacer(),

                          // Consumer<WishlistDataService>(
                          //     builder: (context, wProvider, child) {
                          //   return wishListIcon(
                          //     wProvider.isfavorite(id.toString()),
                          //     onPressed: () {
                          //       wProvider.toggleFavorite(
                          //           context, id, title, salePrice, image, true);
                          //     },
                          //   );
                          // }),
                        ],
                      ),
                    ],
                  ),
                ),
                EmptySpaceHelper.emptyHight(8),
                SizedBox(
                  // height: 70,
                  width: screenWidth - (screenWidth / 4 + 50),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: screenWidth - ((screenWidth / 4) + 92 + 50),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              rtlProvider.curRtl
                                  ? '${salePrice.toStringAsFixed(2)}${rtlProvider.currency}'
                                  : '${rtlProvider.currency}${salePrice.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: cc.secondaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                            ),
                            EmptySpaceHelper.emptywidth(5),
                            if (originalPrice != null)
                              Text(
                                rtlProvider.curRtl
                                    ? '${originalPrice!.toStringAsFixed((screenWidth / 4 + 50) < 152 ? 0 : 2)}${rtlProvider.currency}'
                                    : '${rtlProvider.currency}${originalPrice!.toStringAsFixed((screenWidth / 4 + 50) < 152 ? 0 : 2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: cc.greyHint,
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: cc.cardGreyHint,
                                      decorationStyle:
                                          TextDecorationStyle.solid,
                                    ),
                              ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      CustomIconButton(
                        SvgPicture.asset('assets/icons/bag.svg'),
                        onPressed: () async {
                          print(inventorySet);
                          if (inventorySet == false) {
                            print('fetching product details');
                            Provider.of<ProductDetailsService>(context,
                                    listen: false)
                                .clearProductDetails();
                            print(inventorySet);
                            await showModalBottomSheet(
                                context: context,
                                enableDrag: false,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                )),
                                builder: (context) {
                                  bool fetchAttribute = true;
                                  return SingleChildScrollView(
                                    child: WishlistToCart(id),
                                  );
                                });

                            return;
                            // Provider.of<CommonServices>(context, listen: false)
                            //     .addCartItem(
                            //         context, id, title, salePrice, 1, imageUrl);
                          }
                          Provider.of<CartDataService>(context, listen: false)
                              .addCartItem(context, vendorId, id, title,
                                  salePrice, 1, image, null,
                                  prodCatData: prodCatData,
                                  originalPrice: originalPrice,
                                  randomKey: randomKey,
                                  randomSecret: randomSecret,
                                  stock: stock);

                          // Provider.of<ProductDetailsService>(context, listen: false)
                          //     .clearProductDetails();
                          // Navigator.of(context).pushNamed(
                          //     ProductDetailsView.routeName,
                          //     arguments: [title,id]);
                        },
                      ),
                      EmptySpaceHelper.emptywidth(12),
                      CustomIconButton(
                        SvgPicture.asset('assets/icons/trash.svg'),
                        onPressed: () {
                          confirmDialouge(
                            context,
                            onPressed: () {
                              Provider.of<WishlistDataService>(context,
                                      listen: false)
                                  .deleteWishlistItem(id, context);
                              showToast(
                                  asProvider
                                      .getString('Item removed from wishlist'),
                                  cc.blackColor);
                            },
                          );
                        },
                        color: cc.red,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget wishListIcon(bool isFavorite,
      {double size = 15, required void Function()? onPressed}) {
    return Container(
      // margin: const EdgeInsets.only(top: 9, right: 5, left: 5),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: cc.productBackground,
        child: IconButton(
          onPressed: onPressed,
          splashColor: Colors.transparent,
          style: IconButton.styleFrom(
            highlightColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            focusColor: Colors.transparent,
          ),
          icon: SvgPicture.asset(
            'assets/icons/${isFavorite ? 'wishlist_fill' : 'wishlist'}.svg',
            height: 20,
            color: cc.primaryColor,
          ),
        ),
      ),
    );
  }

  Future confirmDialouge(BuildContext context,
      {required void Function() onPressed}) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(asProvider.getString('Are you sure?')),
              content: Text(asProvider.getString('This Item will be Deleted.')),
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
