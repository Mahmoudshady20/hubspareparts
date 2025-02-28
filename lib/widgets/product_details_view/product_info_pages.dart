import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/product_details_service.dart';
import 'package:safecart/utils/responsive.dart';
import 'package:safecart/widgets/product_details_view/description.dart';
import 'package:safecart/widgets/product_details_view/reviews.dart';

import '../../helpers/common_helper.dart';

class ProductInfoPages extends StatelessWidget {
  ProductInfoPages({super.key});
  final List pageNames = [
    'Description',
    'Reviews',
  ];
  SwiperController? controller = SwiperController();
  final pages = [const Description(), Reviews()];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<ProductDetailsService>(builder: (context, pdProvider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: pageNames.map((e) {
                  final index = pageNames.indexOf(e);
                  return GestureDetector(
                    onTap: () {
                      pdProvider.setCurrentInfoPage(index);
                    },
                    child: SizedBox(
                      height: 80,
                      width: (screenWidth - 40) / 2,
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: Text(
                              asProvider.getString(e),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: pdProvider.currentInfoPage == index
                                          ? cc.primaryColor
                                          : null),
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          Divider(
                            color: pdProvider.currentInfoPage == index
                                ? cc.primaryColor
                                : cc.greyBorder,
                            thickness: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList()),
          );
        }),
        Consumer<ProductDetailsService>(builder: (context, pdProvider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: pages[pdProvider.currentInfoPage],
          );
        })
      ],
    );
  }
}
