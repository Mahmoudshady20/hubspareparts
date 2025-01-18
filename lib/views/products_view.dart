import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:safecart/helpers/empty_space_helper.dart';
import 'package:safecart/services/all_product_service.dart';

import '../../utils/responsive.dart';
import '../../widgets/common/product_card.dart';
import '../../widgets/skelletons/product_card_skeleton.dart';
import '../helpers/common_helper.dart';
import '../services/product_details_service.dart';
import '../services/search_product_service.dart';
import '../utils/custom_preloader.dart';
import 'product_details_view.dart';

class ProductsView extends StatelessWidget {
  static const routeName = 'products_view';
  ProductsView({super.key});
  ScrollController controller = ScrollController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final searchBarFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    controller.addListener((() => scrollListener(context)));
    Provider.of<AllProductsService>(context, listen: false).resetProducts();
    return Consumer<AllProductsService>(builder: (context, apProvider, child) {
      return SizedBox(
        height: screenHeight - 150,
        child: FutureBuilder(
            future: !apProvider.loading && apProvider.allProducts == null
                ? apProvider.fetchProducts(context)
                : null,
            builder: (context, snapshot) {
              return apProvider.loading && apProvider.allProducts == null
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      physics: const NeverScrollableScrollPhysics(),
                      child: GridView.builder(
                        gridDelegate: const FlutterzillaFixedGridView(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            height: 200),
                        padding: EdgeInsets.zero,
                        itemCount: 12,
                        shrinkWrap: true,
                        clipBehavior: Clip.none,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ProductCardSkeleton();
                        },
                      ))
                  : apProvider.allProducts != null &&
                          apProvider.allProducts!.isEmpty
                      ? Center(
                          child: Text(asProvider.getString('No product found')),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: StaggeredGridView.countBuilder(
                                crossAxisCount: 2,
                                controller: controller,
                                itemCount: apProvider.allProducts!.length,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                staggeredTileBuilder: (index) =>
                                    const StaggeredTile.fit(1),
                                // physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final element =
                                      apProvider.allProducts![index];
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Provider.of<ProductDetailsService>(
                                                context,
                                                listen: false)
                                            .clearProductDetails();
                                        Navigator.of(context).pushNamed(
                                            ProductDetailsView.routeName,
                                            arguments: [
                                              element.title,
                                              element.prdId
                                            ]);
                                      },
                                      child: ProductCard(
                                        element.prdId,
                                        element.title ?? "",
                                        element.imgUrl,
                                        element.discountPrice ?? element.price,
                                        element.discountPrice != null
                                            ? (element.price)
                                            : null,
                                        index,
                                        badge: element.badge,
                                        discPercentage: element
                                            .campaignPercentage
                                            ?.toStringAsFixed(2),
                                        cartable: element.isCartAble!,
                                        prodCatData: {
                                          "category": element.categoryId,
                                          "subcategory": element.subCategoryId,
                                          "childcategory":
                                              element.childCategoryIds
                                        },
                                        rating: element.avgRatting,
                                        randomKey: element.randomKey,
                                        randomSecret: element.randomSecret,
                                        stock: element.stockCount,
                                        campaignStock: element.campaignStock,
                                      ));
                                },
                              ),
                            ),
                            if (apProvider.nextLoading)
                              SizedBox(height: 60, child: CustomPreloader()),
                            EmptySpaceHelper.emptyHight(20),
                          ],
                        );
            }),
      );
    });
  }

  scrollListener(BuildContext context) async {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      final apProvider =
          Provider.of<AllProductsService>(context, listen: false);
      if (!apProvider.nextLoading && apProvider.nextPage != null) {
        // apProvider.setNextLoading(true);
        apProvider.fetchNextPageProducts(context);
      }
      // apProvider.setNextLoading(false);

      if (apProvider.nextPage == null) {
        showToast(asProvider.getString('No more product found'), cc.blackColor);
      }
    }
  }
}
