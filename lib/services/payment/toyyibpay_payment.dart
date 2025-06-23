import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
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
import '../rtl_service.dart';

class ToyyibPayPayment extends StatelessWidget {
  ToyyibPayPayment({super.key});
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
                  _controller!.getHtml().then((value) {
                    if (value != null && value.contains('Payment Approved')) {
                      // Provider.of<ConfirmPaymentService>(context, listen: false)
                      //     .confirmPayment(context);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => PaymentStatusView(false)),
                          (Route<dynamic> route) => false);
                      return;
                    }
                    if (value != null &&
                        value.contains('Payment Unsuccessful')) {
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
    final saProvider =
        Provider.of<ShippingAddressService>(context, listen: false);

    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    final cProvider = Provider.of<CheckoutService>(context, listen: false);
    dynamic orderId = cProvider.orderId;
//username&password:11234
    var headers = {'Content-Type': 'x-www-form-urlencoded'};
    var request = http.MultipartRequest('POST',
        Uri.parse('https://dev.toyyibpay.com/index.php/api/createBill'));
    request.fields.addAll({
      'userSecretKey':
          paymentGateway.selectedGateway?.credentials['client_secret'] ?? '',
      'categoryCode':
          paymentGateway.selectedGateway?.credentials['category_code'] ?? '',
      'billName': asProvider.getString('SafeCart products'),
      'billDescription': asProvider.getString('SafeCart products'),
      'billPriceSetting': '1',
      'billAmount': cProvider.totalOrderAmount.toStringAsFixed(2),
      'billPayorInfo': '1',
      'billTo': saProvider.title ?? '',
      'billEmail': saProvider.email ?? '',
      'billPhone': saProvider.phone ?? '',
      'cancel_url': 'www.cancel.com',
      'success_url': 'www.success.com'
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseData = jsonDecode(await response.stream.bytesToString());
      final billCode = responseData.first['BillCode'];
      url = 'https://dev.toyyibpay.com/$billCode';
    } else {
      return true;
    }
  }
}
