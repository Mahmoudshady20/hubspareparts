import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/services/checkout_service/shipping_address_service.dart';
import 'package:safecart/services/rtl_service.dart';

import '../../helpers/common_helper.dart';
import '../checkout_service/checkout_service.dart';
import '../payment_gateway_service.dart';

class CashFreePayment {
  late BuildContext context;

  Future doPayment(BuildContext context) async {
    this.context = context;
    // final checkoutData =
    //     Provider.of<CheckoutService>(context, listen: false).checkoutModel;
    final selectedGateway =
        Provider.of<PaymentGatewayService>(context, listen: false)
            .selectedGateway!;
    if (selectedGateway.credentials['app_id'] == null ||
        selectedGateway.credentials['secret_key'] == null) {
      snackBar(context, AppLocalizations.of(context)!.invalid_developer_keys,
          backgroundColor: cc.red);
      return;
    }

    final url = Uri.parse("https://test.cashfree.com/api/v2/cftoken/order");
    final cProvider = Provider.of<CheckoutService>(context, listen: false);
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    final saProvider =
        Provider.of<ShippingAddressService>(context, listen: false);
    dynamic orderId = cProvider.orderId;
    double amount = cProvider.totalOrderAmount;

    final response = await http.post(url,
        headers: {
          // "x-client-id": "223117f0ebd2772a15e84c769e711322",
          // "x-client-secret": "TESTd1389be7307c3b4afcd2a933cb69a0f3ec57ac30",
          "x-client-id": selectedGateway.credentials['app_id'] as String,
          "x-client-secret":
              selectedGateway.credentials['secret_key'] as String,
        },
        body: jsonEncode({
          "orderId": orderId,
          "orderAmount": amount.toStringAsFixed(2),
          "orderCurrency": "INR",
        }));
    if (200 == 200) {
      Map<String, dynamic> inputParams = {
        "orderId": orderId,
        "orderAmount": amount.toStringAsFixed(2),
        "customerName": saProvider.title,
        "orderCurrency": "INR",
        "appId": selectedGateway.credentials['app_id'] as String,
        "customerPhone": saProvider.phone,
        "customerEmail": saProvider.email,
        "stage": "TEST",
        // "color1": "#00B106",
        // "color2": "#ffffff",
        "tokenData": jsonDecode(response.body)['cftoken'],
        // "tokenData":
        //     "c39JCN4MzUIJiOicGbhJCLiQ1VKJiOiAXe0Jye.D49JyMmdzNxQmZmRzYwMjNiojI0xWYz9lIsMTOyMDNzQjN2EjOiAHelJCLiQ0UVJiOik3YuVmcyV3QyVGZy9mIsISNyUjI6ICduV3btFkclRmcvJCLiEDN2YjNiojIklkclRmcvJye.CW3ctYcUTPPE_oIuBaOZZ0hyxQ0_6FrEJdCTDKaqHQeEfHLCYimeq5GTIH6TBluSB2",
      };
      // print(inputParams);
      // final result = await CashfreePGSDK.doPayment(inputParams).then((value) {
      //   print('cashfree payment result $value');
      //   if (value != null) {
      //     if (value['txStatus'] == "SUCCESS") {
      //       print('Cashfree Payment successfull. Do something here');
      //       Navigator.of(context).pushAndRemoveUntil(
      //           MaterialPageRoute(
      //               builder: (context) => PaymentStatusView(false)),
      //           (Route<dynamic> route) => false);
      //     }
      //     if (value['txStatus'] == "CANCELLED") {
      //       print('Cashfree Payment successfull. Do something here');
      //       Navigator.of(context).pushAndRemoveUntil(
      //           MaterialPageRoute(
      //               builder: (context) => PaymentStatusView(true)),
      //           (Route<dynamic> route) => false);
      //     }
      //     if (value['txStatus'] == "FAILED") {
      //       print('Cashfree Payment successfull. Do something here');
      //       Navigator.of(context).pushAndRemoveUntil(
      //           MaterialPageRoute(
      //               builder: (context) => PaymentStatusView(true)),
      //           (Route<dynamic> route) => false);
      //     }
      //   }
      // });
      // print(result!['txMsg']);
    }
  }
}
