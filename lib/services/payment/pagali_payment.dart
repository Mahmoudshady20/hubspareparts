import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/services/checkout_service/shipping_address_service.dart';
import 'package:safecart/services/payment_gateway_service.dart';
import 'package:safecart/utils/custom_preloader.dart';

import '../../helpers/common_helper.dart';
import '../../views/payment_status_view.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../checkout_service/checkout_service.dart';

class PagaliPayment extends StatelessWidget {
  PagaliPayment({super.key});
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
                print(snapshot.error);
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
                // javascriptMode: JavascriptMode.unrestricted,

                onLoadStop: (c, value) async {
                  print('load finish url');
                  print(value);
                  _controller!.getHtml().then((value) {
                    print(value);
                    if (value!.contains('transaction successful')) {
                      // Provider.of<ConfirmPaymentService>(context, listen: false)
                      //     .confirmPayment(context);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => PaymentStatusView(false)),
                          (Route<dynamic> route) => false);
                      return;
                    }
                    if (value.contains('Transaction not completed')) {
                      // Provider.of<ConfirmPaymentService>(context, listen: false)
                      //     .confirmPayment(context);
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
    final saProvider =
        Provider.of<ShippingAddressService>(context, listen: false);
    final orderId = cProvider.orderId;

    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://www.pagali.cv/pagali/index.php?r=pgPaymentInterface/ecommercePayment'));
    request.fields.addAll({
      'item_name': '[${saProvider.title}]',
      'quantity': '["1"]',
      'item_number': '["1"]',
      'amount': '[${cProvider.totalOrderAmount.toStringAsFixed(2)}]',
      'total_item': '["1"]',
      'order_id': '$orderId',
      'id_ent': asProvider.getString('SafeCart products'),
      'currency_code': '"1"',
      'total': '"["${cProvider.totalOrderAmount.toStringAsFixed(2)}"]"',
      'notify': 'payment.failed',
      'id_temp': 'payment.failed',
      'return': 'payment.failed'
    });

    http.StreamedResponse response = await request.send();

    final responseData = jsonDecode(await response.stream.bytesToString());
    print(responseData);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(responseData['redirect_url']);
      // final billCode = responseData.first['BillCode'];
      url = responseData['redirect_url'];
    } else {
      return true;
    }
  }
}
