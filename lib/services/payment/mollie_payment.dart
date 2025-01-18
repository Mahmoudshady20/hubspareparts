// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/services/rtl_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../helpers/common_helper.dart';
import '../../utils/custom_preloader.dart';
import '../../views/payment_status_view.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../checkout_service/checkout_service.dart';
import '../payment_gateway_service.dart';

class MolliePayment extends StatelessWidget {
  MolliePayment({super.key});
  String? url;
  String? statusURl;
  final WebViewController _controller = WebViewController();
  @override
  Widget build(BuildContext context) {
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
                return errorWidget();
              }
              if (snapshot.hasError) {
                print(snapshot.error);
                return errorWidget();
              }
              _controller
                ..loadRequest(Uri.parse(url ?? ''))
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setNavigationDelegate(NavigationDelegate(
                  onProgress: (int progress) {},
                  onNavigationRequest: (request) async {
                    if (request.url.contains('xgenious')) {
                      print('preventing navigation');
                      String status = await verifyPayment(context);
                      if (status == 'paid') {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => PaymentStatusView(false)),
                            (Route<dynamic> route) => false);
                      }
                      if (status == 'open') {}
                      if (status == 'failed') {}
                      if (status == 'expired') {}
                      return NavigationDecision.prevent;
                    }
                    if (request.url.contains('mollie')) {
                      return NavigationDecision.navigate;
                    }
                    return NavigationDecision.prevent;
                  },
                  onWebResourceError: (WebResourceError error) {},
                ));
              return WebViewWidget(
                controller: _controller,
              );
            }),
      ),
    );
  }

  waitForIt(BuildContext context) async {
    final url = Uri.parse('https://api.mollie.com/v2/payments');
    final selectedGateway =
        Provider.of<PaymentGatewayService>(context, listen: false)
            .selectedGateway!;
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer ${selectedGateway.credentials['public_key']}",
      // Above is API server key for the Midtrans account, encoded to base64
    };
    final cProvider = Provider.of<CheckoutService>(context, listen: false);
    dynamic orderId = cProvider.orderId;
    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "amount": {
            "value": cProvider.totalOrderAmount.toStringAsFixed(2),
            "currency": rtlProvider.currencyCode
          },
          "description": asProvider.getString("SafeCart products"),
          "redirectUrl": "http://www.xgenious.com",
          "webhookUrl": "http://www.xgenious.com",
          "metadata": "creditcard",
          // "method": "creditcard",
        }));
    print(response.body);
    if (response.statusCode == 201) {
      this.url = jsonDecode(response.body)['_links']['checkout']['href'];
      statusURl = jsonDecode(response.body)['_links']['self']['href'];
      print(statusURl);
      return;
    }

    return true;
  }

  verifyPayment(BuildContext context) async {
    final url = Uri.parse(statusURl as String);
    final selectedGateway =
        Provider.of<PaymentGatewayService>(context, listen: false)
            .selectedGateway!;
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer ${selectedGateway.credentials['public_key']}",
      // Above is API server key for the Midtrans account, encoded to base64
    };
    final response = await http.get(url, headers: header);
    print(jsonDecode(response.body));
    return jsonDecode(response.body)['status'].toString();
  }
}
