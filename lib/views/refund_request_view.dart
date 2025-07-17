import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/models/preferred_options_model.dart';
import 'package:safecart/services/refund_services/make_refund_request_services.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';

import '../helpers/common_helper.dart';
import '../helpers/empty_space_helper.dart';
import '../helpers/font_size/font_size_responsive.dart';
import '../services/orders_service/order_details_service.dart';
import '../services/rtl_service.dart';
import '../utils/responsive.dart';
import '../widgets/common/boxed_back_button.dart';
import '../widgets/common/custom_common_button.dart';
import '../widgets/orders_view/billing_info.dart';
import '../widgets/orders_view/order_request_box.dart';
import '../widgets/skelletons/order_details_skeleton.dart';
import 'home_front_view.dart';

class RefundRequestView extends StatelessWidget {
  static const routeName = '/refund-request';
  bool goHome;
  String tracker;
  final textController = TextEditingController();
  RefundRequestView(this.tracker, {this.goHome = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Provider.of<MakeRefundRequestService>(context, listen: false).refunds.clear();
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
        child: Consumer<MakeRefundRequestService>(
          builder: (context, refundProvider, child) {
            return Stack(
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
                                    '${AppLocalizations.of(context)!
                                        .order} $tracker',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                        color: cc.pureWhite, fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                            leading: Padding(
                              padding: const EdgeInsets.symmetric(),
                              child: Column(
                                children: [
                                  BoxedBackButton(() {
                                    refundProvider.refunds.clear();
                                    Provider.of<OrderDetailsService>(context,
                                        listen: false)
                                        .clearOrderDetails();
                                    if (goHome) {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeFrontView()),
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
                                        future: odProvider.orderDetailsModel !=
                                            null
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
                                          return odProvider.orderDetailsModel ==
                                              null
                                              ? SizedBox(
                                            height: screenHeight / 2.5,
                                            child: Center(
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .something_went_wrong),
                                            ),
                                          )
                                              : Column(
                                            children: [
                                              ...orderTiles(context),
                                              BillingInfo(),
                                              FutureBuilder<PreferredOptionsModel?>(
                                                future: refundProvider.getRefundPreferredOptions(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return const Center(child: CircularProgressIndicator());
                                                  }

                                                  final preferredOptions = snapshot.data?.data ?? [];
                                                  final selectedValue = refundProvider.selectedPreferredOption;

                                                  // إزالة العناصر اللي فيها id = null أو مكرر
                                                  final ids = <String>{};
                                                  final filteredOptions = preferredOptions
                                                      .where((item) => item.id != null)
                                                      .where((item) => ids.add(item.id.toString()))
                                                      .toList();

                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(context)!.refund_preferred_options,
                                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: AppStyles.getResponsiveFontSize(context, fontSize: 12),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      DropdownButtonFormField<String>(
                                                        value: selectedValue?.isNotEmpty == true ? selectedValue : null,
                                                        decoration: InputDecoration(
                                                          border: OutlineInputBorder(),
                                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                        ),
                                                        items: filteredOptions.map((item) {
                                                          return DropdownMenuItem<String>(
                                                            value: item.id.toString(),
                                                            child: Text(item.name ?? ''),
                                                          );
                                                        }).toList(),
                                                        onChanged: (value) {
                                                          refundProvider.selectedPreferredOption = value;
                                                          refundProvider.updateSelectedPreferredOption(value ?? '');
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                              Text(AppLocalizations.of(context)!.additional_information,style: Theme.of(context).textTheme.titleLarge!.copyWith( fontSize: 25),),
                                              TextFormField(
                                                minLines: 2,
                                                maxLines: 5,
                                                controller: textController,
                                              ),
                                              Container(
                                                height: MediaQuery.sizeOf(context).height * 0.1,
                                                //margin: const EdgeInsets.all(20.0),
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 20.0,
                                                ),
                                                child: CustomCommonButton(
                                                  width: double.infinity,
                                                  btText:
                                                  AppLocalizations.of(context)!.submit,
                                                  isLoading: false,
                                                  onPressed: () async {
                                                   if(refundProvider.refunds.isEmpty){
                                                     return;
                                                   }
                                                   for(int i=0;i<refundProvider.refunds.length;i++){
                                                     refundProvider.refunds[i].additionalInformation = textController.text ?? '';
                                                     refundProvider.refunds[i].preferredOptions = refundProvider.selectedPreferredOption ?? '';
                                                   }
                                                   try {
                                                     for(int i=0;i<refundProvider.refunds.length;i++){
                                                       print(tracker.substring(1,tracker.length));
                                                       await refundProvider.makeRefundRequestHttp(tracker.substring(1,tracker.length).toString(),refundProvider.refunds[i],);
                                                     }
                                                     Navigator.of(context).pushAndRemoveUntil(
                                                         MaterialPageRoute(builder: (context) => HomeFrontView()),
                                                             (Route<dynamic> route) => false);
                                                   } catch (e) {
                                                     print(e.toString());
                                                     snackBar(context, e.toString());
                                                   }
                                                  },
                                                  color: Colors.red,
                                                ),
                                              ),
                                              // InkWell(
                                              //   onTap: (){
                                              //     for(int i=0;i<refundProvider.refunds.length;i++){
                                              //       print('check shady $i');
                                              //       print(refundProvider.refunds[i].requestItemId);
                                              //
                                              //       print(refundProvider.refunds[i].productName);
                                              //       print(refundProvider.refunds[i].refundReason);
                                              //       print(refundProvider.refunds[i].additionalInformation);
                                              //       print(refundProvider.refunds[i].preferredOptions);
                                              //       print('end of $i');
                                              //     }
                                              //     print(refundProvider.refunds.length);
                                              //   },
                                              //   child: Container(
                                              //     color: Colors.red,
                                              //     height: 40,
                                              //     width: double.infinity,
                                              //   ),
                                              // ),
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
            );
          }
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
      list.add(OrderRequestBox(
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
