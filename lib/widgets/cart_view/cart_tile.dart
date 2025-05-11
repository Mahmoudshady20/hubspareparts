import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:safecart/widgets/common/image_loading_failed.dart';

import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../services/cart_data_service.dart';
import '../../services/rtl_service.dart';
import '../../utils/responsive.dart';
import '../common/custom_icon_button.dart';

class CartTile extends StatelessWidget {
  final dynamic id;
  final dynamic vendorId;
  String title;
  String image;
  double salePrice;
  int quantity;
  Map inventorySet;
  int index;
  num? originalPrice;
  String rowId;

  CartTile(
      this.vendorId,
      this.id,
      this.title,
      this.image,
      this.salePrice,
      this.quantity,
      this.inventorySet,
      this.index,
      this.originalPrice,
      this.rowId,
      {super.key});
  List colors = [
    const Color(0xffFFE3F0),
    const Color(0xffD6EFFF),
    const Color(0xffF2F3F5),
  ];

  @override
  Widget build(BuildContext context) {
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    return Container(
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Container(
                    height: screenWidth / 4,
                    width: screenWidth / 4,
                    color: colors[index % colors.length],
                    child: CachedNetworkImage(
                      imageUrl: image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          ImageLoadingFailed(size: screenWidth / 4),
                      errorWidget: (context, url, error) =>
                          ImageLoadingFailed(size: screenWidth / 4),
                    )),
              ],
            ),
          ),
          EmptySpaceHelper.emptywidth(10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: screenWidth - ((screenWidth / 4) + 50),
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cc.blackColor,
                        fontSize: 18,
                      ),
                ),
              ),
              if (inventorySet.isNotEmpty) EmptySpaceHelper.emptyHight(4),
              if (inventorySet.isNotEmpty)
                SizedBox(
                  width: screenWidth - ((screenWidth / 4) + 50),
                  height: 20,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final e = inventorySet.values.toList()[index];
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
                      itemCount: inventorySet.values.toList().length),
                ),
              EmptySpaceHelper.emptyHight(5),
              Container(
                alignment: rtlProvider.langRtl
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      rtlProvider.curRtl
                          ? '${salePrice.toStringAsFixed(2)}${rtlProvider.currency}'
                          : '${rtlProvider.currency}${salePrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: cc.secondaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    EmptySpaceHelper.emptywidth(5),
                    if (originalPrice != null)
                      Text(
                        rtlProvider.curRtl
                            ? '${originalPrice!.toStringAsFixed(2)}${rtlProvider.currency}'
                            : '${rtlProvider.currency}${originalPrice!.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: cc.greyHint,
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: cc.cardGreyHint,
                              decorationStyle: TextDecorationStyle.solid,
                            ),
                      ),
                  ],
                ),
              ),
              EmptySpaceHelper.emptyHight(8),
              SizedBox(
                width: screenWidth - ((screenWidth / 4) + 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Consumer<CartDataService>(
                        builder: (context, cProvider, child) {
                      return SizedBox(
                        height: 35,
                        width: screenWidth / 3,
                        child: SizedBox(
                          width: screenWidth / 3,
                          child: FittedBox(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (quantity == 1) {
                                        return;
                                      }

                                      quantity--;

                                      cProvider.removeItem(
                                          vendorId, id.toString(), context,
                                          inventorySet: inventorySet,
                                          rowId: rowId);
                                    },
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: cc.greyFive, width: 1.5),
                                        color: cc.pureWhite,
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: cc.blackColor.withOpacity(.5),
                                      ),
                                    ),
                                  ),
                                  EmptySpaceHelper.emptywidth(5),
                                  FittedBox(
                                    child: Container(
                                      height: 38,
                                      width: 60,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      constraints:
                                          const BoxConstraints(minWidth: 40),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: cc.greyFive, width: 1.5),
                                        color: cc.pureWhite,
                                      ),
                                      child: Text(
                                        quantity.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color: cc.blackColor,
                                            ),
                                      ),
                                    ),
                                  ),
                                  EmptySpaceHelper.emptywidth(5),
                                  GestureDetector(
                                    onTap: () {
                                      cProvider.addItem(context, vendorId, id,
                                          inventorySet: inventorySet,
                                          rowId: rowId);
                                    },
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: cc.greyFive, width: 1.5),
                                        color: cc.pureWhite,
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: cc.blackColor,
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      );
                    }),
                    const Spacer(),
                    EmptySpaceHelper.emptywidth(6),
                    CustomIconButton(
                      SvgPicture.asset('assets/icons/trash.svg'),
                      onPressed: () {
                        confirmDialouge(
                          context,
                          onPressed: () {
                            Provider.of<CartDataService>(context, listen: false)
                                .deleteCartItem(id, rowId);
                            showToast(
                                AppLocalizations.of(context)!
                                    .item_removed_from_cart,
                                cc.blackColor);
                          },
                        );
                      },
                      color: cc.red,
                    ),
                  ],
                ),
              ),
              EmptySpaceHelper.emptyHight(4),
            ],
          ),
        ],
      ),
    );
  }

  Future confirmDialouge(BuildContext context,
      {required void Function() onPressed}) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.are_you_sure),
              content:
                  Text(AppLocalizations.of(context)!.this_Item_will_be_Deleted),
              actions: [
                TextButton(
                    onPressed: (() {
                      Navigator.pop(context);
                    }),
                    child: Text(
                      AppLocalizations.of(context)!.no,
                      style: TextStyle(color: cc.green),
                    )),
                TextButton(
                    onPressed: () {
                      onPressed();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.yes,
                      style: TextStyle(color: cc.pink),
                    ))
              ],
            ));
  }
}
