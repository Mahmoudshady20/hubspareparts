import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../helpers/common_helper.dart';
import '../../utils/custom_preloader.dart';
import '../../views/payment_status_view.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../checkout_service/checkout_service.dart';
import '../payment_gateway_service.dart';

class PayfastPayment extends StatelessWidget {
  PayfastPayment({super.key});
  String? url;
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
                return errorWidget(context);
              }
              if (snapshot.hasError) {
                return errorWidget(context);
              }
              _controller
                ..loadRequest(Uri.parse(url ?? ''))
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setNavigationDelegate(NavigationDelegate(
                  onProgress: (int progress) {},
                  onPageStarted: (String url) {},
                  onPageFinished: (String url) async {
                    if (url.contains('finish')) {
                      bool paySuccess = await verifyPayment(url);
                      if (paySuccess) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => PaymentStatusView(false)),
                            (Route<dynamic> route) => false);
                        return;
                      }
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => PaymentStatusView(true)),
                          (Route<dynamic> route) => false);
                    }
                  },
                  onWebResourceError: (WebResourceError error) {},
                ));
              return WebViewWidget(controller: _controller);
            }),
      ),
    );
  }

  waitForIt(BuildContext context) {
    final selectedGateway =
        Provider.of<PaymentGatewayService>(context, listen: false)
            .selectedGateway!;

    final checkoutInfo = Provider.of<CheckoutService>(context, listen: false);
    // dynamic orderId = checkoutInfo.orderId;
    double amount = checkoutInfo.totalOrderAmount;
    url =
        'https://sandbox.payfast.co.za/eng/process?merchant_id=${selectedGateway.credentials['merchant_id']}&merchant_key=${selectedGateway.credentials['merchant_key']}&amount=${amount.toStringAsFixed(2)}&item_name=${asProvider.getString('SafeCart Groceries')}';
    //   return;
    // }

    // return true;
  }

  Future<bool> verifyPayment(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    return response.body.contains('successful');
  }
}
