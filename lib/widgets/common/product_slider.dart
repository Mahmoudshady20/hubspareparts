import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/settings_services.dart';
import 'package:safecart/utils/responsive.dart';
import 'package:safecart/widgets/common/product_card.dart';

import '../../helpers/empty_space_helper.dart';

class ProductSlider extends StatelessWidget {
  final productList;
  final shouldPop;

  const ProductSlider(this.productList, {super.key, this.shouldPop = false});

  @override
  Widget build(BuildContext context) {
    int index = 0;
    final SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Container(
            constraints: BoxConstraints(minWidth: screenWidth - 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...productList!.map((element) {
                  return Row(
                    children: [
                      ProductCard(
                        element!.prdId,
                        settingsProvider.myLocal == Locale('ar')
                            ? element.titleAr ?? element.title ?? ''
                            : element.title ?? '',
                        element.imgUrl,
                        element.discountPrice ?? element.price,
                        element.discountPrice != null ? (element.price) : null,
                        index++,
                        badge: element.badge,
                        discPercentage:
                            element.campaignPercentage?.toStringAsFixed(2),
                        cartable: element.isCartAble!,
                        prodCatData: {
                          "category": element.categoryId,
                          "subcategory": element.subCategoryId,
                          "childcategory": element.childCategoryIds
                        },
                        rating: element.avgRatting,
                        endDate: element.endDate,
                        randomKey: element.randomKey,
                        randomSecret: element.randomSecret,
                        shouldPop: shouldPop,
                        stock: element.stockCount,
                        campaignStock: element.campaignStock,
                        vendorId: element.vendorId,
                      ),
                      EmptySpaceHelper.emptywidth(20),
                    ],
                  );
                }).toList()
              ],
            ),
          ),
        ),
      ],
    );
  }
}
