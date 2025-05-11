import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/helpers/common_helper.dart';
import 'package:safecart/helpers/empty_space_helper.dart';

import '../../services/product_details_service.dart';

class ShippingMethods extends StatelessWidget {
  const ShippingMethods({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic sfjkllods = 'home';
    return Consumer<ProductDetailsService>(
        builder: (context, pdProvider, child) {
      return pdProvider.productDetails!.productDeliveryOption == null
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines

                children: [
                  ...pdProvider.productDetails!.productDeliveryOption!
                      .map((e) => Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: cc.greyBorder,
                                )),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                  ),
                                  EmptySpaceHelper.emptyHight(4),
                                  Text(
                                    e.subTitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color: cc.greyHint, fontSize: 12),
                                  ),
                                ]),
                          ))
                ],
              ),
            );
    });
  }
}
