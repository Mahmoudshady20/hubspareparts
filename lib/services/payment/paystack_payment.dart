import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

class PaystackPayment extends StatelessWidget {
  PaystackPayment({super.key});
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
                return Center(
                  child: Text(snapshot.data.toString()),
                );
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
                  onPageFinished: (String url) async {},
                  onWebResourceError: (WebResourceError error) {},
                  onNavigationRequest: (request) {
                    if (request.url.contains('success')) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => PaymentStatusView(false)),
                          (Route<dynamic> route) => false);
                      return NavigationDecision.prevent;
                    }
                    if (request.url.contains('failed')) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => PaymentStatusView(true)),
                          (Route<dynamic> route) => false);
                      return NavigationDecision.prevent;
                    }
                    return NavigationDecision.navigate;
                  },
                ));
              return WebViewWidget(controller: _controller);
            }),
      ),
    );
  }

  Future waitForIt(BuildContext context) async {
    final uri = Uri.parse('https://api.paystack.co/transaction/initialize');
    final selectedGateway =
        Provider.of<PaymentGatewayService>(context, listen: false)
            .selectedGateway!;
    final saProvider =
        Provider.of<ShippingAddressService>(context, listen: false);
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer ${selectedGateway.credentials['secret_key']}",
    };
    final cProvider = Provider.of<CheckoutService>(context, listen: false);
    dynamic orderId = cProvider.orderId;
    final response = await http.post(uri,
        headers: header,
        body: jsonEncode({
          "amount": cProvider.totalOrderAmount.round() * 100,
          "currency": "NGN",
          "email": saProvider.email,
          "reference_id": orderId.toString(),
          "callback_url": "http://success.com",
          "metadata": {"cancel_action": "http://failed.com"}
        }));
    if (response.statusCode == 200) {
      url = jsonDecode(response.body)['data']['authorization_url'];
      return;
    }
    snackBar(context, AppLocalizations.of(context)!.payment_failed,
        backgroundColor: cc.red);
    return jsonDecode(response.body)['message'];
    // print(response.statusCode);
    // if (response.statusCode == 201) {
    // this.url =
    //     'https://sandbox.payfast.co.za/eng/process?merchant_id=${selectedGateaway.merchantId}&merchant_key=${selectedGateaway.merchantKey}&amount=$amount&item_name=SafeCartGroceries';
    // //   return;
    // // }

    // return true;
  }
}
