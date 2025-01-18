import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;
import 'package:provider/provider.dart';
import 'package:http_auth/http_auth.dart';

import '../payment_gateway_service.dart';

class PaypalServices {
  String domain = "https://api.sandbox.paypal.com"; // for sandbox mode
  // String domain = "https://api.paypal.com"; // for production mode

  // change clientId and secret with your own, provided by paypal

  // String clientId =
  //     'AUP7AuZMwJbkee-2OmsSZrU-ID1XUJYE-YB-2JOrxeKV-q9ZJZYmsr-UoKuJn4kwyCv5ak26lrZyb-gb';
  // String secret =
  //     'EEIxCuVnbgING9EyzcF2q-gpacLneVbngQtJ1mbx-42Lbq-6Uf6PEjgzF7HEayNsI4IFmB9_CZkECc3y';

  // for getting the access token from Paypal
  Future<String> getAccessToken(BuildContext context) async {
    final url = Uri.parse('$domain/v1/oauth2/token');
    final selectedGateaway =
        Provider.of<PaymentGatewayService>(context, listen: false)
            .selectedGateway!;
    try {
      var client = BasicAuthClient(
          selectedGateaway.credentials['sandbox_client_id'] as String,
          selectedGateaway.credentials['sandbox_client_secret'] as String);
      var response = await client.post(
          Uri.parse('$domain/v1/oauth2/token?grant_type=client_credentials'));
      print(response.body);
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        return body["access_token"];
      }
      return "0";
    } catch (e) {
      rethrow;
    }
  }

  // for creating the payment request with Paypal
  Future<Map<String, String>> createPaypalPayment(
      transactions, accessToken) async {
    // try {
    print(transactions);
    var response = await http.post(Uri.parse("$domain/v1/payments/payment"),
        body: convert.jsonEncode(transactions),
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer ' + accessToken
        });

    final body = convert.jsonDecode(response.body);
    // print(body);
    if (response.statusCode == 201) {
      if (body["links"] != null && body["links"].length > 0) {
        List links = body["links"];

        String executeUrl = "";
        String approvalUrl = "";
        final item = links.firstWhere((o) => o["rel"] == "approval_url",
            orElse: () => null);
        if (item != null) {
          approvalUrl = item["href"];
        }
        final item1 =
            links.firstWhere((o) => o["rel"] == "execute", orElse: () => null);
        if (item1 != null) {
          executeUrl = item1["href"];
        }
        print('approval:$approvalUrl\nexecute:$executeUrl');
        return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
      }
      throw Exception("0");
    } else {
      // throw Exception(body["message"]);
      return {};
    }
    // } catch (e) {
    //   rethrow;
    // }
  }

  // for executing the payment transaction
  Future<String> executePayment(url, payerId, accessToken) async {
    try {
      var response = await http.post(Uri.parse(url),
          body: convert.jsonEncode({"payer_id": payerId}),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      print(response.statusCode);
      print(body);
      if (response.statusCode == 200) {
        return body["id"];
      }
      return "0";
    } catch (e) {
      rethrow;
    }
  }
}
