import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../helpers/common_helper.dart';
import '../../views/payment_status_view.dart';
import '../checkout_service/checkout_service.dart';
import '../payment_gateway_service.dart';
import '../rtl_service.dart';

class StripePayment {
  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment(BuildContext context) async {
    if (Provider.of<PaymentGatewayService>(context, listen: false)
                .selectedGateway!
                .credentials['public_key'] ==
            null ||
        Provider.of<PaymentGatewayService>(context, listen: false)
                .selectedGateway!
                .credentials['secret_key'] ==
            null) {
      snackBar(context, AppLocalizations.of(context)!.invalid_developer_keys);
      return;
    }
    // Stripe.publishableKey =
    //     "";
    Stripe.publishableKey =
        Provider.of<PaymentGatewayService>(context, listen: false)
            .selectedGateway!
            .credentials['public_key']
            .toString();
    final cProvider = Provider.of<CheckoutService>(context, listen: false);
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    const orderId = '263';
    try {
      paymentIntent = await createPaymentIntent(
          context,
          (cProvider.totalOrderAmount * 100).round().toString(),
          rtlProvider.currencyCode);
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
                  // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
                  style: ThemeMode.dark,
                  merchantDisplayName: asProvider.getString('SafeCart')))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet(context);
    } catch (e, s) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => PaymentStatusView(true)),
          (Route<dynamic> route) => false);
    }
  }

  displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => PaymentStatusView(false)),
            (Route<dynamic> route) => false);

        paymentIntent = null;
      }).onError((error, stackTrace) async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => PaymentStatusView(true)),
            (Route<dynamic> route) => false);
      });
    } on StripeException catch (e) {
      await paymentFailedDialogue(context, null);
    } catch (e) {
      await paymentFailedDialogue(context, null);
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(
      BuildContext context, String amount, String currency) async {
    final cProvider = Provider.of<CheckoutService>(context, listen: false);
    const orderId = 'sdfsdf';
    final selectrdGateaway =
        Provider.of<PaymentGatewayService>(context, listen: false)
            .selectedGateway!;
    // try {
    Map<String, dynamic> body = {
      'amount': amount,
      'currency': currency,
      'payment_method_types[]': 'card'
    };

    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization': 'Bearer ${selectrdGateaway.credentials['secret_key']}',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body,
    );
    // ignore: avoid_print
    print('Payment Intent Body->>> ${response.body}');
    return jsonDecode(response.body);
    // } catch (err) {
    //   // ignore: avoid_print
    //   print('err charging user: ${err.toString()}');
    // }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }
}
