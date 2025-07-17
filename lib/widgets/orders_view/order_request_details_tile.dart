import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:safecart/helpers/font_size/font_size_responsive.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/refund_services/make_refund_request_services.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../models/make_refund_request_model.dart';
import '../../services/rtl_service.dart';
import '../../utils/responsive.dart';
import '../common/image_loading_failed.dart';
//122308437
class OrderRequestDetailsTile extends StatefulWidget {
  String? id;
  String title;
  String? image;
  double salePrice;
  double? originalPrice;
  List attributeList;
  bool cartable;
  int quantity;
  int index;
  void Function()? onTap;

  OrderRequestDetailsTile(this.id,this.title, this.image, this.salePrice, this.originalPrice,
      this.quantity, this.cartable, this.index, this.attributeList,
      this.onTap,
      {super.key});

  @override
  State<OrderRequestDetailsTile> createState() => _OrderRequestDetailsTileState();
}

class _OrderRequestDetailsTileState extends State<OrderRequestDetailsTile> {
  bool isChecked = false;
  String? refundReason;
  List colors = [
    const Color(0xffFFE3F0),
    const Color(0xffD6EFFF),
    const Color(0xffF2F3F5),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<MakeRefundRequestService>(
      builder: (context, refundProvider, child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                  height: screenWidth / 4,
                  width: screenWidth / 6,
                  color: colors[widget.index % colors.length],
                  child: CachedNetworkImage(
                    imageUrl: widget.image ?? imageLoadingAppIcon,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        ImageLoadingFailed(size: screenWidth / 4),
                    errorWidget: (context, url, error) =>
                        ImageLoadingFailed(size: screenWidth / 4),
                  )),
            ),
            EmptySpaceHelper.emptywidth(15),
            SizedBox(
              width: screenWidth - ((screenWidth / 4) + 140),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  EmptySpaceHelper.emptyHight(5),
                  if (widget.attributeList.isNotEmpty)
                    SizedBox(
                      height: 25,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final e = widget.attributeList[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2.5, horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: cc.greyBorder2,
                              ),
                              child: Text(e),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              EmptySpaceHelper.emptywidth(5),
                          itemCount: widget.attributeList.length),
                    ),
                  EmptySpaceHelper.emptyHight(5),
                  FittedBox(
                      child: moneyRow(
                        context,
                        widget.salePrice.toStringAsFixed(2),
                        AppLocalizations.of(context)!.price,
                      )),
                  EmptySpaceHelper.emptyHight(5),
                  FittedBox(
                      child: moneyRow(context, widget.quantity.toString(),
                          asProvider.getString('qty'),
                          currency: '')),
                  EmptySpaceHelper.emptyHight(5),
                  FittedBox(
                      child: moneyRow(
                        context,
                        (widget.salePrice * widget.quantity).toDouble().toStringAsFixed(2),
                        AppLocalizations.of(context)!.subtotal,
                      )),
                  EmptySpaceHelper.emptyHight(5),
                  isChecked ? FutureBuilder(future: refundProvider.getRefundReasons(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.refund_reason,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold,fontSize: AppStyles.getResponsiveFontSize(context, fontSize: 12,),),
                            ),
                            DropdownButton<String>(
                              value: refundProvider.selectedRefundReason,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              iconSize: AppStyles.getResponsiveFontSize(context, fontSize: 24),
                              elevation: 16,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold,fontSize: AppStyles.getResponsiveFontSize(context, fontSize: 12,),),
                              onChanged: (String? value) {
                                refundReason = value;
                                refundProvider.updateSelectedRefundReason(value ?? refundProvider.selectedRefundReason ?? '');
                                print('tapped 4');
                                print(widget.id);
                                print('tapped 4 done');
                                print(refundReason);
                                print('tapped 5');
                                if (isChecked) {
                                  if (refundProvider.containsById(widget.id.toString())) {
                                    refundProvider.updateRefund(MakeRefundRequestModel(
                                      productName: widget.title,
                                      preferredOptions: '1',
                                      refundQuantity: widget.quantity.toString(),
                                      refundReason: refundReason,
                                      requestItemId: widget.id.toString(),
                                    ));
                                  } else {
                                    refundProvider.addRefund(MakeRefundRequestModel(
                                      productName: widget.title,
                                      preferredOptions: '1',
                                      refundQuantity: widget.quantity.toString(),
                                      refundReason: refundReason,
                                      requestItemId: widget.id.toString(),
                                    ));
                                  }
                                }
                              },
                              items: (snapshot.data?.dataa ?? []).map<DropdownMenuItem<String>>((item) {
                                return DropdownMenuItem<String>(
                                  value: item.id.toString(), // assuming this is the string you want
                                  child: Text(item.name ?? ''),
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      }
                  ) : Container(),
                ],
              ),
            ),
            Checkbox(value: isChecked, onChanged: (value) {
              isChecked = value!;
              widget.onTap!();
              if(isChecked == false && refundProvider.refunds.isEmpty) {
                return;
              } else if (isChecked == false && refundProvider.refunds.isNotEmpty) {
                refundProvider.removeById(widget.id.toString());
              }
              setState(() {

              });
            }),

          ],
        ),
      ),
    );
  }

  moneyRow(BuildContext context, String amount, String title,
      {color, currency}) {
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: color ?? cc.greyHint,
          ),
        ),
        EmptySpaceHelper.emptywidth(5),
        Text(
          rtlProvider.curRtl
              ? amount + (currency ?? rtlProvider.currency)
              : (currency ?? rtlProvider.currency) + amount,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: color ?? cc.greyHint,
          ),
        ),
      ],
    );
  }
}
