import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import '../helpers/common_helper.dart';
import '../helpers/empty_space_helper.dart';
import '../services/refund_services/refund_details_services.dart';
import '../utils/responsive.dart';
import '../widgets/common/boxed_back_button.dart';
import '../widgets/skelletons/order_details_skeleton.dart';
import 'home_front_view.dart';

class RefundDetailsView extends StatelessWidget {
  static const routeName = 'refund_details_view';
  final int refundId;
  final bool goHome;

  const RefundDetailsView({
    required this.refundId,
    this.goHome = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Provider.of<RefundDetailsService>(context, listen: false)
              .clearRefundDetails();
          if (goHome) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => HomeFrontView()),
                  (route) => false,
            );
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
            Consumer<RefundDetailsService>(
              builder: (context, refundProvider, child) {
                return CustomScrollView(
                  physics: refundProvider.refundDetailsModel == null
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
                              '${AppLocalizations.of(context)!.refund} #$refundId',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                  color: cc.pureWhite, fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                      leading: BoxedBackButton(() {
                        Provider.of<RefundDetailsService>(context, listen: false)
                            .clearRefundDetails();
                        if (goHome) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => HomeFrontView()),
                                (route) => false,
                          );
                          return;
                        }
                        Navigator.of(context).pop();
                      }),
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
                                future: refundProvider.refundDetailsModel != null
                                    ? null
                                    : refundProvider.fetchRefundDetails(
                                    context, refundId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const OrderDetailsViewSkeleton();
                                  }

                                  final model = refundProvider
                                      .refundDetailsModel?.data;
                                  if (model == null) {
                                    return SizedBox(
                                      height: screenHeight / 2.5,
                                      child: Center(
                                        child: Text(AppLocalizations.of(context)!
                                            .something_went_wrong),
                                      ),
                                    );
                                  }

                                  return Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .refund_info,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      EmptySpaceHelper.emptyHight(10),
                                      bulletLineInfo(
                                          context,
                                          'preferred_option',
                                          model.refundInfo
                                              ?.preferredOption?.option ??
                                              ''),
                                      bulletLineInfo(
                                          context,
                                         'additional_info',
                                          model.refundInfo?.additionalInfo ??
                                              ''),
                                      EmptySpaceHelper.emptyHight(20),
                                      Text(
                                        AppLocalizations.of(context)!.items,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      ...model.refundItems!.map((item) {
                                        return ListTile(
                                          contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5),
                                          title: Text(item.name ?? ''),
                                          subtitle: Text(
                                              'Qty: ${item.quantity}, Price: ${item.price}'),
                                          leading: Image.network(
                                            '${item.image}',
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, e, st) => const Icon(
                                              Icons.image_not_supported,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      EmptySpaceHelper.emptyHight(20),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .status_history,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      ...model.refundTracks!.map((track) {
                                        return ListTile(
                                          title: Text(track.name ?? ''),
                                          subtitle:
                                          Text(track.createdAt ?? ''),
                                        );
                                      }).toList(),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          EmptySpaceHelper.emptyHight(40),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget bulletLineInfo(
      BuildContext context, String title, String value) {
    return Row(
      children: [
        Text("•", style: Theme.of(context).textTheme.titleMedium),
        EmptySpaceHelper.emptywidth(10),
        Text(
          '$title:',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.w500, color: cc.blackColor),
        ),
        const Spacer(),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: cc.greyHint),
          ),
        ),
      ],
    );
  }
}
