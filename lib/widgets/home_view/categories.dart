import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/home_categories_service.dart';
import 'package:safecart/services/search_product_service.dart';
import 'package:safecart/views/product_by_category_view.dart';
import 'package:safecart/widgets/home_view/category_card.dart';

import '../../helpers/empty_space_helper.dart';
import '../common/title_common.dart';
import '../skelletons/category_card_skeleton.dart';
import '../skelletons/homepage_title_skeleton.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    final hCatProvider =
        Provider.of<HomeCategoriesService>(context, listen: false);
    return SizedBox(
      child: Column(
        children: [
          Consumer<HomeCategoriesService>(
              builder: (context, hcProvider, child) {
            return !hcProvider.categoryLoading
                ? hcProvider.categories != null &&
                        hcProvider.categories!.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TitleCommon(
                          AppLocalizations.of(context)!.categories,
                          () {},
                          seeAll: false,
                        ),
                      )
                    : const SizedBox()
                : const HomePageTitleSkeleton();
          }),
          Consumer<HomeCategoriesService>(
              builder: (context, hcProvider, child) {
            return hcProvider.categoryLoading ||
                    (hcProvider.categories != null &&
                        hcProvider.categories!.isNotEmpty)
                ? EmptySpaceHelper.emptyHight(20)
                : const SizedBox();
          }),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: FutureBuilder(
              future: (!hCatProvider.categoryLoading) &&
                      hCatProvider.categories == null
                  ? hCatProvider.fetchHomeCategories(context)
                  : null,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return const CategoryCardSkeleton();
                      },
                      itemCount: 5);
                }
                return Consumer<HomeCategoriesService>(
                    builder: (context, cProvider, child) {
                  return cProvider.categories != null &&
                          cProvider.categories!.isNotEmpty
                      ? Container(
                          constraints: const BoxConstraints(maxHeight: 108),
                          child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              physics: const BouncingScrollPhysics(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Provider.of<SearchProductService>(context,
                                            listen: false)
                                        .setFilterOptions(
                                            catVal: cProvider
                                                .categories![index]!.name);
                                    Provider.of<SearchProductService>(context,
                                            listen: false)
                                        .fetchProducts(context);
                                    Navigator.of(context).pushNamed(
                                        ProductByCategoryView.routeName,
                                        arguments: [
                                          cProvider.categories![index]!.name!
                                        ]);
                                  },
                                  child: CategoryCard(
                                    cProvider.categories![index]!.name!,
                                    cProvider.categories![index]!.imageUrl,
                                  ),
                                );
                              },
                              itemCount: cProvider.categories!.length),
                        )
                      : const SizedBox();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
