import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/product_by_campaigns_service.dart';
import 'package:safecart/utils/responsive.dart';
import 'package:safecart/widgets/common/product_card.dart';
import 'package:safecart/widgets/skelletons/product_card_skeleton.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../helpers/common_helper.dart';
import '../services/product_details_service.dart';
import '../services/search_product_service.dart';
import '../widgets/common/custom_app_bar.dart';
import 'product_details_view.dart';

class ProductByCampaignView extends StatelessWidget {
  static const routeName = 'product_by_campaign_view';
  ProductByCampaignView({super.key});
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    controller.addListener((() => scrollListener(context)));
    final routeData = ModalRoute.of(context)!.settings.arguments as List;
    final title = routeData[0];
    final id = routeData[1];
    return Scaffold(
      appBar:
          CustomAppBar().appBarTitled(context, asProvider.getString(title), () {
        Navigator.of(context).pop();
      }, centerTitle: true, color: cc.primaryColor, textColor: cc.pureWhite),
      body: Consumer<ProductByCampaignsService>(
          builder: (context, pbcProvider, child) {
        return Stack(
          children: [
            Container(
              height: screenHeight / 7,
              width: double.infinity,
              color: cc.primaryColor,
            ),
            Column(
              children: [
                Expanded(
                  child: Card(
                    elevation: 3,
                    color: cc.pureWhite,
                    surfaceTintColor: cc.pureWhite,
                    margin: const EdgeInsets.only(
                        left: 10, right: 10, top: 50, bottom: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        child: FutureBuilder(
                            future: !pbcProvider.campaignProductLoading &&
                                    !pbcProvider.dataAlreadyLoaded &&
                                    pbcProvider.campaignProducts == null
                                ? pbcProvider.fetchCampaignProducts(context, id)
                                : null,
                            builder: (context, snapshot) {
                              return !pbcProvider.campaignProductLoading &&
                                      pbcProvider.campaignProducts != null
                                  ? pbcProvider.campaignProducts!.isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 40,
                                              left: 20,
                                              right: 20,
                                              bottom: 20),
                                          child: StaggeredGridView.countBuilder(
                                            crossAxisCount: 2,
                                            controller: controller,
                                            itemCount: pbcProvider
                                                .campaignProducts!.length,
                                            crossAxisSpacing: 12,
                                            mainAxisSpacing: 12,
                                            staggeredTileBuilder: (index) =>
                                                const StaggeredTile.fit(1),
                                            itemBuilder: (context, index) {
                                              final element = pbcProvider
                                                  .campaignProducts![index]!;
                                              return GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                    Provider.of<ProductDetailsService>(
                                                            context,
                                                            listen: false)
                                                        .clearProductDetails();
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            ProductDetailsView
                                                                .routeName,
                                                            arguments: [
                                                          element.title
                                                        ]);
                                                  },
                                                  child: ProductCard(
                                                    element.prdId,
                                                    element.title ?? '',
                                                    element.imgUrl,
                                                    element.discountPrice ??
                                                        element.price,
                                                    element.discountPrice !=
                                                            null
                                                        ? element.price
                                                        : null,
                                                    index,
                                                    badge: element.badge,
                                                    discPercentage: element
                                                        .campaignPercentage
                                                        ?.toStringAsFixed(2),
                                                    cartable:
                                                        element.isCartAble ??
                                                            false,
                                                    prodCatData: {
                                                      "category":
                                                          element.categoryId,
                                                      "subcategory":
                                                          element.subCategoryId,
                                                      "childcategory": element
                                                          .childCategoryIds
                                                    },
                                                    rating: element.avgRatting,
                                                    randomKey:
                                                        element.randomKey,
                                                    randomSecret:
                                                        element.randomSecret,
                                                    stock: element.stockCount,
                                                    campaignStock:
                                                        element.campaignStock,
                                                  ));
                                            },
                                          ),
                                        )
                                      : SizedBox(
                                          height: screenHeight - 200,
                                          width: double.infinity,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(asProvider
                                                  .getString('No item found')),
                                            ],
                                          ),
                                        )
                                  : StaggeredGridView.countBuilder(
                                      crossAxisCount: 2,
                                      controller: controller,
                                      itemCount: 10,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      padding: const EdgeInsets.all(20),
                                      staggeredTileBuilder: (index) =>
                                          const StaggeredTile.fit(1),
                                      itemBuilder: (context, index) {
                                        return ProductCardSkeleton();
                                      },
                                    );
                            }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                if (!pbcProvider.campaignProductLoading)
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: FittedBox(
                          child: SlideCountdownSeparated(
                            showZeroValue: true,
                            separator: '',
                            decoration: BoxDecoration(
                              color: cc.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(color: Colors.black38, blurRadius: 3)
                              ],
                            ),
                            duration: pbcProvider.campaignInfo != null &&
                                    pbcProvider.campaignInfo!.endDate != null &&
                                    pbcProvider.campaignInfo!.endDate!
                                        .isAfter(DateTime.now())
                                ? pbcProvider.campaignInfo!.endDate!
                                    .difference(DateTime.now())
                                : const Duration(seconds: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      }),
    );
  }

  scrollListener(BuildContext context) async {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      Provider.of<SearchProductService>(context, listen: false)
          .setNextLoading(true);
      Provider.of<SearchProductService>(context, listen: false)
          .setNextLoading(false);
      showToast(asProvider.getString('No more product found'), cc.blackColor);
    }
  }
}
