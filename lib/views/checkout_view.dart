import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/checkout_service/checkout_service.dart';
import 'package:safecart/services/checkout_service/shipping_address_service.dart';
import 'package:safecart/utils/custom_preloader.dart';
import 'package:safecart/widgets/checkout_view/vendor_box.dart';
import 'package:safecart/widgets/common/custom_outlined_button.dart';

import '../helpers/common_helper.dart';
import '../helpers/empty_space_helper.dart';
import '../services/cart_data_service.dart';
import '../services/checkout_service/payment_methode_navigator_helper.dart';
import '../services/payment_gateway_service.dart';
import '../services/rtl_service.dart';
import '../utils/responsive.dart';
import '../widgets/cart_view/coupon_field.dart';
import '../widgets/checkout_view/payment_grid_tile.dart';
import '../widgets/checkout_view/shipping_address_checkout.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/common/custom_common_button.dart';
import '../widgets/common/field_title.dart';
import '../widgets/common/web_view.dart';

class CheckoutView extends StatelessWidget {
  static const routeName = 'checkout_view';
  CheckoutView({super.key});

  final TextEditingController _zitopayController = TextEditingController();
  final TextEditingController _authCardController = TextEditingController();
  final TextEditingController _authCardCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cdProvider = Provider.of<CartDataService>(context, listen: false);
    final subTotal = cdProvider.calculateSubtotal().toDouble();
    return Scaffold(
      appBar: CustomAppBar().appBarTitled(
        context,
        asProvider.getString('Checkout'),
        () {
          Navigator.of(context).pop();
        },
        hasElevation: false,
        color: Colors.transparent,
      ),
      body: SingleChildScrollView(
          child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            topRight: Radius.circular(25),
            topLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Container(
          color: cc.pureWhite,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SippingAddressCheckout(),
              const Divider(height: 2),
              EmptySpaceHelper.emptyHight(10),
              Text(
                AppLocalizations.of(context)!.products,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              EmptySpaceHelper.emptyHight(10),
              Consumer<CheckoutService>(
                builder: (context, cProvider, child) {
                  return cProvider.loadingVendorDetailsList
                      ? SizedBox(height: 60, child: CustomPreloader())
                      : cProvider.vendorDetailsList == null
                          ? const SizedBox()
                          : Column(
                              children: Provider.of<CartDataService>(context,
                                      listen: false)
                                  .vendorIds
                                  .toList()
                                  .map(
                                (element) {
                                  return Consumer<CartDataService>(
                                      builder: (context, cdProvider, child) {
                                    return VendorBox(
                                        mapKey: element.toString());
                                  });
                                },
                              ).toList(),
                            );
                },
              ),
              EmptySpaceHelper.emptyHight(10),
              const Divider(height: 2),
              CouponField(),
              EmptySpaceHelper.emptyHight(10),
              const Divider(height: 2),
              EmptySpaceHelper.emptyHight(10),
              Text(
                AppLocalizations.of(context)!.order_summery,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              EmptySpaceHelper.emptyHight(20),
              const Divider(height: 2),
              EmptySpaceHelper.emptyHight(20),
              Consumer<CheckoutService>(builder: (context, cProvider, child) {
                return moneyRow(context, asProvider.getString('Items total'),
                    cProvider.totalItemCost.toDouble());
              }),
              EmptySpaceHelper.emptyHight(10),
              Consumer<CheckoutService>(builder: (context, cdProvider, child) {
                return moneyRow(
                    context,
                    asProvider.getString('Coupon discount'),
                    cdProvider.couponDiscount);
              }),
              EmptySpaceHelper.emptyHight(10),
              Consumer<CheckoutService>(builder: (context, cProvider, child) {
                return moneyRow(context, asProvider.getString('Tax'),
                    cProvider.totalTax.toDouble());
              }),
              EmptySpaceHelper.emptyHight(10),
              Consumer<CheckoutService>(builder: (context, cProvider, child) {
                return moneyRow(context, asProvider.getString('Shipping cost'),
                    cProvider.totalShippingCost.toDouble());
              }),
              EmptySpaceHelper.emptyHight(10),
              const Divider(),
              EmptySpaceHelper.emptyHight(10),
              Consumer<CheckoutService>(builder: (context, cProvider, child) {
                cProvider.setCartDataService(cdProvider);
                return moneyRow(context, asProvider.getString('Total'),
                    cProvider.totalCalculation.toDouble());
              }),
              EmptySpaceHelper.emptyHight(20),
              Text(
                AppLocalizations.of(context)!.chose_a_payment_method,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              EmptySpaceHelper.emptyHight(20),
              FutureBuilder(
                  future: null,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }
                    if (snapshot.hasError) {
                      snackBar(context,
                          AppLocalizations.of(context)!.an_error_occurred,
                          backgroundColor: cc.red);
                      return Text(snapshot.error.toString());
                    }
                    return Consumer<PaymentGatewayService>(
                        builder: (context, pgService, child) {
                      return Center(
                        child: Wrap(
                          runAlignment: WrapAlignment.center,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runSpacing: 12,
                          spacing: 12,
                          children: pgService.gatawayList
                              .map((e) => GestureDetector(
                                  onTap: () {
                                    if (pgService.selectedGateway == e) {
                                      return;
                                    }
                                    pgService.setSelectedGareaway(e);
                                  },
                                  child: PaymentGridTile(e.image ?? '',
                                      pgService.itemSelected(e))))
                              .toList(),
                        ),
                      );
                    });
                  }),
              Consumer<PaymentGatewayService>(
                  builder: (context, pgProvider, child) {
                return pgProvider.selectedGateway?.name == 'authorizenet'
                    ? FieldTitle(asProvider.getString('Card'))
                    : const SizedBox();
              }),
              Consumer<PaymentGatewayService>(
                  builder: (context, pgProvider, child) {
                return pgProvider.selectedGateway?.name == 'authorizenet'
                    ? TextFormField(
                        controller: _authCardController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText:
                                asProvider.getString('0000 0000 0000 0000')),
                      )
                    : const SizedBox();
              }),
              Consumer<PaymentGatewayService>(
                  builder: (context, pgProvider, child) {
                return pgProvider.selectedGateway?.name == 'authorizenet'
                    ? FieldTitle(asProvider.getString('Expiry-date'))
                    : const SizedBox();
              }),
              Consumer<PaymentGatewayService>(
                  builder: (context, pgProvider, child) {
                return pgProvider.selectedGateway?.name == 'authorizenet'
                    ? CustomOutlinedButton(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 3650),
                            ),
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                          ).then((value) {
                            pgProvider.setAuthPayED(value);
                          });
                        },
                        btText: pgProvider.authPayED == null
                            ? asProvider.getString('Select expiry-date')
                            : DateFormat.yMMM().format(pgProvider.authPayED!),
                        isLoading: false)
                    : const SizedBox();
              }),
              Consumer<PaymentGatewayService>(
                  builder: (context, pgProvider, child) {
                return pgProvider.selectedGateway?.name == 'authorizenet'
                    ? FieldTitle(asProvider.getString('Card code'))
                    : const SizedBox();
              }),
              Consumer<PaymentGatewayService>(
                  builder: (context, pgProvider, child) {
                return pgProvider.selectedGateway?.name == 'authorizenet'
                    ? TextFormField(
                        controller: _authCardCodeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: asProvider.getString('Card code')),
                      )
                    : const SizedBox();
              }),
              EmptySpaceHelper.emptyHight(20),
              Row(
                children: [
                  Transform.scale(
                    scale: 1.3,
                    child: Consumer<PaymentGatewayService>(
                        builder: (context, pgProvider, child) {
                      return Checkbox(
                        value: pgProvider.doAgree,
                        onChanged: (value) {
                          pgProvider.setDoAgree(value);
                        },
                      );
                    }),
                  ),
                  SizedBox(
                    width: screenWidth - 150,
                    child: RichText(
                      softWrap: true,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          text:
                              '${AppLocalizations.of(context)!.i_Have_Read_And_Agree_To_The_Website} ',
                          style: TextStyle(
                            color: cc.greyHint,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    FocusScope.of(context).unfocus();
                                    Navigator.of(context).pushNamed(
                                        WebViewScreen.routeName,
                                        arguments: [
                                          asProvider.getString(
                                              'Terms and Conditions'),
                                          '$baseApi/terms-and-condition-page'
                                        ]);
                                  },
                                text: asProvider.getString(
                                    'terms of service and Conditions'),
                                style: TextStyle(color: cc.secondaryColor)),
                            TextSpan(
                                text: ', ${asProvider.getString('and')} ',
                                style: TextStyle(color: cc.greyHint)),
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    FocusScope.of(context).unfocus();
                                    Navigator.of(context).pushNamed(
                                        WebViewScreen.routeName,
                                        arguments: [
                                          asProvider
                                              .getString('Privacy Policy'),
                                          '$baseApi/privacy-policy-page'
                                        ]);
                                  },
                                text: asProvider.getString('privacy policy.'),
                                style: TextStyle(color: cc.secondaryColor)),
                          ]),
                    ),
                  ),
                ],
              ),
              EmptySpaceHelper.emptyHight(20),
              Consumer<CheckoutService>(builder: (context, csProvider, child) {
                return CustomCommonButton(
                  btText: asProvider.getString('Confirm order'),
                  isLoading: csProvider.loadingPlaceOrder,
                  onPressed: () async {
                    final pgProvider = Provider.of<PaymentGatewayService>(
                        context,
                        listen: false);
                    print(pgProvider.selectedGateway?.name);

                    if (pgProvider.selectedGateway?.name == 'authorizenet' &&
                        _authCardCodeController.text.trim().isEmpty &&
                        _authCardController.text.trim().length < 3 &&
                        pgProvider.authPayED == null) {
                      showToast(
                          AppLocalizations.of(context)!
                              .please_enter_all_the_information,
                          cc.red);
                      return;
                    }

                    if (!Provider.of<ShippingAddressService>(context,
                            listen: false)
                        .allDataGiven) {
                      showToast(
                          AppLocalizations.of(context)!
                              .please_enter_all_the_shipping_info,
                          cc.red);
                      return;
                    }
                    if (!pgProvider.doAgree) {
                      showToast(
                          AppLocalizations.of(context)!
                              .you_have_agree_to_our_Terms_Conditions,
                          cc.red);
                      return;
                    }
                    startPayment(context, csProvider, null,
                        zUsername: _zitopayController.text,
                        authNetCard: _authCardController.text,
                        authNetED: pgProvider.authPayED,
                        authcCode: _authCardCodeController.text);
                  },
                );
              }),
              EmptySpaceHelper.emptyHight(30),
            ],
          ),
        ),
      )),
    );
  }

  Widget moneyRow(BuildContext context, String title, double amount) {
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
              ? amount.toStringAsFixed(2) + rtlProvider.currency
              : rtlProvider.currency + amount.toStringAsFixed(2),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
