import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/feature_products_service.dart';
import 'package:safecart/services/settings_services.dart';
import 'package:safecart/widgets/common/product_card.dart';

import '../services/product_details_service.dart';
import '../widgets/common/custom_app_bar.dart';
import 'product_details_view.dart';

class FeatureProductsView extends StatelessWidget {
  static const routeName = 'feature_products_view';
  FeatureProductsView({super.key});
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    // controller.addListener((() => scrollListener(context)));
    final SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: CustomAppBar().appBarTitled(
          context, AppLocalizations.of(context)!.feature_Items, () {
        Navigator.of(context).pop();
      }),
      body: Consumer<FeatureProductsService>(
          builder: (context, fpProvider, child) {
        return Column(
          children: [
            Expanded(
                child: StaggeredGridView.countBuilder(
              crossAxisCount: 2, controller: controller,
              itemCount: fpProvider.featureProductsList!.length,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              padding: const EdgeInsets.all(20),
              staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
              // physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final element = fpProvider.featureProductsList![index]!;
                return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Provider.of<ProductDetailsService>(context, listen: false)
                          .clearProductDetails();
                      Navigator.of(context).pushNamed(
                          ProductDetailsView.routeName,
                          arguments: [element.title]);
                    },
                    child: ProductCard(
                      element.prdId,
                      settingsProvider.myLocal == Locale('ar')
                          ? element.titleAr ?? element.title ?? ''
                          : element.title ?? '',
                      element.imgUrl,
                      element.discountPrice ?? element.price,
                      element.discountPrice != null ? element.price : null,
                      index,
                      badge: element.badge,
                      discPercentage:
                          element.campaignPercentage?.toStringAsFixed(2),
                      cartable: element.isCartAble ?? false,
                      prodCatData: {
                        "category": element.categoryId,
                        "subcategory": element.subCategoryId,
                        "childcategory": element.childCategoryIds
                      },
                      rating: element.avgRatting,
                      randomKey: element.randomKey,
                      randomSecret: element.randomSecret,
                      stock: element.stockCount,
                      campaignStock: element.campaignStock,
                    ));
              },
            )),
            // if (fpProvider.)
            //   Padding(
            //     padding: const EdgeInsets.only(bottom: 10),
            //     child: CustomPreloader(),
            //   ),
          ],
        );
      }),
    );
  }

  // scrollListener(BuildContext context) async {
  //   if (controller.offset >= controller.position.maxScrollExtent &&
  //       !controller.position.outOfRange) {
  //     ScaffoldMessenger.of(context).removeCurrentSnackBar();
  //     Provider.of<SearchProductService>(context, listen: false)
  //         .setNextLoading(true);
  //     await Future.delayed(const Duration(seconds: 1));
  //     Provider.of<SearchProductService>(context, listen: false)
  //         .setNextLoading(false);
  //     // Provider.of<SearchResultDataService>(context, listen: false)
  //     //     .setIsLoading(true);

  //     // Provider.of<SearchResultDataService>(context, listen: false)
  //     //     .fetchProductsBy(
  //     //         pageNo:
  //     //             Provider.of<SearchResultDataService>(context, listen: false)
  //     //                 .pageNumber
  //     //                 .toString())
  //     //     .then((value) {
  //     //   if (value != null) {
  //     //     snackBar(context, value);
  //     //   }
  //     // });
  //     // Provider.of<SearchResultDataService>(context, listen: false).nextPage();
  //     // showToast(asProvider.getString('No more product found'), cc.blackColor);
  //   }
  // }
}
