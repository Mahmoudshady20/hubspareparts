import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/orders_service/order_details_service.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../services/rtl_service.dart';
import 'package:safecart/utils/responsive.dart';
import 'package:safecart/views/order_details_view.dart';

class OrderTile extends StatelessWidget {
  final double totalAmount;
  final String trackingCode;
  final DateTime orderedDate;
  final String? order;
  final String? payment;
  const OrderTile(
    this.totalAmount,
    this.trackingCode,
    this.orderedDate,
    this.order,
    this.payment, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    screenSizeAndPlatform(context);
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    final odProvider = Provider.of<OrderDetailsService>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (BuildContext context) => OrderDetailsView(
            trackingCode,
            goHome: false,
          ),
        ));
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trackingCode,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: cc.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            EmptySpaceHelper.emptyHight(4),
            Text(
              rtlProvider.curRtl
                  ? totalAmount.toStringAsFixed(2) + rtlProvider.currency
                  : rtlProvider.currency + totalAmount.toStringAsFixed(2),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: cc.primaryColor,
                  ),
            ),
            EmptySpaceHelper.emptyHight(4),
            Row(
              children: [
                Text(asProvider.getString('Payment') + ' : ',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: cc.greyParagraph, fontSize: 14)),
                Text(payment?.capitalize() ?? '',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: odProvider.statusColor(order ?? ''),
                        fontSize: 14)),
                EmptySpaceHelper.emptywidth(8),
                Text(asProvider.getString('Order') + ' : ',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: cc.greyParagraph, fontSize: 14)),
                Text(order?.capitalize() ?? '',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: odProvider.statusColor(order ?? ''),
                        fontSize: 14)),
                const Spacer(),
                RichText(
                  text: TextSpan(
                      text: asProvider.getString('View'),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.transparent,
                            fontSize: 14,
                            shadows: [
                              Shadow(
                                  offset: const Offset(0, -5), color: cc.green)
                            ],
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: cc.green,
                            decorationThickness: 2,
                          )),
                ),
              ],
            ),
            EmptySpaceHelper.emptyHight(4),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Future confirmDialouge(BuildContext context,
      {required void Function() onPressed}) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(asProvider.getString('Are you sure?')),
              content:
                  Text(asProvider.getString('This order will be canceled.')),
              actions: [
                TextButton(
                    onPressed: (() {
                      Navigator.pop(context);
                    }),
                    child: Text(
                      asProvider.getString('No'),
                      style: TextStyle(color: cc.green),
                    )),
                TextButton(
                    onPressed: () {
                      onPressed();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      asProvider.getString('Yes'),
                      style: TextStyle(color: cc.pink),
                    ))
              ],
            ));
  }
}
