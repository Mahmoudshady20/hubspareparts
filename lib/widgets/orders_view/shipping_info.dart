import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/orders_service/order_details_service.dart';
import 'package:safecart/utils/Constant_colors.dart';
import 'package:safecart/utils/responsive.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';

class ShippingInfo extends StatelessWidget {
  ShippingInfo({super.key});
  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    final address = Provider.of<OrderDetailsService>(context, listen: false)
        .orderDetailsModel
        ?.paymentDetails
        .address;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          AppLocalizations.of(context)!.shipping_details,
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
          margin: const EdgeInsets.only(bottom: 20, top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              infoRow(context, AppLocalizations.of(context)!.name,
                  address?.name ?? 'None'),
              EmptySpaceHelper.emptyHight(10),
              infoRow(context, AppLocalizations.of(context)!.email,
                  address?.email ?? 'None'),
              EmptySpaceHelper.emptyHight(10),
              infoRow(context, AppLocalizations.of(context)!.phone,
                  '${address?.phone ?? 'None'}'),
              EmptySpaceHelper.emptyHight(10),
              infoRow(context, AppLocalizations.of(context)!.country,
                  address?.country?.name ?? '-'),
              EmptySpaceHelper.emptyHight(10),
              infoRow(context, AppLocalizations.of(context)!.state,
                  address?.state?.name ?? '-'),
              EmptySpaceHelper.emptyHight(10),
              infoRow(context, AppLocalizations.of(context)!.city,
                  address?.cityInfo?.name ?? '-'),
              EmptySpaceHelper.emptyHight(10),
              infoRow(context, AppLocalizations.of(context)!.street_address,
                  '${address?.address ?? 'None'}'),
            ],
          ))
    ]);
  }

  Widget infoRow(BuildContext context, String title, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          width: title == 'Street Address' || title == 'عنوان الشارع'
              ? screenWidth / 2.2
              : null,
          child: Text(
            amount.toString(),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: cc.greyHint, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
