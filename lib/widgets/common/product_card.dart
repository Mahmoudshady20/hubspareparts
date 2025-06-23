import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/cart_data_service.dart';
import 'package:safecart/services/wishlist_data_service.dart';
import 'package:safecart/utils/responsive.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../services/product_details_service.dart';
import '../../services/rtl_service.dart';
import '../../views/product_details_view.dart';
import 'custom_icon_button.dart';

class ProductCard extends StatelessWidget {
  var id;
  String? imageUrl;
  String title;
  num salePrice;
  num? originalPrice;
  bool cartable;
  int index;
  String? badge;
  String? discPercentage;
  bool shouldPop;
  dynamic vendorId;
  dynamic prodCatData;
  dynamic rating;
  DateTime? endDate;
  dynamic randomKey;
  dynamic randomSecret;
  dynamic stock;
  dynamic campaignStock;

  ProductCard(
    this.id,
    this.title,
    this.imageUrl,
    this.salePrice,
    this.originalPrice,
    this.index, {
    this.badge,
    this.discPercentage,
    this.cartable = true,
    this.shouldPop = false,
    this.vendorId,
    required this.prodCatData,
    this.rating,
    this.endDate,
    required this.randomKey,
    required this.randomSecret,
    required this.stock,
    required this.campaignStock,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    return GestureDetector(
      onTap: () {
        if (shouldPop) {
          Navigator.pop(context);
        }
        Provider.of<ProductDetailsService>(context, listen: false)
            .clearProductDetails();
        Navigator.of(context)
            .pushNamed(ProductDetailsView.routeName, arguments: [id, id]);
      },
      child: Flex(direction: Axis.vertical, children: [
        Stack(
          children: [
            Container(
              width: (screenWidth - 70) / 2,
              padding: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                  color: cc.pureWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cc.greyBorder)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      topLeft: Radius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          height: 120,
                          width: double.infinity,
                          color: cc.productBackground,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: imageUrl ?? imageLoadingProductCard,
                            placeholder: (context, url) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/loading_imaage.png'),
                                            opacity: .5)),
                                  ),
                                ],
                              );
                            },
                            errorWidget: (context, url, error) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/loading_imaage.png'),
                                            opacity: .5)),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              EmptySpaceHelper.emptyHight(6),
                              if (badge != null)
                                Container(
                                  margin: const EdgeInsets.only(left: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: cc.badgeColors[
                                        index % cc.badgeColors.length],
                                  ),
                                  child: Text(
                                    badge!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          fontSize: 11,
                                          color: cc.pureWhite,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              if (badge != null) EmptySpaceHelper.emptyHight(8),
                              if (discPercentage != null &&
                                  discPercentage != '0.00')
                                Container(
                                  margin: const EdgeInsets.only(left: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: cc.badgeColors[
                                        index % cc.badgeColors.length],
                                  ),
                                  child: Text(
                                    '${discPercentage!}%',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          fontSize: 11,
                                          color: cc.pureWhite,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Consumer<WishlistDataService>(
                            builder: (context, wProvider, child) {
                          return Positioned(
                            right: 4,
                            child: favoriteIcon(
                              wProvider.isWishlist(id.toString()),
                              size: 15,
                              onPressed: () {
                                wProvider.toggleWishlist(
                                    context,
                                    id,
                                    title,
                                    salePrice.toDouble(),
                                    originalPrice?.toDouble(),
                                    imageUrl ?? imageLoadingAppIcon,
                                    cartable,
                                    prodCatData == true,
                                    vendorId ?? 'admin',
                                    rating ?? 0,
                                    randomKey: randomKey,
                                    randomSecret: randomSecret,
                                    stock: stock);
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  if (rating != null && rating != '0.00')
                    EmptySpaceHelper.emptyHight(10),
                  if (rating > 0) EmptySpaceHelper.emptyHight(8),
                  if (rating > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(children: [
                        SvgPicture.asset(
                          'assets/icons/star.svg',
                          color: rating <= 0 ? cc.cardGreyHint : null,
                        ),
                        EmptySpaceHelper.emptywidth(4),
                        Text(
                          '(${rating.toStringAsFixed(1)})',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ]),
                    ),
                  EmptySpaceHelper.emptyHight(8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: cc.blackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                  ),
                  EmptySpaceHelper.emptyHight(6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: (screenWidth / 4.2),
                          child: FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                          fontSize: 14),
                                ),
                                EmptySpaceHelper.emptywidth(5),
                                if (originalPrice != null)
                                  Text(
                                    rtlProvider.curRtl
                                        ? '${originalPrice!.toStringAsFixed(2)}${rtlProvider.currency}'
                                        : '${rtlProvider.currency}${originalPrice!.toStringAsFixed(2)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: cc.greyHint,
                                          fontSize: 12,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationColor: cc.cardGreyHint,
                                          decorationStyle:
                                              TextDecorationStyle.solid,
                                        ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        CustomIconButton(
                          cartable
                              ? SvgPicture.asset('assets/icons/bag.svg')
                              : SvgPicture.asset(
                                  'assets/icons/obscure_on.svg',
                                  color: cc.pureWhite,
                                ),
                          onPressed: () {
                            if (stock <= 0) {
                              showToast(
                                  AppLocalizations.of(context)!
                                      .product_stock_is_insufficient,
                                  cc.blackColor);
                            }
                            if (cartable) {
                              Provider.of<CartDataService>(context,
                                      listen: false)
                                  .addCartItem(
                                      context,
                                      vendorId,
                                      id,
                                      title,
                                      salePrice.toDouble(),
                                      1,
                                      imageUrl ?? '',
                                      null,
                                      originalPrice: originalPrice?.toDouble(),
                                      inventorySet: {},
                                      prodCatData: prodCatData,
                                      randomKey: randomKey,
                                      randomSecret: randomSecret,
                                      stock: endDate != null &&
                                              (endDate
                                                          ?.difference(
                                                              DateTime.now())
                                                          .inSeconds ??
                                                      -1) >
                                                  0
                                          ? campaignStock
                                          : stock);
                              return;
                            }
                            if (shouldPop) {
                              Navigator.pop(context);
                            }
                            Provider.of<ProductDetailsService>(context,
                                    listen: false)
                                .clearProductDetails();
                            Navigator.of(context).pushNamed(
                                ProductDetailsView.routeName,
                                arguments: [title, id]);
                          },
                        ),
                      ],
                    ),
                  ),
                  EmptySpaceHelper.emptywidth(5),
                ],
              ),
            ),
            if (endDate != null &&
                (endDate?.difference(DateTime.now()).inSeconds ?? -1) > 0)
              Positioned(
                top: 100,
                left: 5,
                right: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                        child: Card(
                      elevation: 2,
                      margin: const EdgeInsets.all(2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: Colors.white,
                      child: SlideCountdownSeparated(
                        showZeroValue: true,
                        separator: ':',
                        padding: EdgeInsets.all(8),
                        separatorPadding: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: cc.pureWhite,
                        ),
                        style: TextStyle(
                            fontSize: 12,
                            color: cc.blackColor.withOpacity(.8),
                            fontWeight: FontWeight.bold),
                        duration: Duration(
                            seconds:
                                endDate!.difference(DateTime.now()).inSeconds),
                      ),
                    )),
                  ],
                ),
              ),
          ],
        ),
      ]),
    );
  }

  Widget favoriteIcon(bool isFavorite,
      {double size = 8, required void Function()? onPressed}) {
    return Container(
      margin: const EdgeInsets.only(top: 5, right: 5, left: 5),
      child: CircleAvatar(
        radius: size,
        backgroundColor: cc.pureWhite,
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
}
