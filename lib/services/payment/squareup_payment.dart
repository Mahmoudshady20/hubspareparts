import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../helpers/common_helper.dart';
import '../../utils/custom_preloader.dart';
import '../../views/payment_status_view.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../checkout_service/checkout_service.dart';
import '../checkout_service/shipping_address_service.dart';
import '../payment_gateway_service.dart';
import '../rtl_service.dart';

class SquareUpPayment extends StatelessWidget {
  SquareUpPayment({super.key});
  String? url;
  final WebViewController _controller = WebViewController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
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
                  onPageStarted: (String url) async {
                    final response = await http.get(Uri.parse(url));
                    if (response.body.contains('"tenders_finalized":true')) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => PaymentStatusView(false)),
                          (Route<dynamic> route) => false);
                    }
                  },
                  onPageFinished: (String url) async {},
                  onWebResourceError: (WebResourceError error) {},
                  onNavigationRequest: (request) {
                    return NavigationDecision.navigate;
                  },
                ));
              return WebViewWidget(controller: _controller);
            }),
      ),
    );
  }

  waitForIt(BuildContext context) async {
    final url = Uri.parse(
        'https://connect.squareupsandbox.com/v2/online-checkout/payment-links');
    final selectedGateway =
        Provider.of<PaymentGatewayService>(context, listen: false)
            .selectedGateway!;
    final saProvider =
        Provider.of<ShippingAddressService>(context, listen: false);

    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    final cProvider = Provider.of<CheckoutService>(context, listen: false);
    dynamic orderId = cProvider.orderId;
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": 'Bearer  ${selectedGateway.credentials['access_token']}',
    };
    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "description": asProvider.getString('SafeCart products'),
          "idempotency_key": '$orderId',
          "quick_pay": {
            "location_id": selectedGateway.credentials['location_id'],
            "name": asProvider.getString('SafeCart products'),
            "price_money": {
              "amount": cProvider.totalOrderAmount.round(),
              "currency": rtlProvider.currencyCode
            }
          },
          "payment_note": saProvider.orderNote,
          "pre_populated_data": {
            "buyer_email": saProvider.email,
          }
        }));
    print(response.body);
    if (response.statusCode == 200) {
      this.url = jsonDecode(response.body)['payment_link']['url'];
      print(this.url);
      return;
    }

    return true;
  }

  Future<bool> verifyPayment(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body.contains('successful'));
    return response.body.contains('successful');
  }
}
