import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/helpers/empty_space_helper.dart';

import '../../helpers/common_helper.dart';
import '../../services/cart_data_service.dart';
import '../../services/product_details_service.dart';
import '../../services/rtl_service.dart';
import '../../utils/custom_preloader.dart';
import '../../utils/responsive.dart';
import '../../widgets/common/custom_common_button.dart';
import '../../widgets/product_details_view/product_attributes.dart';

class WishlistToCart extends StatelessWidget {
  final dynamic id;
  bool fetchAttribute = true;

  WishlistToCart(this.id, {super.key});

  TextStyle attributeTitleTheme =
      const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    Provider.of<ProductDetailsService>(context, listen: false)
        .fetchProductDetails(id);
    return Consumer<ProductDetailsService>(
      builder: (context, pdService, child) {
        fetchAttribute = false;
        return pdService.loadingFailed
            ? Padding(
                padding: const EdgeInsets.all(20), child: errorWidget(context))
            : SizedBox(
                height:
                    pdService.productDetails == null ? 80 : screenHeight / 1.7,
                child: (pdService.productDetails == null
                    ? Align(
                        alignment: Alignment.center, child: CustomPreloader())
                    : Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 300,
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        pdService.additionalInfoImage ??
                                            (((pdService
                                                                .productDetails
                                                                ?.galleryImages
                                                                ?.length ??
                                                            0) >
                                                        0
                                                    ? pdService.productDetails
                                                        ?.galleryImages?.first
                                                    : pdService.productDetails
                                                        ?.image) ??
                                                imageLoadingAppIcon),
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/loading_imaage.png'),
                                                    opacity: .4)),
                                          );
                                        },
                                        errorBuilder: (context, o, st) {
                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/loading_imaage.png'),
                                                    opacity: .4)),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    child: Text(
                                      '${AppLocalizations.of(context)!.select_attributes}:',
                                      style: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const ProductAttribute(),
                                ],
                              ),
                            )
                                //   },
                                // ),
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: CustomCommonButton(
                              btText: pdService.cartAble
                                  ? rtlProvider.curRtl
                                      ? '${AppLocalizations.of(context)!.add_to_cart} ${rtlProvider.currency}${pdService.productSalePrice} '
                                      : '${rtlProvider.currency}${pdService.productSalePrice} ${AppLocalizations.of(context)!.add_to_cart}'
                                  : AppLocalizations.of(context)!
                                      .select_all_attribute_to_proceed,
                              isLoading: false,
                              width: double.infinity,
                              onPressed: () {
                                if (!pdService.cartAble) {
                                  showToast(
                                      AppLocalizations.of(context)!
                                          .please_select_an_attribute_set,
                                      cc.red);
                                  return;
                                }
                                num stock = 0;
                                var campaignProd =
                                    pdService.productDetails?.campaignProduct !=
                                        null;

                                if (campaignProd) {
                                  var campaignStock = DateTime.now().isBefore(
                                          pdService.productDetails!
                                                  .campaignProduct!.endDate ??
                                              DateTime.now().subtract(
                                                  const Duration(days: 1)))
                                      ? pdService.productDetails
                                          ?.campaignProduct?.unitsForSale
                                      : 0;
                                  stock = campaignStock ?? 0;
                                  // showToast("Product stock is insufficient", cc.blackColor);
                                } else if (pdService.variantId != null) {
                                  pdService.productDetails?.inventoryDetail
                                      ?.forEach((element) {
                                    if (element["id"].toString() ==
                                        pdService.variantId.toString()) {
                                      stock = element["stock_count"] is String
                                          ? int.tryParse(
                                                  element["stock_count"]) ??
                                              0
                                          : element["stock_count"] ?? 0;
                                    }
                                  });
                                } else {
                                  stock =
                                      pdService.productDetails?.soldCount ?? 0;
                                }

                                final product = pdService.productDetails!;
                                Provider.of<CartDataService>(context,
                                        listen: false)
                                    .addCartItem(
                                        context,
                                        product.vendorId,
                                        product.id,
                                        product.name ?? '',
                                        pdService.productSalePrice.toDouble(),
                                        1,
                                        pdService.additionalInfoImage ??
                                            product.image ??
                                            '',
                                        pdService.variantId ?? '',
                                        originalPrice: 0,
                                        inventorySet:
                                            pdService.selectedInventorySet == {}
                                                ? null
                                                : pdService
                                                    .selectedInventorySet,
                                        hash: pdService.selectedInventoryHash,
                                        randomKey: product.randomKey,
                                        randomSecret: product.randomSecret,
                                        stock: stock,
                                        prodCatData: {});
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          EmptySpaceHelper.emptyHight(20),
                        ],
                      )),
              );
      },
    );
  }
}
