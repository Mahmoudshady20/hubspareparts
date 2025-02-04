import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/widgets/orders_view/order_vendor_box.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../helpers/common_helper.dart';
import '../helpers/empty_space_helper.dart';
import '../services/orders_service/order_details_service.dart';
import '../services/rtl_service.dart';
import '../utils/responsive.dart';
import '../widgets/common/boxed_back_button.dart';
import '../widgets/orders_view/billing_info.dart';
import '../widgets/orders_view/shipping_info.dart';
import '../widgets/skelletons/order_details_skeleton.dart';
import 'home_front_view.dart';

class OrderDetailsView extends StatelessWidget {
  static const routeName = 'order_details_view';
  bool goHome;
  String tracker;
  OrderDetailsView(this.tracker, {this.goHome = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Provider.of<OrderDetailsService>(context, listen: false)
              .clearOrderDetails();
          if (goHome) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomeFrontView()),
                (Route<dynamic> route) => false);
            return true;
          }
          return true;
        },
        child: Stack(
          children: [
            Container(
              height: screenHeight / 2.3,
              width: double.infinity,
              color: cc.primaryColor,
              alignment: Alignment.topCenter,
            ),
            Consumer<OrderDetailsService>(
                builder: (context, odProvider, child) {
              return CustomScrollView(
                physics: odProvider.orderDetailsModel == null
                    ? const NeverScrollableScrollPhysics()
                    : null,
                slivers: [
                  SliverAppBar(
                    elevation: 1,
                    leadingWidth: 60,
                    toolbarHeight: 60,
                    foregroundColor: cc.greyHint,
                    backgroundColor: Colors.transparent,
                    expandedHeight: screenHeight / 3.7,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        height: screenHeight / 3.7,
                        width: double.infinity,
                        color: cc.primaryColor,
                        alignment: Alignment.topCenter,
                        child: Center(
                          child: Text(
                            '${AppLocalizations.of(context)!.order} $tracker',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: cc.pureWhite, fontSize: 25),
                          ),
                        ),
                      ),
                    ),
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(),
                      child: Column(
                        children: [
                          BoxedBackButton(() {
                            Provider.of<OrderDetailsService>(context,
                                    listen: false)
                                .clearOrderDetails();
                            if (goHome) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => HomeFrontView()),
                                  (Route<dynamic> route) => false);
                              return;
                            }
                            Navigator.of(context).pop();
                          }),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: FutureBuilder(
                                future: odProvider.orderDetailsModel != null
                                    ? null
                                    : odProvider.fetchOrderDetails(
                                        context, tracker),
                                builder: (context, snapShot) {
                                  if (snapShot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const OrderDetailsViewSkeleton();
                                  }

                                  const titleTextTheme = TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold);
                                  return odProvider.orderDetailsModel == null
                                      ? SizedBox(
                                          height: screenHeight / 2.5,
                                          child: Center(
                                            child: Text(AppLocalizations.of(context)!.something_went_wrong),
                                          ),
                                        )
                                      : Column(
                                          children: [
                                            ...orderTiles(context),
                                            BillingInfo(),
                                            ShippingInfo(),
                                            // OrderInfo(),
                                          ],
                                        );
                                }),
                          ),
                        ),
                        EmptySpaceHelper.emptyHight(40)
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget bulletLineInfo(BuildContext context, String title, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "\u2022",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        EmptySpaceHelper.emptywidth(10),
        Text(
          '$title:',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w500,
                color: cc.blackColor,
              ),
        ),
        const Spacer(),
        Text(
          amount.toString(),
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: cc.greyHint,
              ),
        ),
      ],
    );
  }

  List<Widget> orderTiles(BuildContext context) {
    final odProvider = Provider.of<OrderDetailsService>(context, listen: false);
    List<Widget> list = [];
    int index = 0;
    for (var element in odProvider.orderDetailsModel!.order) {
      list.add(OrderVendorBox(
        order: element,
      ));
      list.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: (index + 1) == odProvider.orderDetailsModel!.order.length
            ? null
            : const Divider(),
      ));
      index++;
    }
    return list;
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
