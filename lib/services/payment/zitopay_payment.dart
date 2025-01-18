// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/services/checkout_service/checkout_service.dart';
import 'package:safecart/services/rtl_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../helpers/common_helper.dart';
import '../../views/payment_status_view.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../payment_gateway_service.dart';

class ZitopayPayment extends StatelessWidget {
  ZitopayPayment(this.userName, {super.key});
  String? userName;
  final WebViewController _controller = WebViewController();
  @override
  Widget build(BuildContext context) {
    final cProvider = Provider.of<CheckoutService>(context, listen: false);
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    final selectedGateway =
        Provider.of<PaymentGatewayService>(context, listen: false)
            .selectedGateway!;
    final url =
        'https://zitopay.africa/sci/?currency=${rtlProvider.currencyCode}&amount=${cProvider.totalOrderAmount.toStringAsFixed(2)}&receiver=${selectedGateway.credentials['username']}';

    _controller
      ..loadRequest(Uri.parse(url))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {},
        onPageStarted: (String url) async {},
        onPageFinished: (String url) async {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (request) async {
          if (!request.url.contains('confirm_trans')) {
            return NavigationDecision.navigate;
          }
          bool paySuccess = await verifyPayment(request.url);
          if (paySuccess) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => PaymentStatusView(false)),
                (Route<dynamic> route) => false);
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => PaymentStatusView(true)),
                (Route<dynamic> route) => false);
          }
          return NavigationDecision.prevent;
        },
      ));
    return Scaffold(
        appBar: CustomAppBar().appBarTitled(context, '', () async {
          await paymentFailAlert(context);
        }),
        body: WillPopScope(
          onWillPop: () async {
            bool canGoBack = await _controller.canGoBack();
            if (canGoBack) {
              _controller.goBack();
              return false;
            }
            paymentFailAlert(context);
            return false;
          },
          child: WebViewWidget(controller: _controller),
        ));
  }
}

Future<bool> verifyPayment(String url) async {
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  return response.body.contains('successful');
}
