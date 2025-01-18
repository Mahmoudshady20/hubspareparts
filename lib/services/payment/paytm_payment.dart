import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../../helpers/common_helper.dart';
import '../../widgets/common/custom_app_bar.dart';

class PaytmPayment extends StatelessWidget {
  PaytmPayment({super.key, this.html});
  final WebViewController _controller = WebViewController();
  String? html;
  @override
  Widget build(BuildContext context) {
    _controller
      ..loadHtmlString(html ?? "")
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) async {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (request) {
          return NavigationDecision.navigate;
        },
      ));
    return Scaffold(
      appBar: CustomAppBar().appBarTitled(context, '', () async {
        await paymentFailAlert(context);
      }),
      body: WillPopScope(
        onWillPop: () async {
          await paymentFailAlert(context);
          return false;
        },
        child: WebViewWidget(
          controller: _controller,
        ),
      ),
    );
  }
}

Future<bool> verifyPayment(String url) async {
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  print(response.body.contains('successful'));
  return response.body.contains('successful');
}
