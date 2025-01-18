import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/services/checkout_service/shipping_address_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../helpers/common_helper.dart';
import '../../utils/custom_preloader.dart';
import '../../views/payment_status_view.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../checkout_service/checkout_service.dart';
import '../payment_gateway_service.dart';
import '../rtl_service.dart';

class RazorpayPayment extends StatelessWidget {
  RazorpayPayment({super.key});
  String? url;
  String? paymentID;
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
                  onPageStarted: (String url) async {
                    final uri = Uri.parse(url);
                    final response = await http.get(uri);
                    bool paySuccess = response.body.contains('status":"paid');
                    if (paySuccess) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => PaymentStatusView(false)),
                          (Route<dynamic> route) => false);
                      return;
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

  Future waitForIt(BuildContext context) async {
    final selectedGateaway =
        Provider.of<PaymentGatewayService>(context, listen: false)
            .selectedGateway!;
    final uri = Uri.parse('https://api.razorpay.com/v1/payment_links');
    // String username = "rzp_test_qfnlVh6GDZoveL";
    // String password = "1BKI89076hFeXRsbGuSaj29C";
    final username = selectedGateaway.credentials['api_key'];
    final password = selectedGateaway.credentials['api_secret'];
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": basicAuth,
    };
    final cProvider = Provider.of<CheckoutService>(context, listen: false);
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    final saProvider =
        Provider.of<ShippingAddressService>(context, listen: false);
    final orderId = cProvider.orderId;
    final response = await http.post(uri,
        headers: header,
        body: jsonEncode({
          "amount": cProvider.totalOrderAmount.round() * 100,
          //NOTE: When used USD giving error page.
          "currency": "INR",
          "accept_partial": false,
          "reference_id": orderId.toString(),
          "description": asProvider.getString('SafeCart Products'),
          "customer": {
            "name": saProvider.title,
            "contact": saProvider.phone,
            "email": saProvider.email
          },
          // "notify": {"sms": true, "email": true},
          "notes": {"policy_name": asProvider.getString('SafeCart')},
        }));
    print(response.body);
    if (response.statusCode == 200) {
      url = jsonDecode(response.body)['short_url'];
      paymentID = jsonDecode(response.body)['id'];
      print(url);
      return;
    }
    showToast(asProvider.getString('Connection failed'), cc.red);
    return 'failed';
  }

  Future<bool> verifyPayment(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body.contains('Payment Completed'));
    return response.body.contains('Payment Completed');
  }
}
