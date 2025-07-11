import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/utils/responsive.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../services/orders_service/order_details_service.dart';

class BillingInfo extends StatelessWidget {
  BillingInfo({super.key});
  final ExpandableController _expandableController =
      ExpandableController(initialExpanded: false);

  @override
  Widget build(BuildContext context) {
    final odProvider = Provider.of<OrderDetailsService>(context, listen: false);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // controller: _expandableController,
      // theme: const ExpandableThemeData(hasIcon: false),
      Container(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          AppLocalizations.of(context)!.order_details,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      const Divider(thickness: 1),
      Container(
          //Dropdown
          margin: const EdgeInsets.only(bottom: 20, top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              infoRow(context, AppLocalizations.of(context)!.sub_order_id,
                  '#${odProvider.orderDetailsModel?.orderTrack.orderId}'),
              EmptySpaceHelper.emptyHight(10),
              infoRow(context, AppLocalizations.of(context)!.transaction_id,
                  '${odProvider.orderDetailsModel?.paymentDetails.transactionId ?? '-'}',
                  textColor: cc.blue),
              EmptySpaceHelper.emptyHight(10),
              infoRow(context, AppLocalizations.of(context)!.payment_getaway,
                  '${odProvider.orderDetailsModel?.paymentDetails.paymentGateway}'),
              EmptySpaceHelper.emptyHight(10),
              infoRow(context, AppLocalizations.of(context)!.payment_status,
                  '${odProvider.orderDetailsModel?.paymentDetails.paymentStatus}',
                  textColor: odProvider.statusColor(
                      '${odProvider.orderDetailsModel?.paymentDetails.paymentStatus}')),
              EmptySpaceHelper.emptyHight(10),
              infoRow(context, AppLocalizations.of(context)!.order_status,
                  '${odProvider.orderDetailsModel?.orderTrack.name}',
                  textColor: odProvider.statusColor(
                      '${odProvider.orderDetailsModel?.orderTrack.name}')),
              // EmptySpaceHelper.emptyHight(10),
              // infoRow(context, 'Items', '5'),
              EmptySpaceHelper.emptyHight(10),
              infoRow(context, AppLocalizations.of(context)!.items_total,
                  '${odProvider.orderDetailsModel?.paymentDetails.paymentMeta?.subTotal.toStringAsFixed(2) ?? 0.00}',
                  isPrice: true),
              EmptySpaceHelper.emptyHight(10),
              infoRow(context, AppLocalizations.of(context)!.shipping_cost,
                  '${odProvider.orderDetailsModel?.paymentDetails.paymentMeta?.shippingCost.toStringAsFixed(2) ?? 0.00}',
                  isPrice: true),
              EmptySpaceHelper.emptyHight(10),
              infoRow(context, AppLocalizations.of(context)!.tax,
                  '${odProvider.orderDetailsModel?.paymentDetails.paymentMeta?.taxAmount.toStringAsFixed(2) ?? 0.00}',
                  isPrice: true),
              EmptySpaceHelper.emptyHight(10),
              infoRow(context, AppLocalizations.of(context)!.total,
                  '${odProvider.orderDetailsModel?.paymentDetails.paymentMeta?.totalAmount.toStringAsFixed(2) ?? 0.00}',
                  isPrice: true),
            ],
          ))
    ]);
  }

  Widget infoRow(BuildContext context, String title, String text,
      {isPrice = false, textColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          asProvider.getString(title),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: cc.greyThree, fontSize: 14),
        ),
        // EmptySpaceHelper.emptywidth(20),
        SizedBox(
          width: textColor == cc.blue ? screenWidth / 2.2 : null,
          child: Text(
            isPrice
                ? rtlProvider.curRtl
                    ? "$text${rtlProvider.currency}"
                    : "${rtlProvider.currency}$text"
                : text.toString().capitalize(),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor ?? cc.greyHint,
                fontSize: 14),
          ),
        ),
      ],
    );
  }
}
