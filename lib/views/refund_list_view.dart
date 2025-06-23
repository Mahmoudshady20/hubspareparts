import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:safecart/utils/custom_preloader.dart';

import '../helpers/common_helper.dart';
import '../services/refund_services/refund_list_services.dart';
import '../utils/responsive.dart';
import '../widgets/common/boxed_back_button.dart';
import '../widgets/refund_views/refund_tile.dart';
import '../widgets/skelletons/order_tile_skeleton.dart'; // ممكن تعمل نسخة اسمها refund_tile_skeleton لو حبيت

class RefundListView extends StatelessWidget {
  static const routeName = 'refund_list_view';
  RefundListView({super.key});
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    controller.addListener(() => scrollListener(context));

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: screenHeight / 2.3,
            width: double.infinity,
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
                    color: cc.primaryColor,
                    alignment: Alignment.topCenter,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.refund_requests,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: cc.pureWhite,
                          fontSize: 25,
                        ),
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
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: FutureBuilder(
                          future: Provider.of<RefundService>(context,
                              listen: false)
                              .fetchRefundList(context),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Column(
                                children: Iterable.generate(5)
                                    .map((e) => const OrderTileSkeleton())
                                    .toList(),
                              );
                            }

                            return Consumer<RefundService>(
                              builder: (context, provider, child) {
                                final list = provider.refundModel?.data?.data;

                                return list != null && list.isNotEmpty
                                    ? Column(
                                  children: list
                                      .map((e) => RefundTile(
                                    id: e.refundInfo?.id ?? 0,
                                    status: e.refundInfo?.status ?? AppLocalizations.of(context)!.none,
                                    numberOfProduct: e.refundInfo?.totalProducts?.toInt() ?? 0,
                                  ))
                                      .toList(),
                                )
                                    : SizedBox(
                                  height: screenHeight / 2.5,
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .no_refund_found,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Consumer<RefundService>(
                      builder: (context, provider, child) {
                        return SizedBox(
                          height: 50,
                          child: provider.loadingNextPage
                              ? CustomPreloader()
                              : const SizedBox(),
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void scrollListener(BuildContext context) {
    final rService = Provider.of<RefundService>(context, listen: false);
    final refundModel = rService.refundModel;

    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      final current = refundModel?.data?.meta?.pagination?.currentPage ?? 1;
      final last = refundModel?.data?.meta?.pagination?.lastPage ?? 1;

      if (current >= last) {
        showToast(AppLocalizations.of(context)!.no_more_refund_found,
            cc.blackColor);
        return;
      }

      if (!rService.loadingNextPage) {
        rService.setLoadingNextPage(true);
        rService
            .fetchNextPage(context)
            .then((value) => rService.setLoadingNextPage(false))
            .onError(
                (error, stackTrace) => rService.setLoadingNextPage(false));
      }
    }
  }
}
