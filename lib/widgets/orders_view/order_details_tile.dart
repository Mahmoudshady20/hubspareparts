import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../services/rtl_service.dart';
import '../../utils/responsive.dart';
import '../common/image_loading_failed.dart';

class OrderDetailsTile extends StatelessWidget {
  String title;
  String? image;
  double salePrice;
  double? originalPrice;
  List attributeList;
  bool cartable;
  int quantity;
  int index;
  OrderDetailsTile(this.title, this.image, this.salePrice, this.originalPrice,
      this.quantity, this.cartable, this.index, this.attributeList,
      {super.key});
  List colors = [
    const Color(0xffFFE3F0),
    const Color(0xffD6EFFF),
    const Color(0xffF2F3F5),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
                height: screenWidth / 4,
                width: screenWidth / 4,
                color: colors[index % colors.length],
                child: CachedNetworkImage(
                  imageUrl: image ?? imageLoadingAppIcon,
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
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                EmptySpaceHelper.emptyHight(5),
                if (attributeList.isNotEmpty)
                  SizedBox(
                    height: 25,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final e = attributeList[index];
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
                        itemCount: attributeList.length),
                  ),
                EmptySpaceHelper.emptyHight(5),
                FittedBox(
                    child: moneyRow(
                  context,
                  salePrice.toStringAsFixed(2),
                  asProvider.getString('Price'),
                )),
                EmptySpaceHelper.emptyHight(5),
                FittedBox(
                    child: moneyRow(context, quantity.toString(),
                        asProvider.getString('qty'),
                        currency: '')),
                EmptySpaceHelper.emptyHight(5),
                FittedBox(
                    child: moneyRow(
                  context,
                  (salePrice * quantity).toDouble().toStringAsFixed(2),
                  asProvider.getString('Subtotal'),
                )),
                EmptySpaceHelper.emptyHight(5),
              ],
            ),
          ),
        ],
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
