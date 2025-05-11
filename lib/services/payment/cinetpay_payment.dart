import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/services/checkout_service/checkout_service.dart';
import 'package:safecart/services/checkout_service/shipping_address_service.dart';
import 'package:safecart/services/profile_info_service.dart';
import 'package:safecart/services/rtl_service.dart';
import 'package:safecart/utils/custom_preloader.dart';

import '../../helpers/common_helper.dart';
import '../../views/payment_status_view.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../payment_gateway_service.dart';

class CinetPayPayment extends StatelessWidget {
  CinetPayPayment({super.key});
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
                return errorWidget(context);
              }
              if (snapshot.hasError) {
                return errorWidget(context);
              }
              return InAppWebView(
                onWebViewCreated: ((controller) {
                  _controller = controller;
                }),
                onLoadError: (controller, url, code, message) => showDialog(
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

                onLoadStop: (_, value) async {
                  // final title = await _controller.currentUrl();
                  // print(title);
                  // if (value.contains('finish')) {
                  //   bool paySuccess = await verifyPayment(value);
                  //   print('closing payment......');
                  //   print('closing payment.............');
                  //   print('closing payment...................');
                  //   print('closing payment..........................');
                  //   if (paySuccess) {
                  //     Navigator.of(context).pop();
                  //     return;
                  //   }
                  //   await showDialog(
                  //       context: context,
                  //       builder: (ctx) {
                  //         return AlertDialog(
                  //           title: Text('Payment failed!'),
                  //           content: Text('Payment has been cancelled.'),
                  //           actions: [
                  //             Spacer(),
                  //             TextButton(
                  //               onPressed: () => Navigator.of(context).pop(),
                  //               child: Text(
                  //                 'Ok',
                  //                 style: TextStyle(color: cc.primaryColor),
                  //               ),
                  //             )
                  //           ],
                  //         );
                  //       });
                  //   Navigator.of(context).pop();
                  // }
                },
                // onPageStarted: (value) {
                //   print("on progress.........................$value");
                //   if (value.contains('finish')) {
                //     print('closing payment......');
                //     print('closing payment.............');
                //     print('closing payment...................');
                //     print('closing payment..........................');
                //     Navigator.of(context).pop();
                //   }
                // },
                // navigationDelegate: (navRequest) async {
                //   print('nav req to .......................${navRequest.url}');
                //   return NavigationDecision.navigate;
                // },
                // javascriptChannels: <JavascriptChannel>[
                //   // Set Javascript Channel to WebView
                //   JavascriptChannel(
                //       name: 'same',
                //       onMessageReceived: (javMessage) {
                //         print(javMessage.message);
                //         print('...........................................');
                //       }),
                // ].toSet(),
              );
            }),
      ),
    );
  }

  waitForIt(BuildContext context) async {
    final selectedGateway =
        Provider.of<PaymentGatewayService>(context, listen: false)
            .selectedGateway!;
    final cProvider = Provider.of<CheckoutService>(context, listen: false);
    final saProvider =
        Provider.of<ShippingAddressService>(context, listen: false);
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    final piProvider = Provider.of<ProfileInfoService>(context, listen: false);
    double amount = cProvider.totalOrderAmount;
    dynamic orderId = cProvider.orderId;
    String username = saProvider.title ?? '';
    final url = Uri.parse('https://api-checkout.cinetpay.com/v2/payment');
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "apikey": "12912847765bc0db748fdd44.40081707",
          "site_id": "445160",
          "transaction_id": "afsdeds",
          "amount": amount.round(),
          "currency": rtlProvider.currencyCode,
          "alternative_currency": "USD",
          "description": asProvider.getString('SafeCart Products'),
          "customer_id": piProvider.profileInfo?.userDetails.id ?? '123',
          "customer_name": saProvider.title,
          "customer_surname": saProvider.title,
          "customer_email": saProvider.email,
          "customer_phone_number": saProvider.phone,
          "customer_address": saProvider.streetAddress,
          "customer_city": saProvider.townCity,
          "customer_country": "CM",
          "customer_state": "CM",
          "customer_zip_code": saProvider.zipcode,
          "channels": "ALL"
        }
            //   {
            //   "apikey": "12912847765bc0db748fdd44.40081707",
            //   "site_id": "445160",
            //   "transaction_id": "$orderId",
            //   "amount": amount.toInt(),
            //   "currency": "USD",
            //   "alternative_currency": "USD",
            //   "description": " SafeCart ",
            //   "customer_id": "${userData.id}",
            //   "customer_name": "${userData.name}",
            //   "customer_surname": "",
            //   "customer_email": "${userData.email}",
            //   "customer_phone_number": "${userData.phone}",
            //   "customer_address": "${shippingAddress.address}",
            //   "customer_city": "${shippingAddress.city}",
            //   "customer_country": "CM",
            //   "customer_state": "CM",
            //   "customer_zip_code": "${shippingAddress.zipCode}",
            //   "channels": "ALL"
            // }
            ));
    if (response.statusCode == 200) {
      this.url = jsonDecode(response.body)['data']['payment_url'];
      return;
    }

    return true;
  }

  Future<bool> verifyPayment(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    return response.body.contains('successful');
  }
}
