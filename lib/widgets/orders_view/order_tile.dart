import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/orders_service/order_details_service.dart';
import 'package:safecart/utils/responsive.dart';
import 'package:safecart/views/order_details_view.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../services/rtl_service.dart';

class OrderTile extends StatelessWidget {
  final double totalAmount;
  final String trackingCode;
  final DateTime orderedDate;
  final String? order;
  final String? payment;
  final String? createdAt;
  const OrderTile(
    this.totalAmount,
    this.trackingCode,
    this.orderedDate,
    this.order,
    this.createdAt,
    this.payment, {
    super.key,
  });

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
            Row(
              children: [
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
                Spacer(),
                Text(
                  rtlProvider.curRtl
                      ? createdAt.toString()
                      : createdAt.toString(),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: cc.primaryColor,
                      ),
                ),
              ],
            ),
            EmptySpaceHelper.emptyHight(4),
            Row(
              children: [
                Text('${AppLocalizations.of(context)!.payment} : ',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: cc.greyParagraph, fontSize: 14)),
                Text(payment?.capitalize() ?? '',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: odProvider.statusColor(order ?? ''),
                        fontSize: 14)),
                EmptySpaceHelper.emptywidth(8),
                Text('${AppLocalizations.of(context)!.order} : ',
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
                      text: AppLocalizations.of(context)!.view,
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
              title: Text(AppLocalizations.of(context)!.are_you_sure),
              content: Text(
                  AppLocalizations.of(context)!.this_order_will_be_canceled),
              actions: [
                TextButton(
                    onPressed: (() {
                      Navigator.pop(context);
                    }),
                    child: Text(
                      AppLocalizations.of(context)!.no,
                      style: TextStyle(color: cc.green),
                    )),
                TextButton(
                    onPressed: () {
                      onPressed();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.yes,
                      style: TextStyle(color: cc.pink),
                    ))
              ],
            ));
  }
}
