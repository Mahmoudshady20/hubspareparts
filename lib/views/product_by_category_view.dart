import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:safecart/services/settings_services.dart';
import 'package:safecart/utils/custom_preloader.dart';
import 'package:safecart/widgets/common/product_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../helpers/common_helper.dart';
import '../services/product_details_service.dart';
import '../services/search_product_service.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/skelletons/product_card_skeleton.dart';
import 'product_details_view.dart';

class ProductByCategoryView extends StatelessWidget {
  static const routeName = 'product_by_category_view';
  ProductByCategoryView({super.key});
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    controller.addListener((() => scrollListener(context)));
    final routeData = ModalRoute.of(context)!.settings.arguments as List;
    final title = routeData.first;
    final SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: CustomAppBar().appBarTitled(context, title, () {
        Provider.of<SearchProductService>(context, listen: false)
            .setFilterOptions(catVal: '');
        Navigator.of(context).pop();
      }),
      body: WillPopScope(
        onWillPop: () async {
          Provider.of<SearchProductService>(context, listen: false)
              .setFilterOptions(catVal: '');
          return true;
        },
        child: Consumer<SearchProductService>(
            builder: (context, saProvider, child) {
          return Column(
            children: [
              Expanded(
                child: saProvider.loading || saProvider.searchedProduct == null
                    ? SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        physics: const NeverScrollableScrollPhysics(),
                        child: GridView.builder(
                          gridDelegate: const FlutterzillaFixedGridView(
                              crossAxisCount: 2,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 15,
                              height: 200),
                          itemCount: 12,
                          shrinkWrap: true,
                          clipBehavior: Clip.none,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ProductCardSkeleton();
                          },
                        ))
                    : saProvider.searchedProduct != null &&
                            saProvider.searchedProduct!.isEmpty
                        ? Center(
                            child:
                                Text(AppLocalizations.of(context)!.no_more_product_found),
                          )
                        : StaggeredGridView.countBuilder(
                            crossAxisCount: 2,
                            controller: controller,
                            itemCount: saProvider.searchedProduct!.length,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            padding: const EdgeInsets.all(20),
                            staggeredTileBuilder: (index) =>
                                const StaggeredTile.fit(1),
                            // physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final element =
                                  saProvider.searchedProduct![index];
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Provider.of<ProductDetailsService>(context,
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
                                    settingsProvider.myLocal == Locale('ar')
                                        ? element.titleAr ?? element.title ?? ''
                                        : element.title ?? '',
                                    element.imgUrl,
                                    element.discountPrice ?? element.price,
                                    element.discountPrice != null
                                        ? (element.price)
                                        : null,
                                    index,
                                    badge: element.badge,
                                    discPercentage: element.campaignPercentage
                                        ?.toStringAsFixed(2),
                                    cartable: element.isCartAble!,
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
                          ),
              ),
              if (saProvider.nextLoading)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(height: 60, child: CustomPreloader()),
                ),
            ],
          );
        }),
      ),
    );
  }

  scrollListener(BuildContext context) async {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      final saProvider =
          Provider.of<SearchProductService>(context, listen: false);
      if (!saProvider.nextLoading && saProvider.nextPage != null) {
        // saProvider.setNextLoading(true);
        saProvider.fetchNextPageProducts(context);
      }
      // saProvider.setNextLoading(false);

      if (saProvider.nextPage == null) {
        showToast(AppLocalizations.of(context)!.no_more_product_found, cc.blackColor);
      }
    }
  }
}
