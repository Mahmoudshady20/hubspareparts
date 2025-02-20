import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/services/checkout_service/shipping_address_service.dart';
import 'package:safecart/services/rtl_service.dart';
import 'package:safecart/utils/custom_preloader.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../helpers/common_helper.dart';
import '../../views/payment_status_view.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../checkout_service/checkout_service.dart';
import '../payment_gateway_service.dart';

class MercadopagoPayment extends StatelessWidget {
  MercadopagoPayment({super.key});
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
            future: getPaymentUrl(context),
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
                print(snapshot.error);
                return errorWidget(context);
              }
              _controller
                ..loadRequest(Uri.parse(url ?? ''))
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setNavigationDelegate(NavigationDelegate(
                    onProgress: (int progress) {},
                    onPageStarted: (String url) {},
                    onPageFinished: (String url) {},
                    onWebResourceError: (WebResourceError error) {},
                    onNavigationRequest: (NavigationRequest request) async {
                      if (request.url.contains('success')) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => PaymentStatusView(false)),
                            (Route<dynamic> route) => false);
                        return NavigationDecision.prevent;
                      }
                      if (request.url.contains('failure') ||
                          request.url.contains('pending')) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => PaymentStatusView(true)),
                            (Route<dynamic> route) => false);
                        return NavigationDecision.prevent;
                      }
                      return NavigationDecision.navigate;
                    }));
              return WebViewWidget(
                controller: _controller,
              );
            }),
      ),
    );
  }

  Future<dynamic> getPaymentUrl(BuildContext context) async {
    final selectedGateway =
        Provider.of<PaymentGatewayService>(context, listen: false)
            .selectedGateway!;
    final rtlProvider = Provider.of<RTLService>(context, listen: false);
    final cProvider = Provider.of<CheckoutService>(context, listen: false);
    final saProvider =
        Provider.of<ShippingAddressService>(context, listen: false);
    if (selectedGateway.credentials['client_secret'] == null) {
      snackBar(context, AppLocalizations.of(context)!.invalid_developer_keys,
          backgroundColor: cc.red);
    }
    var header = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    };

    var data = jsonEncode({
      "items": [
        {
          "title": asProvider.getString("Safecart Products"),
          "description": asProvider.getString('Safecart Products'),
          "quantity": 1,
          "currency_id": 'ARS',
          "unit_price": cProvider.totalOrderAmount.round()
        }
      ],
      "payer": {"email": saProvider.email},
      "back_urls": {
        "failure": "failure.com",
        "pending": "pending.com",
        "success": "success.com"
      },
      "auto_return": "approved"
    });

    var response = await http.post(
        Uri.parse(
            'https://api.mercadopago.com/checkout/preferences?access_token=${selectedGateway.credentials['client_secret']}'),
        headers: header,
        body: data);

    print(response.body);
    if (response.statusCode == 201) {
      url = jsonDecode(response.body)['init_point'];
      print(response.body);

      return;
    }
    return '';
  }
}
