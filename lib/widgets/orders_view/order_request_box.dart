import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/models/make_refund_request_model.dart';
import 'package:safecart/models/order_details_model.dart';
import 'package:safecart/services/refund_services/make_refund_request_services.dart';
import 'package:safecart/views/product_details_view.dart';
import 'package:safecart/widgets/orders_view/order_details_tile.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../services/cart_data_service.dart';
import '../../services/product_details_service.dart';
import '../../services/rtl_service.dart';
import 'order_request_details_tile.dart';

class OrderRequestBox extends StatelessWidget {
  final Order order;
  OrderRequestBox({required this.order, super.key,});

  @override
  Widget build(BuildContext context) {
    final cdProvider = Provider.of<CartDataService>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: cc.greyBorder2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.vendor?.businessName ??
                AppLocalizations.of(context)!.safeCart,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: cc.greyHint,
              fontWeight: FontWeight.bold,
            ),
          ),
          EmptySpaceHelper.emptyHight(8),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: cc.pureWhite,
              ),
              child: Column(
                children: productList(context, order.orderItem),
              )),
        ],
      ),
    );
  }

  Widget moneyRow(BuildContext context, String title, double amount) {
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
            rtlProvider.curRtl
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

  List<Widget> productList(BuildContext context, List<OrderItem> productList) {
    MakeRefundRequestService makeRequest = Provider.of<MakeRefundRequestService>(context,);
    List<Widget> list = [];

    for (var e in productList) {
      List attributes = [];
      for (var element in e.attribute) {
        attributes.add(element.attributeValue);
      }
      if (e.productColor != null) {
        attributes.add(e.productColor);
      }
      if (e.productSize != null) {
        attributes.add(e.productSize);
      }

      list.add(GestureDetector(
          onTap: () {
            print('tapped');
            for(int i=0;i<makeRequest.refunds.length;i++){
              print(makeRequest.refunds[i].productName);
            }
          },
          child: Row(
            children: [
              Column(
                children: [
                  OrderRequestDetailsTile(
                    e.product.id.toString(),
                      e.product.name,
                      e.variantImage ?? e.product.image,
                      (e.product.campaignProduct ?? e.product.salePrice) +
                          e.variantPrice,
                      e.product.campaignProduct == null ? null : e.product.salePrice,
                      e.quantity.toInt(),
                      false,
                      e.quantity.toInt(),
                      attributes,
                      () async{
                        print('tapped 2');
                        print(e.product.id);
                        print('tapped 3');
                        await makeRequest.getRefundReasons();
                        await makeRequest.getRefundPreferredOptions();
                      }
                  ),

                ],
              ),
            ],
          )));
      // list.add(EmptySpaceHelper.emptyHight(8));
    }

    return list;
  }
}
