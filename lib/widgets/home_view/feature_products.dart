import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/feature_products_service.dart';
import 'package:safecart/widgets/common/product_slider.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import 'package:safecart/views/feature_products_view.dart';
import '../common/title_common.dart';
import '../skelletons/homepage_title_skeleton.dart';
import '../skelletons/product_card_skeleton.dart';

class FeatureProducts extends StatelessWidget {
  const FeatureProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FeatureProductsService>(
        builder: (context, fpProvider, child) {
      return Column(
        children: [
          Consumer<FeatureProductsService>(
              builder: (context, fpProvider, child) {
            return !fpProvider.featureProductsLoading
                ? fpProvider.featureProductsList != null &&
                        fpProvider.featureProductsList!.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TitleCommon(
                          asProvider.getString('Featured Items'),
                          () {
                            Navigator.of(context)
                                .pushNamed(FeatureProductsView.routeName);
                          },
                          seeAll: true,
                        ),
                      )
                    : const SizedBox()
                : const HomePageTitleSkeleton();
          }),
          Consumer<FeatureProductsService>(
              builder: (context, fpProvider, child) {
            return !fpProvider.featureProductsLoading
                ? const SizedBox()
                : EmptySpaceHelper.emptyHight(20);
          }),
          FutureBuilder(
            future: fpProvider.featureProductsList == null &&
                    !fpProvider.featureProductsLoading
                ? fpProvider.fetchFeatureProducts(context)
                : null,
            builder: (context, snapshot) {
              if (snapshot.hasError) {}
              int index = 0;
              return !fpProvider.featureProductsLoading &&
                      fpProvider.featureProductsList != null
                  ? fpProvider.featureProductsList!.isNotEmpty
                      ? ProductSlider(fpProvider.featureProductsList)
                      : const SizedBox()
                  : SizedBox(
                      height: 260,
                      child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          itemBuilder: (context, index) {
                            return ProductCardSkeleton();
                          },
                          separatorBuilder: (context, index) =>
                              EmptySpaceHelper.emptywidth(20),
                          itemCount: 3),
                    );
            },
          ),
          Consumer<FeatureProductsService>(
              builder: (context, fpProvider, child) {
            return !fpProvider.featureProductsLoading
                ? const SizedBox()
                : EmptySpaceHelper.emptyHight(15);
          }),
        ],
      );
    });
  }
}
