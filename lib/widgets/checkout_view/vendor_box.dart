import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/cart_data_service.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../services/checkout_service/checkout_service.dart';
import '../../services/rtl_service.dart';
import '../../utils/responsive.dart';

class VendorBox extends StatelessWidget {
  final String mapKey;
  const VendorBox({required this.mapKey, super.key});

  @override
  Widget build(BuildContext context) {
    final cdProvider = Provider.of<CartDataService>(context, listen: false);
    return Consumer<CheckoutService>(builder: (context, cProvider, child) {
      var title = mapKey != 'admin'
          ? cProvider.vendorDetailsList!.vendors
              .firstWhere((element) => element.id.toString() == mapKey)
              .businessName
          : cProvider.vendorDetailsList!.defaultVendor.adminShop.storeName;
      var shippingMethods = mapKey != 'admin'
          ? cProvider.vendorDetailsList!.vendors
              .firstWhere((element) => element.id.toString() == mapKey)
              .shippingMethod
          : cProvider.vendorDetailsList!.defaultVendor.shippingMethods;
      double shippingCost =
          cProvider.isShippingMethodSelected(mapKey, shippingMethods)?.cost ??
              00.0;
      num subTotal = cdProvider.calculateVendorSubtotal(mapKey).toDouble();
      int ind = 1;
      num? tax;
      if (rtlProvider.taxSystem == "advance_tax_system") {
        subTotal = cProvider.advanceTaxData[mapKey]?.subTotal ?? 0;
        tax = cProvider.advanceTaxData[mapKey]?.taxAmount ?? 0;
      }
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: cc.greyBorder2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: cc.greyHint,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            EmptySpaceHelper.emptyHight(8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: cc.pureWhite,
              ),
              child: Column(
                  children: productList(context,
                      cdProvider.productListFormVendorId(mapKey), mapKey)),
            ),
            EmptySpaceHelper.emptyHight(10),
            Container(
              height: 56,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: cc.pureWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: cc.greyBorder,
                  width: 1,
                ),
              ),
              child: DropdownButton(
                hint: Text(
                  AppLocalizations.of(context)!.select_a_shipping_method,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: cc.greyHint,
                        fontSize: 14,
                      ),
                ),
                underline: Container(),
                isExpanded: true,
                elevation: 0,
                isDense: true,
                value: cProvider
                    .isShippingMethodSelected(mapKey, shippingMethods)
                    ?.title,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: cc.greyHint,
                      fontSize: 14,
                    ),
                icon: Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: cc.greyHint,
                ),
                onChanged: (value) {
                  cProvider.changeVendorShippingMethod(
                      mapKey, shippingMethods, value);
                },
                items: shippingMethods!.map((value) {
                  return DropdownMenuItem(
                    alignment:
                        Provider.of<RTLService>(context, listen: false).langRtl
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    value: value.title ?? (ind++).toString(),
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(value.title ?? (ind++).toString()),
                            Consumer<RTLService>(
                                builder: (context, lService, child) {
                              return Text(lService.curRtl
                                  ? '${(value.cost ?? 0.0).toStringAsFixed(2)}${lService.currency}'
                                  : '${lService.currency}${(value.cost ?? 0.0).toStringAsFixed(2)}');
                            }),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            EmptySpaceHelper.emptyHight(15),
            moneyRow(
                context,
                AppLocalizations.of(context)!.subtotal,
                rtlProvider.taxSystem != "advance_tax_system"
                    ? cdProvider.calculateVendorSubtotal(mapKey).toDouble()
                    : (cProvider.advanceTaxData[mapKey]?.subTotal ?? 0)
                        .toDouble()),
            EmptySpaceHelper.emptyHight(5),
            Consumer<CheckoutService>(builder: (context, cProvider, child) {
              return moneyRow(
                  context,
                  AppLocalizations.of(context)!.tax,
                  rtlProvider.taxSystem != "advance_tax_system"
                      ? tax?.toDouble() ?? 100 * cProvider.taxPercent
                      : (cProvider.advanceTaxData[mapKey]?.taxAmount ?? 0)
                          .toDouble(),
                  isTax: tax == null);
            }),
            EmptySpaceHelper.emptyHight(5),
            moneyRow(
                context,
                AppLocalizations.of(context)!.shipping_cost,
                cProvider
                        .isShippingMethodSelected(mapKey, shippingMethods)
                        ?.cost ??
                    0.0),
            EmptySpaceHelper.emptyHight(5),
            moneyRow(
                context,
                AppLocalizations.of(context)!.total,
                (rtlProvider.taxSystem != "advance_tax_system"
                        ? ((subTotal) + (subTotal * cProvider.taxPercent))
                        : ((cProvider.advanceTaxData[mapKey]?.subTotal ?? 0) +
                            (cProvider.advanceTaxData[mapKey]?.taxAmount ??
                                0))) +
                    shippingCost),
            EmptySpaceHelper.emptyHight(5),
          ],
        ),
      );
    });
  }

  Widget moneyRow(BuildContext context, String title, double amount,
      {isTax = false}) {
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: cc.greyHint),
          ),
          Text(
            isTax
                ? '${amount.toStringAsFixed(2)}%'
                : rtlProvider.curRtl
                    ? amount.toStringAsFixed(2) + rtlProvider.currency
                    : rtlProvider.currency + amount.toStringAsFixed(2),
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: cc.greyHint),
          ),
        ],
      ),
    );
  }

  List<Widget> productList(BuildContext context, List productList, mapKey) {
    List<Widget> list = [];
    final adt =
        Provider.of<CheckoutService>(context, listen: false).advanceTaxData;
    final prods = {};
    adt[mapKey]?.products.forEach((element) {
      prods.putIfAbsent(element.id.toString(), () => element.price);
    });
    debugPrint(prods.toString());
    for (var e in productList) {
      if (e == null) {
        continue;
      }
      debugPrint("product id is ${e["id"]}".toString());
      String attributes = e['options']['attributes'].toString();
      String attributes2 = attributes.replaceAll('{', '');
      final attributes3 = attributes2.replaceAll('}', '');
      list.add(Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: screenWidth / 2.3,
              child: RichText(
                text: TextSpan(
                    text: e['name'] as String,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: cc.greyHint),
                    children: [
                      if (e['options']['attributes'] != null)
                        TextSpan(
                            text: (' ($attributes3) ').replaceAll('()', '')),
                      const TextSpan(text: 'X'),
                      TextSpan(
                          text: '${e['qty']}',
                          style: const TextStyle(fontWeight: FontWeight.w600))
                    ]),
              ),
            ),
            Consumer<RTLService>(
                builder: (context, lService, child) => Text(
                      lService.curRtl
                          ? '${((rtlProvider.taxSystem != "advance_tax_system" ? (e['price'] as double) : (prods[e["id"].toString()] ?? 1)) * (e['qty'] as int)).toStringAsFixed(2)}${lService.currency}'
                          : '${lService.currency}${((rtlProvider.taxSystem != "advance_tax_system" ? (e['price'] as double) : (prods[e["id"].toString()] ?? 1)) * (e['qty'] as int)).toStringAsFixed(2)}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: cc.greyParagraph),
                    ))
          ],
        ),
      ));
      list.add(EmptySpaceHelper.emptyHight(5));
      // }
    }

    return list;
  }
}
