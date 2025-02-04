import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/services/payment_gateway_service.dart';
import 'package:safecart/utils/custom_preloader.dart';

import '../../helpers/common_helper.dart';
import '../../views/payment_status_view.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../checkout_service/checkout_service.dart';
import '../checkout_service/shipping_address_service.dart';

class BillplzPayment extends StatelessWidget {
  BillplzPayment({super.key});
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
          bool canGoBack = await _controller!.canGoBack();
          if (_controller != null && canGoBack) {
            _controller!.goBack();
            return false;
          }
          paymentFailAlert(context);
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
                return errorWidget();
              }
              if (snapshot.hasError) {
                print(snapshot.error);
                return errorWidget();
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
                // javascriptMode: JavascriptMode.unrestricted,

                onLoadStop: (c, value) async {
                  verifyPayment(value.toString(), context);
                },
              );
            }),
      ),
    );
  }

  waitForIt(BuildContext context) async {
    final cProvider = Provider.of<CheckoutService>(context, listen: false);
    final saProvider =
        Provider.of<ShippingAddressService>(context, listen: false);
    final pgProvider =
        Provider.of<PaymentGatewayService>(context, listen: false);
    final orderId = cProvider.orderId;
    double amount = cProvider.totalOrderAmount;

    final url = Uri.parse('https://www.billplz-sandbox.com/api/v3/bills');
    var username = pgProvider.selectedGateway?.credentials['key'];
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$username'))}';
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": basicAuth,
      // Above is API server key for the Midtrans account, encoded to base64
    };
    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "collection_id":
              pgProvider.selectedGateway?.credentials['collection_name'],
          "description": asProvider.getString("SafeCart payment"),
          "email": saProvider.email,
          "name": saProvider.title,
          "amount": amount.toStringAsFixed(2),
          "reference_1_label": "Bank Code",
          "reference_1": "BP-FKR01",
          "callback_url": "http://www.gxenious.com"
        }));
    print(response.body);
    if (response.statusCode == 200) {
      this.url = jsonDecode(response.body)["url"];
      return;
    }

    return true;
  }
}

Future verifyPayment(String url, BuildContext context) async {
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  if (response.body.contains('paid')) {
    // Provider.of<ConfirmPaymentService>(context, listen: false)
    //     .confirmPayment(context);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => PaymentStatusView(false)),
        (Route<dynamic> route) => false);
    return;
  }
  if (response.body.contains('your payment was not')) {
    await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.payment_failed),
            content:
                Text(AppLocalizations.of(context)!.payment_has_been_failed),
            actions: [
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => PaymentStatusView(true)),
                    (Route<dynamic> route) => false),
                child: Text(
                  AppLocalizations.of(context)!.ok,
                  style: TextStyle(color: cc.primaryColor),
                ),
              )
            ],
          );
        });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => PaymentStatusView(true)),
        (Route<dynamic> route) => false);
    return;
  }
}
