import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/views/all_categories_view.dart';
import 'package:safecart/widgets/common/product_slider.dart';

import '../../helpers/empty_space_helper.dart';
import '../../services/home_categories_service.dart';
import '../../widgets/skelletons/homepage_title_skeleton.dart';
import '../common/title_common.dart';
import '../skelletons/category_chip_skeleton.dart';
import '../skelletons/product_card_skeleton.dart';
import 'category_chip.dart';

class CategoriesAndProducts extends StatelessWidget {
  const CategoriesAndProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<HomeCategoriesService>(builder: (context, hcProvider, child) {
          return !hcProvider.categoryLoading
              ? hcProvider.categories != null &&
                      hcProvider.categories!.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TitleCommon(
                        AppLocalizations.of(context)!.hot_Items,
                        () {
                          Navigator.of(context)
                              .pushNamed(AllCategoriesView.routeName);
                        },
                      ),
                    )
                  : const SizedBox()
              : const HomePageTitleSkeleton();
        }),
        Consumer<HomeCategoriesService>(builder: (context, hcProvider, child) {
          return !hcProvider.categoryLoading
              ? const SizedBox()
              : EmptySpaceHelper.emptyHight(20);
        }),
        Consumer<HomeCategoriesService>(builder: (context, hcProvider, child) {
          return !hcProvider.categoryLoading && hcProvider.categories != null
              ? hcProvider.categories!.isNotEmpty
                  ? SizedBox(
                      height: 40,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return CategoryChip(
                              hcProvider.categories![index]!.name!,
                              hcProvider.categories![index] ==
                                  hcProvider.selectedCategory,
                              onTap: () {
                                hcProvider.setSelectedCategory(
                                    hcProvider.categories![index]!);
                              },
                            );
                          },
                          separatorBuilder: (context, index) =>
                              EmptySpaceHelper.emptywidth(15),
                          itemCount: hcProvider.categories!.length))
                  : const SizedBox()
              : SizedBox(
                  height: 40,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return const CategoryChipSkeleton();
                      },
                      separatorBuilder: (context, index) =>
                          EmptySpaceHelper.emptywidth(15),
                      itemCount: 5),
                );
        }),
        EmptySpaceHelper.emptyHight(15),
        Consumer<HomeCategoriesService>(builder: (context, hcProvider, child) {
          return hcProvider.selectedCategory != null
              ? !hcProvider.categoryProductLoading
                  ? hcProvider.categoryProducts!.isNotEmpty
                      ? ProductSlider(hcProvider.categoryProducts)
                      : const SizedBox()
                  : SizedBox(
                      height: 260,
                      child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ProductCardSkeleton();
                          },
                          separatorBuilder: (context, index) =>
                              EmptySpaceHelper.emptywidth(20),
                          itemCount: 3),
                    )
              : const SizedBox();
        }),
      ],
    );
  }
}
