import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'
    as stgv;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/search_filter_data_service.dart';
import 'package:safecart/services/settings_services.dart';

import '../helpers/common_helper.dart';
import '../helpers/empty_space_helper.dart';
import '../services/product_details_service.dart';
import '../services/search_product_service.dart';
import '../services/search_seatvice.dart';
import '../utils/custom_preloader.dart';
import '../utils/responsive.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/common/product_card.dart';
import '../widgets/search_view/filter_bottom_sheeet.dart';
import '../widgets/skelletons/product_card_skeleton.dart';
import 'product_details_view.dart';

class ProductSearchView extends StatelessWidget {
  static const routeName = 'product_search_view';
  ProductSearchView({super.key});
  ScrollController controller = ScrollController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final searchBarFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    controller.addListener((() => scrollListener(context)));
    final SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar().appBarTitled(context, '', () {
        searchBarFocusNode.unfocus();
        Provider.of<SearchService>(context, listen: false)
            .setShowSearchBar(false);
        Provider.of<SearchProductService>(context, listen: false)
            .resetFilterOptions();
        Provider.of<SearchProductService>(context, listen: false).resetSearch();
        Provider.of<SearchFilterDataService>(context, listen: false)
            .resetSelectedSearchFilter();
        Provider.of<SearchFilterDataService>(context, listen: false)
            .resetSelectedSearchFilter();
        Navigator.pop(context);
      }, actions: [
        GestureDetector(
          onTap: () async {
            searchBarFocusNode.unfocus();
            final saProvider =
                Provider.of<SearchProductService>(context, listen: false);
            final sfdProvider =
                Provider.of<SearchFilterDataService>(context, listen: false);
            await sfdProvider.fetchCategories();
            // sfdProvider.setSelectedCategory(saProvider.selectedCategory);
            // sfdProvider.setSelectedSubCategory(saProvider.selectedSubCategory);
            // sfdProvider.setSelectedChildCats(saProvider.selectedChildCats);
            sfdProvider.setFilterAccordingToSearch(
              cat: saProvider.selectedCategory,
              subCat: saProvider.selectedSubCategory,
              childCat: saProvider.selectedChildCats,
              color: saProvider.selectedColor,
              size: saProvider.selectedSize,
              brand: saProvider.selectedBrand,
              rating: saProvider.selectedRating,
              minPrize: (saProvider.selectedMinPrice ?? '') == '' ||
                      saProvider.selectedMinPrice == 'null'
                  ? null
                  : double.parse(saProvider.selectedMinPrice),
              maxPrize: (saProvider.selectedMaxPrice ?? '') == '' ||
                      saProvider.selectedMaxPrice == 'null'
                  ? null
                  : double.parse(saProvider.selectedMaxPrice),
            );

            // sfdProvider.setSelectedColor(saProvider.selectedColor);
            // sfdProvider.setSelectedBrand(saProvider.selectedBrand);
            // sfdProvider.setSelectedSize(saProvider.selectedSize);
            // print(saProvider.selectedRating);
            // sfdProvider.setSelectedRating(saProvider.selectedRating);
            // print((saProvider.selectedMinPrice ?? ''));
            // print(saProvider.selectedMaxPrice);
            // sfdProvider.setSelectedMinPrice(
            //     (saProvider.selectedMinPrice ?? '') == '' ||
            //             saProvider.selectedMinPrice == 'null'
            //         ? null
            //         : double.parse(saProvider.selectedMinPrice));
            // sfdProvider.setSelectedMaxPrice(
            //     (saProvider.selectedMaxPrice ?? '') == '' ||
            //             saProvider.selectedMaxPrice == 'null'
            //         ? null
            //         : double.parse(saProvider.selectedMaxPrice));
            scaffoldKey.currentState!.openEndDrawer();

            // showMaterialModalBottomSheet(
            //   context: context,
            //   builder: (context) => SingleChildScrollView(
            //     controller: ModalScrollController.of(context),
            //     scrollDirection: Axis.horizontal,

            //     child: Container(
            //       height: 300,
            //     ),
            //     // child: const FilterBottomSheet(),
            //   ),
            // );
          },
          child: Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: cc.greyFive,
                width: 1.5,
              ),
              color: cc.pureWhite,
            ),
            child: SvgPicture.asset(
              'assets/icons/filter.svg',
              color: cc.blackColor,
            ),
          ),
        )
      ]),
      endDrawer: Container(
          width: screenWidth / 1.2,
          height: screenHeight,
          color: Colors.white,
          child: FilterBottomSheet(scaffoldKey)),
      endDrawerEnableOpenDragGesture: false,
      body: WillPopScope(
        onWillPop: () async {
          Provider.of<SearchService>(context, listen: false)
              .setShowSearchBar(false);
          Provider.of<SearchProductService>(context, listen: false)
              .resetFilterOptions();
          Provider.of<SearchProductService>(context, listen: false)
              .resetSearch();
          Provider.of<SearchFilterDataService>(context, listen: false)
              .resetSelectedSearchFilter();
          return true;
        },
        child: Consumer<SearchProductService>(
            builder: (context, saProvider, child) {
          return Column(
            children: [
              EmptySpaceHelper.emptyHight(10),
              Consumer<SearchService>(builder: (context, sProvider, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    focusNode: searchBarFocusNode,
                    initialValue: saProvider.selectedName,
                    textAlign: TextAlign.justify,
                    decoration: InputDecoration(
                      hintText:
                          AppLocalizations.of(context)!.search_your_need_here,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          'assets/icons/only_search.svg',
                          color: cc.greyHint,
                        ),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          saProvider.fetchProducts(context);
                          searchBarFocusNode.unfocus();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: cc.greyHint,
                          ),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      saProvider.setFilterOptions(nameVal: value);
                    },
                    onFieldSubmitted: (value) {
                      saProvider.fetchProducts(context);
                      searchBarFocusNode.unfocus();
                    },
                  ),
                );
              }),
              Expanded(
                child: FutureBuilder(
                    future: !saProvider.loading &&
                            saProvider.searchedProduct == null
                        ? saProvider.fetchProducts(context)
                        : null,
                    builder: (context, snapshot) {
                      return saProvider.loading &&
                              saProvider.searchedProduct == null
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
                                  child: Text(AppLocalizations.of(context)!
                                      .no_more_product_found),
                                )
                              : stgv.StaggeredGridView.countBuilder(
                                  crossAxisCount: 2, controller: controller,
                                  itemCount: saProvider.searchedProduct!.length,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  padding: const EdgeInsets.all(20),
                                  staggeredTileBuilder: (index) =>
                                      const stgv.StaggeredTile.fit(1),
                                  // physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final element =
                                        saProvider.searchedProduct![index];
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
                                          settingsProvider.myLocal == Locale('ar')
                                              ? element.titleAr ?? element.title ?? ''
                                              : element.title ?? '',
                                          element.imgUrl,
                                          element.discountPrice ??
                                              element.price,
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
                                            "subcategory":
                                                element.subCategoryId,
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
                                );
                    }),
              ),
              if (saProvider.nextLoading)
                SizedBox(
                    height: 50,
                    child: SizedBox(height: 60, child: CustomPreloader())),
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
        showToast(
            AppLocalizations.of(context)!.no_more_product_found, cc.blackColor);
      }
    }
  }
}
