import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/helpers/empty_space_helper.dart';
import 'package:safecart/services/product_details_service.dart';
import 'package:safecart/services/rtl_service.dart';

import '../../helpers/common_helper.dart';
import '../../services/cart_data_service.dart';
import 'package:safecart/utils/responsive.dart';
import '../common/custom_common_button.dart';

class ProductDetailsCartButton extends StatefulWidget {
  int itemCount;
  void Function() onPressed;
  ProductDetailsCartButton(this.itemCount, this.onPressed, {super.key});

  @override
  State<ProductDetailsCartButton> createState() =>
      _ProductDetailsCartButtonState();
}

class _ProductDetailsCartButtonState extends State<ProductDetailsCartButton> {
  @override
  Widget build(BuildContext context) {
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: cc.greyBorder2,
      ),
      child: Row(
        children: [
          SizedBox(
            height: 50,
            width: screenWidth / 2.4,
            child: FittedBox(
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                GestureDetector(
                  onTap: () {
                    if (widget.itemCount == 1) {
                      return;
                    }
                    setState(() {
                      widget.itemCount--;
                    });
                  },
                  child: Container(
                    height: 40,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: cc.greyFive, width: 1.5),
                      color: cc.pureWhite,
                    ),
                    child: Icon(
                      Icons.remove,
                      color: cc.blackColor.withOpacity(.5),
                    ),
                  ),
                ),
                EmptySpaceHelper.emptywidth(5),
                Container(
                  height: 38,
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  constraints: const BoxConstraints(minWidth: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: cc.pureWhite,
                  ),
                  child: Text(
                    widget.itemCount.toString(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                EmptySpaceHelper.emptywidth(5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.itemCount++;
                    });
                  },
                  child: Container(
                    height: 40,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: cc.greyFive, width: 1.5),
                      color: cc.pureWhite,
                    ),
                    child: const Icon(Icons.add),
                  ),
                ),
              ]),
            ),
          ),
          const Spacer(),
          Consumer<ProductDetailsService>(
              builder: (context, pdProvider, child) {
            return CustomCommonButton(
              btText: asProvider.getString('Add to cart') +
                  (rtlProvider.curRtl
                      ? ' ${(pdProvider.productSalePrice * widget.itemCount).toStringAsFixed(2)}${rtlProvider.currency}'
                      : ' ${rtlProvider.currency}${(pdProvider.productSalePrice * widget.itemCount).toStringAsFixed(2)}'),
              onPressed: () {
                if (!pdProvider.cartAble) {
                  showToast(
                      asProvider.getString('Please select an attribute set'),
                      cc.red);
                  return;
                }
                num stock = 0;
                var campaignProd =
                    pdProvider.productDetails?.campaignProduct != null;

                if (campaignProd) {
                  var campaignStock = DateTime.now().isBefore(
                          pdProvider.productDetails!.campaignProduct!.endDate ??
                              DateTime.now().subtract(const Duration(days: 1)))
                      ? pdProvider.productDetails?.campaignProduct?.unitsForSale
                      : 0;
                  stock = campaignStock ?? 0;
                } else if (pdProvider.variantId != null) {
                  pdProvider.productDetails?.inventoryDetail
                      ?.forEach((element) {
                    if (element["id"].toString() ==
                        pdProvider.variantId.toString()) {
                      stock = element["stock_count"] is String
                          ? int.tryParse(element["stock_count"]) ?? 0
                          : element["stock_count"] ?? 0;
                    }
                  });
                } else {
                  debugPrint((pdProvider.productDetails?.inventory).toString());
                  stock =
                      pdProvider.productDetails?.inventory["stock_count"] ?? 0;
                }

                print(pdProvider.selectedInventorySet);
                Provider.of<CartDataService>(context, listen: false)
                    .addCartItem(
                        context,
                        pdProvider.productDetails!.vendorId,
                        pdProvider.productDetails!.id,
                        pdProvider.productDetails!.name ?? '',
                        pdProvider.productSalePrice,
                        widget.itemCount,
                        pdProvider.additionalInfoImage ??
                            pdProvider.productDetails!.galleryImages?.first ??
                            '',
                        pdProvider.variantId,
                        originalPrice: pdProvider.productDetails
                                ?.campaignProduct?.campaignPrice ??
                            pdProvider.productDetails?.price,
                        inventorySet: pdProvider.selectedInventorySet,
                        prodCatData: {
                          "category": pdProvider.productDetails?.category?.id,
                          "subcategory":
                              pdProvider.productDetails?.subCategory?.id,
                          "childcategory": pdProvider
                              .productDetails?.childCategory
                              ?.map((e) => e.id)
                              .toList(),
                        },
                        randomKey: pdProvider.productDetails?.randomKey,
                        randomSecret: pdProvider.productDetails?.randomSecret,
                        stock: stock);
              },
              width: screenWidth / 2.4,
              isLoading: false,
            );
          })
        ],
      ),
    );
  }
}
