import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/services/checkout_service/shipping_address_service.dart';
import 'package:safecart/utils/custom_preloader.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../helpers/common_helper.dart';
import '../../views/payment_status_view.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../checkout_service/checkout_service.dart';
import '../payment_gateway_service.dart';

class InstamojoPayment extends StatelessWidget {
  InstamojoPayment({
    super.key,
  });
  String? selectedUrl;
  String? prevUrl;
  String? token;
  final WebViewController _controller = WebViewController();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar().appBarTitled(context, '', () async {
          paymentFailAlert(context);
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
              future: createRequest(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child:
                              SizedBox(height: 60, child: CustomPreloader())),
                    ],
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  _controller
                    ..loadRequest(Uri.parse(selectedUrl ?? ''))
                    ..setJavaScriptMode(JavaScriptMode.unrestricted)
                    ..setNavigationDelegate(NavigationDelegate(
                        onProgress: (int progress) {},
                        onPageStarted: (String url) {},
                        onPageFinished: (String url) {},
                        onWebResourceError: (WebResourceError error) {},
                        onNavigationRequest: (NavigationRequest request) async {
                          if (request.url.contains('xgenious')) {
                            if (prevUrl!.contains('status')) {
                              final response =
                                  await http.get(Uri.parse(prevUrl!));
                              if (response.body
                                  .contains('Payment Successful')) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PaymentStatusView(false)),
                                    (Route<dynamic> route) => false);
                              }
                              if (!response.body
                                  .contains('Payment Successful')) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PaymentStatusView(true)),
                                    (Route<dynamic> route) => false);
                              }
                            }
                            return NavigationDecision.prevent;
                          }
                          prevUrl = request.url;
                          return NavigationDecision.navigate;
                        }));

                  print(selectedUrl);
                  return selectedUrl == null || selectedUrl == ''
                      ? errorWidget(context)
                      : WebViewWidget(
                          controller: _controller,
                        );
                }
                return SizedBox(height: 60, child: CustomPreloader());
              }),
        ));
  }

  Future createRequest(BuildContext context) async {
    final cProvider = Provider.of<CheckoutService>(context, listen: false);
    final selectedGateway =
        Provider.of<PaymentGatewayService>(context, listen: false)
            .selectedGateway!;
    final saProvider =
        Provider.of<ShippingAddressService>(context, listen: false);
    dynamic orderId = cProvider.orderId;
    int amount = cProvider.totalOrderAmount.round();
    // print(checkoutInfo.phone.toString().length);
    Map<String, String> body = {
      "amount": '$amount', //amount to be paid
      "purpose": asProvider.getString('Safecart Products'),
      "buyer_name": saProvider.title,
      "email": saProvider.email,
      "allow_repeated_payments": "true",
      "send_email": "true",
      "phone": '1236521452',
      "send_sms": "false",
      "redirect_url": "https://www.xgenious.com/",
      //Where to redirect after a successful payment.
      "webhook": "https://www.xgenious.com/",
    };

    var header = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "X-Api-Key": "test_b678a7048c8a9e5f69663c2e4fa",
      "X-Auth-Token": "test_41af76995b230611b2c3b72b8cc"
      // "X-Api-Key": selectedGateway.credentials['client_id'] as String,
      // "X-Auth-Token": token ?? ''
    };

    var resp = await http.post(
        Uri.parse("https://test.instamojo.com/api/1.1/payment-requests/"),
        headers: header,
        body: body);
    print(resp.body);
    if (jsonDecode(resp.body)['success'] == true) {
//If request is successful take the longurl.

      selectedUrl =
          "${json.decode(resp.body)["payment_request"]['longurl']}?embed=form";
      return;

//If something is wrong with the data we provided to
//create the Payment_Request. For Example, the email is in incorrect format, the payment_Request creation will fail.
    }
  }
}
