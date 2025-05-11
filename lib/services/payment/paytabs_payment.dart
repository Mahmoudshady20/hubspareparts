import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/services/payment_gateway_service.dart';
import 'package:safecart/services/rtl_service.dart';
import 'package:safecart/utils/custom_preloader.dart';

import '../../helpers/common_helper.dart';
import '../../views/payment_status_view.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../checkout_service/checkout_service.dart';

class PaytabsPayment extends StatelessWidget {
  PaytabsPayment({super.key});
  String? url;
  InAppWebViewController? _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar().appBarTitled(context, '', () async {
        await paymentFailAlert(context);
      }),
      body: WillPopScope(
        onWillPop: () async {
          if (_controller != null) {
            bool canGoBack = await _controller!.canGoBack();
            _controller!.goBack();
            return !canGoBack;
          }
          await paymentFailAlert(context);
          return false;
        },
        child: FutureBuilder(
            future: waitForIt(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: SizedBox(height: 60, child: CustomPreloader())),
                  ],
                );
              }
              if (snapshot.hasData) {
                return errorWidget(context);
              }
              if (snapshot.hasError) {
                return errorWidget(context);
              }

              return InAppWebView(
                onWebViewCreated: (controller) {
                  _controller = controller;
                },
                onLoadError: (c, uri, i, s) => showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title:
                            Text(AppLocalizations.of(context)!.loading_failed),
                        content: Text(AppLocalizations.of(context)!
                            .failed_to_load_payment_page),
                        actions: [
                          const Spacer(),
                          TextButton(
                            onPressed: () => Navigator.of(context)
                                .pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PaymentStatusView(true)),
                                    (Route<dynamic> route) => false),
                            child: Text(
                              AppLocalizations.of(context)!.return_button,
                              style: TextStyle(color: cc.primaryColor),
                            ),
                          )
                        ],
                      );
                    }),
                onLoadHttpError: (controller, url, statusCode, description) =>
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text(
                                AppLocalizations.of(context)!.loading_failed),
                            content: Text(AppLocalizations.of(context)!
                                .failed_to_load_payment_page),
                            actions: [
                              const Spacer(),
                              TextButton(
                                onPressed: () => Navigator.of(context)
                                    .pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PaymentStatusView(true)),
                                        (Route<dynamic> route) => false),
                                child: Text(
                                  AppLocalizations.of(context)!.return_button,
                                  style: TextStyle(color: cc.primaryColor),
                                ),
                              )
                            ],
                          );
                        }),
                initialUrlRequest: URLRequest(url: WebUri(url!)),
                onLoadStop: (c, value) async {
                  _controller!.getHtml().then((value) {
                    if (value!.contains('transaction successful')) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => PaymentStatusView(false)),
                          (Route<dynamic> route) => false);
                      return;
                    }
                    if (value.contains('Transaction not completed')) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => PaymentStatusView(true)),
                          (Route<dynamic> route) => false);
                      return;
                    }
                  });
                },
              );
            }),
      ),
    );
  }

  waitForIt(BuildContext context) async {
    final paymentGateway =
        Provider.of<PaymentGatewayService>(context, listen: false);
    final cProvider = Provider.of<CheckoutService>(context, listen: false);
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    final orderId = cProvider.orderId;

    var headers = {
      'authorization':
          paymentGateway.selectedGateway?.credentials['server_key'] ?? '',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('https://secure-global.paytabs.com/payment/request'));
    request.body = json.encode({
      "profile_id": paymentGateway.selectedGateway?.credentials['profile_id'],
      "tran_type": "sale",
      "tran_class": "ecom",
      "cart_id": "$orderId",
      "cart_currency": rtlProvider.currencyCode,
      "cart_amount": cProvider.totalOrderAmount,
      "cart_description": asProvider.getString('SafeCart products'),
      "paypage_lang": "en",
      "callback": "",
      "return": ""
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final responseData = jsonDecode(await response.stream.bytesToString());
    if (response.statusCode == 200) {
      // final billCode = responseData.first['BillCode'];
      url = responseData['redirect_url'];
    } else {
      return true;
    }
  }
}
