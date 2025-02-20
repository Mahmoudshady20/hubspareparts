import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:safecart/services/checkout_service/shipping_address_service.dart';
import 'package:safecart/services/rtl_service.dart';

import '../../helpers/common_helper.dart';
import '../../views/payment_status_view.dart';
import '../checkout_service/checkout_service.dart';
import '../payment_gateway_service.dart';

class FlutterWavePayment {
  late BuildContext context;
  String currency = 'USD';

  void makePayment(BuildContext context) async {
    this.context = context;
    _handlePaymentInitialization(context);
  }

  _handlePaymentInitialization(BuildContext context) async {
    final cProvider = Provider.of<CheckoutService>(context, listen: false);
    final selectedGateway =
        Provider.of<PaymentGatewayService>(context, listen: false)
            .selectedGateway!;
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    final saProvider =
        Provider.of<ShippingAddressService>(context, listen: false);
    if (selectedGateway.credentials['public_key'] == null ||
        selectedGateway.credentials['secret_key'] == null) {
      snackBar(context, AppLocalizations.of(context)!.invalid_developer_keys);
    }
    String publicKey = selectedGateway.credentials['public_key'] ?? '';

    // final style = FlutterwaveStyle(
    //   appBarText: "Flutterwave payment",
    //   buttonColor: cc.primaryColor,
    //   buttonTextStyle: const TextStyle(
    //     color: Colors.white,
    //     fontSize: 16,
    //   ),
    //   appBarColor: cc.pureWhite,
    //   dialogCancelTextStyle: const TextStyle(
    //     color: Colors.grey,
    //     fontSize: 17,
    //   ),
    //   dialogContinueTextStyle: TextStyle(
    //     color: cc.primaryColor,
    //     fontSize: 17,
    //   ),
    //   mainBackgroundColor: Colors.white,
    //   mainTextStyle:
    //       const TextStyle(color: Colors.black, fontSize: 17, letterSpacing: 2),
    //   dialogBackgroundColor: Colors.white,
    //   appBarIcon: Icon(Icons.arrow_back, color: cc.blackColor),
    //   buttonText: rtlProvider.curRtl
    //       ? "Pay  ${cProvider.totalOrderAmount.toStringAsFixed(2)}${rtlProvider.currency}"
    //       : "Pay  ${rtlProvider.currency}${cProvider.totalOrderAmount.toStringAsFixed(2)}",
    //   appBarTitleTextStyle: const TextStyle(
    //     color: Colors.white,
    //     fontSize: 18,
    //   ),
    // );

    // final Customer customer = Customer(
    //     name: saProvider.title,
    //     phoneNumber: saProvider.phone,
    //     email: saProvider.email);

    // // final checkoutInfo = Provider.of<CheckoutService>(context, listen: false);
    // const orderId = '2145';
    // final Flutterwave flutterwave = Flutterwave(
    //     context: context,
    //     style: style,
    //     publicKey: publicKey,
    //     currency: currency,
    //     txRef: const Uuid().v1(),
    //     amount: cProvider.totalOrderAmount.toStringAsFixed(0),
    //     customer: customer,
    //     paymentOptions: "card, payattitude",
    //     customization:
    //         Customization(title: asProvider.getString('SafeCart Products')),
    //     redirectUrl: "https://www.google.com",
    //     isTestMode: false);
    // var response = await flutterwave.charge().catchError((_) {
    //   Navigator.of(context).pushAndRemoveUntil(
    //       MaterialPageRoute(builder: (context) => PaymentStatusView(true)),
    //       (Route<dynamic> route) => false);
    // });
    // if (response.success ?? false) {
    //   Navigator.of(context).pushAndRemoveUntil(
    //       MaterialPageRoute(builder: (context) => PaymentStatusView(false)),
    //       (Route<dynamic> route) => false);
    // } else {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => PaymentStatusView(true)),
        (Route<dynamic> route) => false);
    // }
  }
}
