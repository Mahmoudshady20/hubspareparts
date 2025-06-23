import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:safecart/utils/custom_preloader.dart';

import '../helpers/common_helper.dart';
import '../services/orders_service/order_list_service.dart';
import '../utils/responsive.dart';
import '../widgets/common/boxed_back_button.dart';
import '../widgets/orders_view/order_tile.dart';
import '../widgets/skelletons/order_tile_skeleton.dart';

class OrdersListView extends StatelessWidget {
  static const routeName = 'order_list_view';
  OrdersListView({super.key});
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    controller.addListener((() => scrollListener(context)));
    return Scaffold(
      // appBar: CustomAppBar()
      //     .appBarTitled(context, asProvider.getString('My orders'), () {
      //   Navigator.of(context).pop();
      // }),
      body: Stack(
        children: [
          Container(
            height: screenHeight / 2.3,
            width: double.infinity,
            // padding: EdgeInsets.only(top: screenHeight / 7),
            color: cc.primaryColor,
            alignment: Alignment.topCenter,
          ),
          CustomScrollView(
            controller: controller,
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
                    // padding: EdgeInsets.only(top: screenHeight / 7),
                    color: cc.primaryColor,
                    alignment: Alignment.topCenter,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.my_orders,
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
                        // constraints:
                        //     BoxConstraints(minHeight: screenHeight / 2.5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: FutureBuilder(
                            future: Provider.of<OrderListService>(context,
                                    listen: false)
                                .fetchOrderList(context),
                            builder: ((context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Column(
                                  children: Iterable.generate(5)
                                      .map((e) => const OrderTileSkeleton())
                                      .toList(),
                                );
                              }

                              return Consumer<OrderListService>(
                                  builder: (context, olProvider, child) {
                                return olProvider.orderListModel != null &&
                                        olProvider
                                            .orderListModel!.data.isNotEmpty
                                    ? Column(
                                        children: olProvider
                                            .orderListModel!.data
                                            .map((e) => OrderTile(
                                                  e.paymentMeta?.totalAmount ??
                                                      0,
                                                  '#${e.id ?? ''}',
                                                  e.createdAt ?? DateTime.now(),
                                                  e.orderTrack ??
                                                      AppLocalizations.of(
                                                              context)!
                                                          .none,
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(e.createdAt ??
                                                          DateTime.now()),
                                                  e.paymentStatus ??
                                                      AppLocalizations.of(
                                                              context)!
                                                          .none,
                                                ))
                                            .toList(),
                                      )
                                    : SizedBox(
                                        height: screenHeight / 2.5,
                                        child: Center(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .no_order_found),
                                        ),
                                      );
                              });
                            })),
                      ),
                    ),
                    Consumer<OrderListService>(
                      builder: (context, oProvider, child) {
                        return SizedBox(
                          height: 50,
                          child: oProvider.loadingNextPage
                              ? CustomPreloader()
                              : const SizedBox(),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  scrollListener(BuildContext context) {
    final oService = Provider.of<OrderListService>(context, listen: false);
    final orderListData = oService.orderListModel;

    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (oService.orderListModel?.nextPageUrl == null) {
        showToast(
            AppLocalizations.of(context)!.no_more_order_found, cc.blackColor);
        return;
      }
      if (orderListData?.nextPageUrl != null && !oService.loadingNextPage) {
        oService.setLoadingNextPage(true);
        oService
            .fetchNextPage(context)
            .then((value) => oService.setLoadingNextPage(false))
            .onError((error, stackTrace) => oService.setLoadingNextPage(false));
      } else {}
    }
  }

  Future<bool> showTimout() async {
    await Future.delayed(const Duration(seconds: 10));
    return true;
  }
}
