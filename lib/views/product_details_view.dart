import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/wishlist_data_service.dart';
import 'package:safecart/widgets/common/internet_checker_widget.dart';
import 'package:share_plus/share_plus.dart';

import '../widgets/product_details_view/product_details_images.dart';
import '../widgets/common/boxed_back_button.dart';
import '../widgets/product_details_view/product_info_pages.dart';
import '../widgets/product_details_view/product_rating_score.dart';
import '../widgets/product_details_view/sellers_products.dart';
import '../widgets/product_details_view/shipping_methods.dart';
import '../widgets/search_view/filter_rtl_padding.dart';
import '../helpers/empty_space_helper.dart';
import '../helpers/common_helper.dart';
import '../services/product_details_service.dart';
import '../services/rtl_service.dart';
import '../utils/responsive.dart';
import '../widgets/product_details_view/product_attributes.dart';
import '../widgets/product_details_view/product_details_cart_button.dart';
import '../widgets/product_details_view/related_products.dart';
import '../widgets/product_details_view/product_title_row.dart';
import '../widgets/skelletons/product_details_skeleton.dart';

class ProductDetailsView extends StatelessWidget {
  static const routeName = 'product_details_view';
  ProductDetailsView({super.key});
  int itemCount = 1;

  @override
  Widget build(BuildContext context) {
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    final pdProvider =
        Provider.of<ProductDetailsService>(context, listen: false);
    final routeData = ModalRoute.of(context)!.settings.arguments as List;
    final id = routeData[1];
    return InternetCheckerWidget(
      widget: Scaffold(
          body: FutureBuilder(
              future: pdProvider.productDetails == null
                  ? pdProvider.fetchProductDetails(id)
                  : null,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ProductDetailsSkeleton();
                }
                if (snapshot.hasData || pdProvider.productDetails == null) {
                  return Column(
                    children: [
                      Expanded(
                          child: CustomScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        slivers: [
                          SliverAppBar(
                            elevation: 1,
                            leadingWidth: 60,
                            toolbarHeight: 60,
                            foregroundColor: cc.greyHint,
                            backgroundColor: cc.pureWhite,
                            expandedHeight: screenHeight / 4,
                            pinned: true,
                            leading: Padding(
                              padding: const EdgeInsets.symmetric(),
                              child: Column(
                                children: [
                                  BoxedBackButton(() {
                                    Navigator.of(context).pop();
                                  }),
                                ],
                              ),
                            ),
                          ),
                          SliverList(
                              delegate: SliverChildListDelegate([
                            Container(
                              child: LottieBuilder.asset(
                                'assets/animations/server_error.json',
                                height: screenHeight / 2,
                                repeat: true,
                              ),
                            ),
                            EmptySpaceHelper.emptyHight(15),
                            Center(
                              child: Text(
                                asProvider.getString('Loading failed'),
                                style: TextStyle(color: cc.greyParagraph),
                              ),
                            )
                          ]))
                        ],
                      )),
                    ],
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            elevation: 1,
                            leadingWidth: 60,
                            toolbarHeight: 60,
                            foregroundColor: cc.greyHint,
                            backgroundColor: cc.pureWhite,
                            expandedHeight: 300,
                            pinned: true,
                            flexibleSpace: const FlexibleSpaceBar(
                              background: ProductDetailsImages(),
                            ),
                            leading: Padding(
                              padding: const EdgeInsets.symmetric(),
                              child: Column(
                                children: [
                                  BoxedBackButton(() {
                                    Navigator.of(context).pop();
                                  }),
                                ],
                              ),
                            ),
                            actions: [
                              Column(
                                children: [
                                  if (Provider.of<ProductDetailsService>(
                                              context,
                                              listen: false)
                                          .productUrl !=
                                      null)
                                    GestureDetector(
                                        onTap: () {
                                          Share.share(Provider.of<
                                                      ProductDetailsService>(
                                                  context,
                                                  listen: false)
                                              .productUrl!);
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          padding: const EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: cc.greyFive,
                                              width: 1.5,
                                            ),
                                            color: cc.pureWhite,
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/icons/share.svg',
                                            color: cc.blackColor,
                                          ),
                                        )),
                                ],
                              ),
                              EmptySpaceHelper.emptywidth(10),
                              Column(
                                children: [
                                  Consumer<WishlistDataService>(
                                      builder: (context, wProvider, child) {
                                    return GestureDetector(
                                        onTap: () {
                                          final pdProvider = Provider.of<
                                                  ProductDetailsService>(
                                              context,
                                              listen: false);

                                          num stock = 0;
                                          var campaignProd = pdProvider
                                                  .productDetails
                                                  ?.campaignProduct !=
                                              null;
                                          if (pdProvider.additionalInfoStore ==
                                                  null ||
                                              pdProvider.additionalInfoStore ==
                                                  {}) {
                                            stock = 1;
                                          } else if (campaignProd) {
                                            var campaignStock = DateTime.now()
                                                    .isBefore(pdProvider
                                                            .productDetails!
                                                            .campaignProduct!
                                                            .endDate ??
                                                        DateTime.now().subtract(
                                                            const Duration(
                                                                days: 1)))
                                                ? pdProvider
                                                    .productDetails
                                                    ?.campaignProduct
                                                    ?.unitsForSale
                                                : 0;
                                            stock = campaignStock ?? 0;
                                          } else {
                                            stock = 1;
                                          }

                                          wProvider.toggleWishlist(
                                            context,
                                            pdProvider.productDetails!.id,
                                            pdProvider.productDetails!.name ??
                                                '',
                                            (pdProvider.productDetails!
                                                        .salePrice ??
                                                    pdProvider
                                                        .productDetails!.price)
                                                .toDouble(),
                                            (pdProvider.productDetails!
                                                        .salePrice ??
                                                    pdProvider
                                                        .productDetails!.price)
                                                ?.toDouble(),
                                            pdProvider.productDetails!.image ??
                                                imageLoadingAppIcon,
                                            pdProvider.additionalInfoStore ==
                                                null,
                                            {},
                                            (pdProvider.productDetails!
                                                        .vendorId ??
                                                    'admin')
                                                .toString(),
                                            pdProvider.productDetails
                                                    ?.reviewsAvgRating ??
                                                0.0,
                                            randomKey: pdProvider
                                                .productDetails?.randomKey,
                                            randomSecret: pdProvider
                                                .productDetails?.randomSecret,
                                            stock: stock,
                                          );
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: cc.greyFive,
                                              width: 1.5,
                                            ),
                                            color: cc.pureWhite,
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/icons/${wProvider.isWishlist(id.toString()) ? 'wishlist_fill' : 'wishlist'}.svg',
                                            color: cc.primaryColor,
                                          ),
                                        ));
                                  }),
                                ],
                              ),
                              EmptySpaceHelper.emptywidth(10)
                            ],
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                EmptySpaceHelper.emptyHight(20),
                                const ProductRatingScore(),
                                EmptySpaceHelper.emptyHight(12),
                                const ProductTitleRow(),
                                const ShippingMethods(),
                                Container(
                                  width: screenWidth / 1.3,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: ExpandableText(
                                    Provider.of<ProductDetailsService>(context,
                                                    listen: false)
                                                .productDetails ==
                                            null
                                        ? ''
                                        : Provider.of<ProductDetailsService>(
                                                context,
                                                listen: false)
                                            .productDetails!
                                            .summary!,
                                    maxLines: 4,
                                    expandText:
                                        asProvider.getString('Show more'),
                                    collapseText:
                                        asProvider.getString('Show less'),
                                    linkColor: cc.primaryColor,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          overflow: TextOverflow.ellipsis,
                                          color: cc.greyHint,
                                        ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: ProductAttribute(),
                                ),

                                //sub info
                                subInfo(
                                    context,
                                    asProvider.getString('Category'),
                                    Provider.of<ProductDetailsService>(context,
                                                    listen: false)
                                                .productDetails!
                                                .category !=
                                            null
                                        ? Provider.of<ProductDetailsService>(
                                                context,
                                                listen: false)
                                            .productDetails!
                                            .category!
                                            .name
                                        : asProvider.getString('None')),
                                EmptySpaceHelper.emptyHight(8),
                                subInfo(
                                    context,
                                    asProvider.getString('Sub Category'),
                                    Provider.of<ProductDetailsService>(context,
                                                    listen: false)
                                                .productDetails!
                                                .subCategory !=
                                            null
                                        ? Provider.of<ProductDetailsService>(
                                                context,
                                                listen: false)
                                            .productDetails!
                                            .subCategory!
                                            .name
                                        : asProvider.getString('None')),
                                EmptySpaceHelper.emptyHight(8),
                                subInfo(
                                    context,
                                    asProvider.getString('Child Category'),
                                    Provider.of<ProductDetailsService>(context,
                                                        listen: false)
                                                    .productDetails!
                                                    .childCategory !=
                                                null &&
                                            Provider.of<ProductDetailsService>(
                                                    context,
                                                    listen: false)
                                                .productDetails!
                                                .childCategory!
                                                .isNotEmpty
                                        ? Provider.of<ProductDetailsService>(
                                                context,
                                                listen: false)
                                            .productDetails!
                                            .childCategory!
                                            .first
                                            .name
                                        : asProvider.getString('None')),
                                EmptySpaceHelper.emptyHight(8),
                                subInfo(
                                    context,
                                    asProvider.getString('Brand'),
                                    Provider.of<ProductDetailsService>(context,
                                                listen: false)
                                            .productDetails!
                                            .brand ??
                                        asProvider.getString('None')),
                                EmptySpaceHelper.emptyHight(8),
                                subInfo(
                                    context,
                                    asProvider.getString('SKU'),
                                    Provider.of<ProductDetailsService>(context,
                                                listen: false)
                                            .productDetails
                                            ?.inventory?['sku'] ??
                                        asProvider.getString('None')),
                                EmptySpaceHelper.emptyHight(8),
                                subInfo(
                                    context,
                                    asProvider.getString('Unit'),
                                    Provider.of<ProductDetailsService>(context,
                                                listen: false)
                                            .productDetails
                                            ?.uom?['unit']?['name'] ??
                                        asProvider.getString('None')),
                                if ((Provider.of<ProductDetailsService>(context,
                                                listen: false)
                                            .productDetails!
                                            .tag
                                            ?.length ??
                                        0) >
                                    0)
                                  EmptySpaceHelper.emptyHight(8),
                                if ((Provider.of<ProductDetailsService>(context,
                                                listen: false)
                                            .productDetails!
                                            .tag
                                            ?.length ??
                                        0) >
                                    0)
                                  FilterRtlPadding(
                                      padding: 20,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            asProvider.getString('Tags') + ' :',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          EmptySpaceHelper.emptywidth(5),
                                          SizedBox(
                                            width: screenWidth - 65,
                                            height: 40,
                                            child: ListView.separated(
                                                padding: EdgeInsets.only(
                                                    right: rtlProvider.langRtl
                                                        ? 0
                                                        : 20,
                                                    left: rtlProvider.langRtl
                                                        ? 20
                                                        : 0),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    height: 40,
                                                    alignment: Alignment.center,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color: cc
                                                                .greyBorder2)),
                                                    child: Text(
                                                        Provider.of<ProductDetailsService>(
                                                                context,
                                                                listen: false)
                                                            .productDetails!
                                                            .tag![index]
                                                            .tagName,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                              color:
                                                                  cc.greyHint,
                                                            )),
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) =>
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                itemCount:
                                                    Provider.of<ProductDetailsService>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .productDetails!
                                                                .tag ==
                                                            null
                                                        ? 0
                                                        : Provider.of<
                                                                    ProductDetailsService>(
                                                                context,
                                                                listen: false)
                                                            .productDetails!
                                                            .tag!
                                                            .length),
                                          ),
                                        ],
                                      )),
                                EmptySpaceHelper.emptyHight(15),

                                //Description

                                ProductInfoPages(),

                                EmptySpaceHelper.emptyHight(10),
                                if (Provider.of<ProductDetailsService>(context,
                                                listen: false)
                                            .productDetails!
                                            .vendor !=
                                        null &&
                                    Provider.of<ProductDetailsService>(context,
                                                listen: false)
                                            .productDetails!
                                            .vendor!
                                            .product !=
                                        null &&
                                    Provider.of<ProductDetailsService>(context,
                                            listen: false)
                                        .productDetails!
                                        .vendor!
                                        .product!
                                        .isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                      asProvider.getString("Seller's Products"),
                                      style: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                if (Provider.of<ProductDetailsService>(context,
                                                listen: false)
                                            .productDetails!
                                            .vendor !=
                                        null &&
                                    Provider.of<ProductDetailsService>(context,
                                                listen: false)
                                            .productDetails!
                                            .vendor!
                                            .product !=
                                        null &&
                                    Provider.of<ProductDetailsService>(context,
                                            listen: false)
                                        .productDetails!
                                        .vendor!
                                        .product!
                                        .isNotEmpty)
                                  EmptySpaceHelper.emptyHight(10),

                                const SellersProducts(),
                                if (Provider.of<ProductDetailsService>(context,
                                        listen: false)
                                    .relatedProduct
                                    .isNotEmpty)
                                  EmptySpaceHelper.emptyHight(10),
                                if (Provider.of<ProductDetailsService>(context,
                                        listen: false)
                                    .relatedProduct
                                    .isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                      asProvider.getString("Related Products"),
                                      style: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                EmptySpaceHelper.emptyHight(10),

                                const RelatedProducts(),
                                EmptySpaceHelper.emptyHight(10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ProductDetailsCartButton(itemCount, () {}),
                  ],
                );
              })),
      loadingWidget: const Material(child: ProductDetailsSkeleton()),
      retryFunction: () {
        Navigator.pop(context);
        Provider.of<ProductDetailsService>(context, listen: false)
            .clearProductDetails();
        Navigator.of(context)
            .pushNamed(ProductDetailsView.routeName, arguments: [id, id]);
      },
    );
  }

  subInfo(BuildContext context, String title, String value) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Text(
              '$title:',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            EmptySpaceHelper.emptywidth(5),
            Text(value,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: cc.greyHint,
                    )),
          ],
        ));
  }
}
