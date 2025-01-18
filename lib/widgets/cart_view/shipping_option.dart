import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/common_helper.dart';
import '../../services/common_services.dart';
import '../../services/rtl_service.dart';

class ShippingOption extends StatelessWidget {
  ShippingOption({super.key});

  @override
  Widget build(BuildContext context) {
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    return ExpandablePanel(
        controller: ExpandableController(initialExpanded: false),
        theme: const ExpandableThemeData(hasIcon: false),
        collapsed: const Text(''),
        header: Container(
          padding: const EdgeInsets.only(bottom: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  asProvider.getString('Apply shipping'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: cc.greyParagraph,
                ),
              )
            ],
          ),
        ),
        expanded: Container(
            //Dropdown
            margin: const EdgeInsets.only(bottom: 20, top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
                children: shippingMethode
                    .map((e) => ListTile(
                          leading: Consumer<CommonServices>(
                              builder: (context, csProvider, child) {
                            return Transform.scale(
                              scale: 1.3,
                              child: Checkbox(
                                value: csProvider.amount == e['amount'],
                                onChanged: (value) =>
                                    Provider.of<CommonServices>(context,
                                            listen: false)
                                        .setShippingAmount(e['amount']),
                              ),
                            );
                          }),
                          title: Text(e['title'],
                              style: Theme.of(context).textTheme.titleMedium),
                          subtitle: Text(
                            e['subtitle'],
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: cc.greyHint),
                          ),
                          trailing: Text(
                            rtlProvider.curRtl
                                ? e['amount'].toString() + rtlProvider.currency
                                : rtlProvider.currency + e['amount'].toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          dense: false,
                        ))
                    .toList())));
  }

  List shippingMethode = [
    {
      'title': 'Free Shipping',
      'subtitle': 'Shipment will be within 10-15 Days',
      'amount': 0,
    },
    {
      'title': 'Standard Shipping',
      'subtitle': 'Shipment will be within 5-10 Day',
      'amount': 5,
    },
    {
      'title': '2-Day Shipping',
      'subtitle': 'Shipment will be within 2 Days.',
      'amount': 10,
    },
    {
      'title': 'Same day delivery',
      'subtitle': 'Shipment will be within 1 Day.',
      'amount': 50,
    },
  ];
}
