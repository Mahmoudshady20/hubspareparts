import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../helpers/common_helper.dart';
import '../../utils/custom_preloader.dart';
import '../../views/payment_status_view.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../checkout_service/checkout_service.dart';
import '../rtl_service.dart';
import 'paypal_service.dart';

class PaypalPayment extends StatefulWidget {
  final Function onFinish;

  const PaypalPayment({super.key, required this.onFinish});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var checkoutUrl;
  var executeUrl;
  var accessToken;
  PaypalServices services = PaypalServices();

  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      // try {
      accessToken = await services.getAccessToken(context);

      final transactions = getOrderParams(context);
      final res = await services.createPaypalPayment(transactions, accessToken);
      setState(() {
        checkoutUrl = res["approvalUrl"];
        executeUrl = res["executeUrl"];
      });
    });
    if (checkoutUrl != null) {
      _controller
        ..loadRequest(Uri.parse(checkoutUrl ?? ''))
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) async {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (request) {
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              print(payerID);
              if (payerID != null) {
                services
                    .executePayment(executeUrl, payerID, accessToken)
                    .then((id) async {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => PaymentStatusView(false)),
                      (Route<dynamic> route) => false);
                });
              } else {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => PaymentStatusView(true)),
                    (Route<dynamic> route) => false);
              }
            }
            if (request.url.contains(cancelURL)) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => PaymentStatusView(true)),
                  (Route<dynamic> route) => false);
            }
            return NavigationDecision.navigate;
          },
        ));
    }
  }

  Map<String, dynamic> getOrderParams(BuildContext context) {
    final cProvider = Provider.of<CheckoutService>(context, listen: false);
    final orderId = cProvider.orderId;

    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": cProvider.totalOrderAmount,
            "currency": rtlProvider.currencyCode,
            // "details": {
            //   "subtotal": cartData.calculateSubtotal().toStringAsFixed(2),
            //   "shipping":checkoutInfo!.,
            //   "shipping_discount": cuponData.cuponDiscount.toStringAsFixed(2),
            // }
          },
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {
        "return_url": "return.example.com",
        "cancel_url": "cancel.example.com"
      }
    };
    return temp;
  }

  final WebViewController _controller = WebViewController();

  @override
  Widget build(BuildContext context) {
    print(checkoutUrl);

    if (checkoutUrl != null) {
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
          child: WebViewWidget(
            controller: _controller,
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: CustomAppBar().appBarTitled(context, '', () async {
          await paymentFailAlert(context);
        }),
        body: WillPopScope(
            onWillPop: () async {
              await paymentFailAlert(context);
              return true;
            },
            child: Center(
                child: Container(
                    child: SizedBox(height: 60, child: CustomPreloader())))),
      );
    }
  }
}
