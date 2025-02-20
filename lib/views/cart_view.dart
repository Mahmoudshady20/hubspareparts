import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/checkout_service/shipping_address_service.dart';
import 'package:safecart/services/payment_gateway_service.dart';

import '../helpers/common_helper.dart';
import '../helpers/empty_space_helper.dart';
import '../helpers/navigation_helper.dart';
import '../services/cart_data_service.dart';
import '../services/checkout_service/checkout_service.dart';
import '../services/product_details_service.dart';
import '../services/rtl_service.dart';
import '../utils/responsive.dart';
import '../widgets/cart_view/cart_tile.dart';
import '../widgets/common/custom_common_button.dart';
import 'checkout_view.dart';
import 'product_details_view.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () =>
          Provider.of<NavigationHelper>(context, listen: false).setNavIndex(0),
      child: Consumer<CartDataService>(builder: (context, cProvider, child) {
        return SizedBox(
          height: screenHeight - 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (cProvider.cartList.isNotEmpty)
                TextButton.icon(
                  onPressed: cProvider.cartList.isEmpty
                      ? () {
                          showToast(AppLocalizations.of(context)!.no_item_found,
                              cc.blackColor);
                        }
                      : () {
                          confirmDialouge(
                            context,
                            onPressed: () {
                              cProvider.emptyCart();
                            },
                          );
                        },
                  icon: const Icon(Icons.cancel_outlined),
                  label: Text(
                    AppLocalizations.of(context)!.clear_cart,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: cc.red,
                      decorationThickness: 2,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: cc.red,
                  ),
                ),
              EmptySpaceHelper.emptywidth(10),
              if (cProvider.cartList.isEmpty)
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: screenHeight / 2.5,
                      padding: const EdgeInsets.all(20),
                      child: Image.asset('assets/images/empty_cart.png'),
                    ),
                    Center(
                        child:
                            Text(AppLocalizations.of(context)!.add_item_to_cart,
                                style: TextStyle(
                                  color: cc.greyHint,
                                ))),
                  ],
                )),
              if (!(cProvider.cartList.isEmpty))
                Expanded(
                    child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  children: [
                    ...cartTiles(cProvider, context),
                  ],
                )),
              if (cProvider.cartList.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(20.0),
                  child: CustomCommonButton(
                    btText:
                        AppLocalizations.of(context)!.complete_Your_Purchase,
                    isLoading: false,
                    onPressed: () async {
                      Provider.of<PaymentGatewayService>(context, listen: false)
                          .resetGateway();
                      Provider.of<ShippingAddressService>(context,
                              listen: false)
                          .resetShippingInfo();
                      Provider.of<ShippingAddressService>(context,
                              listen: false)
                          .fetchShippingAddress(context, fetchWithoutNew: true);
                      Provider.of<CheckoutService>(context, listen: false)
                          .fetchVendorDetails(context);
                      Provider.of<ShippingAddressService>(context,
                              listen: false)
                          .setShippingAddressFromProfile(context);
                      Navigator.of(context).pushNamed(CheckoutView.routeName);
                      print('Process to checkout');
                    },
                    color: cc.secondaryColor,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  List<Widget> cartTiles(CartDataService cService, context) {
    List<Widget> list = [];
    int index = 0;
    for (var e in cService.cartList.values.toList()) {
      if (e == null) {
        continue;
      }
      print(e);
      list.add(GestureDetector(
        onTap: () {
          Provider.of<ProductDetailsService>(context, listen: false)
              .clearProductDetails();
          Navigator.of(context).pushNamed(ProductDetailsView.routeName,
              arguments: [e['title'], e['id']]);
        },
        child: CartTile(
            e['vendorId'],
            e['id'],
            e['name'] as String,
            e['imgUrl'] as String,
            e['price'] as double,
            e['qty'] as int,
            e['options']['attributes'] == {}
                ? {}
                : e['options']['attributes'] ?? {},
            ++index,
            e['original_price'] is String
                ? num.parse(e['original_price'])
                : e['original_price'],
            e['rowId']),
      ));
      list.add(const Padding(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: Divider(),
      ));
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

  Future confirmDialouge(BuildContext context,
      {required void Function() onPressed}) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.are_you_sure),
              content: Text(
                  AppLocalizations.of(context)!.these_Items_will_be_Deleted),
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
