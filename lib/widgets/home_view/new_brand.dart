import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/search_product_service.dart';
import 'package:safecart/views/product_by_category_view.dart';
import 'package:safecart/widgets/home_view/brand_card.dart';

import '../../helpers/empty_space_helper.dart';
import '../../services/payment/home_brand_services.dart';
import '../common/title_common.dart';
import '../skelletons/category_card_skeleton.dart';

class NewBrand extends StatelessWidget {
  const NewBrand({super.key});

  @override
  Widget build(BuildContext context) {
    final hBrandProvider =
        Provider.of<HomeBrandService>(context, listen: false);
    return SizedBox(
      child: Column(
        children: [
          Consumer<HomeBrandService>(builder: (context, hcProvider, child) {
            return hcProvider.brandModel?.brands != null &&
                    hcProvider.brandModel!.brands!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TitleCommon(
                      AppLocalizations.of(context)!.brands,
                      () {},
                      seeAll: false,
                    ),
                  )
                : const SizedBox();
          }),
          Consumer<HomeBrandService>(builder: (context, hcProvider, child) {
            return (hcProvider.brandModel?.brands != null &&
                    hcProvider.brandModel!.brands!.isNotEmpty)
                ? EmptySpaceHelper.emptyHight(20)
                : const SizedBox();
          }),
          SizedBox(
            child: FutureBuilder(
              future: hBrandProvider.brandModel == null
                  ? hBrandProvider.fetchHomeBrands(context)
                  : null,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return const CategoryCardSkeleton();
                      },
                      itemCount: 5);
                }
                return Consumer<HomeBrandService>(
                    builder: (context, cProvider, child) {
                  return cProvider.brandModel != null &&
                          cProvider.brandModel!.brands!.isNotEmpty
                      ? Container(
                          constraints: const BoxConstraints(maxHeight: 108),
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Provider.of<SearchProductService>(context,
                                          listen: false)
                                      .setFilterOptions(
                                          brandVal: cProvider
                                              .brandModel!.brands![index].name);
                                  Provider.of<SearchProductService>(context,
                                          listen: false)
                                      .fetchProducts(context);
                                  Navigator.of(context).pushNamed(
                                      ProductByCategoryView.routeName,
                                      arguments: [
                                        cProvider
                                            .brandModel!.brands![index].name!
                                      ]);
                                },
                                child: BrandCard(
                                  cProvider.brandModel!.brands![index].name!,
                                  cProvider
                                      .brandModel!.brands![index].imageUrl!,
                                ),
                              );
                            },
                            itemCount: cProvider.brandModel!.brands!.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              width: 10,
                            ),
                          ),
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
