import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../services/rtl_service.dart';

class OrderInfo extends StatelessWidget {
  const OrderInfo({super.key});
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      initialExpanded: false,
      child: ExpandablePanel(
          // controller: _expandableController,
          // theme: const ExpandableThemeData(hasIcon: false),
          collapsed: const Text(''),
          header: Container(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              asProvider.getString('Order Summery'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          expanded: Container(
              //Dropdown
              margin: const EdgeInsets.only(bottom: 20, top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  EmptySpaceHelper.emptyHight(20),
                  moneyRow(context, asProvider.getString('Subtotal'), 27),
                  EmptySpaceHelper.emptyHight(10),
                  moneyRow(context, asProvider.getString('Coupon discount'), 0),
                  EmptySpaceHelper.emptyHight(10),
                  moneyRow(context, asProvider.getString('Tax'), 0),
                  EmptySpaceHelper.emptyHight(10),
                  moneyRow(context, asProvider.getString('Shipping cost'), 0),
                  EmptySpaceHelper.emptyHight(10),
                  const Divider(),
                  EmptySpaceHelper.emptyHight(10),
                  moneyRow(context, asProvider.getString('Total'), 27),
                  EmptySpaceHelper.emptyHight(20),
                ],
              ))),
    );
  }

  Widget moneyRow(BuildContext context, String title, int amount) {
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          rtlProvider.curRtl
              ? amount.toString() + rtlProvider.currency
              : rtlProvider.currency + amount.toString(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
