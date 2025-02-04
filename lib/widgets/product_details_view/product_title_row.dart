import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/product_details_service.dart';
import 'package:safecart/services/rtl_service.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';

class ProductTitleRow extends StatelessWidget {
  const ProductTitleRow({super.key});

  @override
  Widget build(BuildContext context) {
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    return Consumer<ProductDetailsService>(
        builder: (context, pdProvider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              // width: screenWidth / 1.65,
              child: Text(
                pdProvider.productDetails == null
                    ? ''
                    : pdProvider.productDetails!.name!,
                maxLines: 2,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
            EmptySpaceHelper.emptyHight(12),
            SizedBox(
              // width: (screenWidth - ((screenWidth / 1.65) + 45)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          rtlProvider.curRtl
                              ? '${pdProvider.productSalePrice}${rtlProvider.currency}'
                              : '${rtlProvider.currency}${(pdProvider.productSalePrice).toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: cc.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                        ),
                        EmptySpaceHelper.emptywidth(5),
                        if (pdProvider.productDetails!.campaignProduct != null)
                          Text(
                            rtlProvider.curRtl
                                ? '${pdProvider.productDetails!.salePrice.toStringAsFixed(2)}${rtlProvider.currency}'
                                : '${rtlProvider.currency}${pdProvider.productDetails!.salePrice.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color: cc.greyHint,
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: cc.cardGreyHint,
                                  decorationStyle: TextDecorationStyle.solid,
                                ),
                          ),
                      ],
                    ),
                  ),
                  EmptySpaceHelper.emptyHight(5),
                  FittedBox(
                    child: Row(
                      children: [
                        Text(
                          '${AppLocalizations.of(context)!.sold_count} :',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: cc.greyHint, fontSize: 14),
                        ),
                        EmptySpaceHelper.emptywidth(5),
                        Text(
                          (pdProvider.productDetails!.soldCount ?? '0')
                              .toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: cc.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
