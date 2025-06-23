import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:provider/provider.dart';
import 'package:safecart/utils/custom_preloader.dart';

import '../helpers/common_helper.dart';
import '../services/home_categories_service.dart';
import '../services/search_product_service.dart';
import '../utils/responsive.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/home_view/category_chip.dart';
import 'product_by_category_view.dart';

class AllCategoriesView extends StatelessWidget {
  static const routeName = 'all_categoris_view';
  AllCategoriesView({super.key});

  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    screenSizeAndPlatform(context);
    // final routeData =
    //     ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    // final data = routeData[0];
    // final title = routeData[1];
    double cardWidth = screenWidth / 3.3;
    double cardHeight = 60;
    controller.addListener((() => scrollListener(context)));
    return Scaffold(
      appBar: CustomAppBar()
          .appBarTitled(context, AppLocalizations.of(context)!.categories, () {
        controller.dispose();
        Navigator.of(context).pop();
      }),
      body:
          Consumer<HomeCategoriesService>(builder: (context, cProvider, child) {
        return Column(
          children: [
            Expanded(
              child: cProvider.categories != null
                  ? Consumer<HomeCategoriesService>(
                      builder: (context, cProvider, child) {
                      return newMethod(
                          cardWidth, cardHeight, cProvider.categories!);
                    })
                  : FutureBuilder(
                      future: null,
                      builder: ((context, snapshot) {
                        // snackBar(context, 'Timeout!');
                        return Center(
                          child: Text(
                            AppLocalizations.of(context)!.something_went_wrong,
                            style: TextStyle(color: cc.greyHint),
                          ),
                        );
                      }),
                    ),
            ),
            if (cProvider.categories!.isEmpty)
              SizedBox(height: 60, child: CustomPreloader())
          ],
        );
      }),
      // bottomNavigationBar: CustomNavigationBar(),
    );
  }

  Widget newMethod(double cardWidth, double cardHeight, List<dynamic> data) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          // 'No data has been found!',
          '',
          style: TextStyle(color: cc.greyHint),
        ),
      );
    } else {
      return GridView.builder(
        // controller: controller,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.only(left: 20, top: 15, right: 20),
        gridDelegate: const FlutterzillaFixedGridView(
            crossAxisCount: 2,
            height: 55,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final element = data[index];
          // if (srData.resultMeta!.lastPage >= pageNo) {
          return GestureDetector(
              onTap: () {},
              child: CategoryChip(
                element.name,
                false,
                onTap: () {
                  Provider.of<SearchProductService>(context, listen: false)
                      .setFilterOptions(catVal: data[index]!.name);
                  Provider.of<SearchProductService>(context, listen: false)
                      .fetchProducts(context);
                  Navigator.of(context).pushNamed(
                      ProductByCategoryView.routeName,
                      arguments: [data[index]!.name!]);
                },
              ));
          // }
          // else {
          //   return const Center(
          //     child: Text('No more product fonund'),
          //   );
          // }
          // else if (srData.resultMeta!.lastPage > pageNo) {
          //   return const Center(
          //       child: Text('No more product available!'));
          // }
        },
      );
    }
  }

  scrollListener(BuildContext context) {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      // Provider.of<SearchResultDataService>(context, listen: false)
      //     .setIsLoading(true);

      // Provider.of<SearchResultDataService>(context, listen: false)
      //     .fetchProductsBy(
      //         pageNo:
      //             Provider.of<SearchResultDataService>(context, listen: false)
      //                 .pageNumber
      //                 .toString())
      //     .then((value) {
      //   if (value != null) {
      //     snackBar(context, value);
      //   }
      // });
      // Provider.of<SearchResultDataService>(context, listen: false).nextPage();
    }
  }

  Future<bool> showTimout() async {
    await Future.delayed(const Duration(seconds: 10));
    return true;
  }
}
