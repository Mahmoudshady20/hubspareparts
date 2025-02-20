// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/services/checkout_service/checkout_service.dart';

import '../../helpers/common_helper.dart';
import '../../views/payment_status_view.dart';

class AuthrizeNetPay {
  static authorizeNetPay(
      BuildContext context, card, DateTime edate, ccode) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }
    debugPrint('sending otpCode');
    try {
      final cProvider = Provider.of<CheckoutService>(context, listen: false);
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://apitest.authorize.net/xml/v1/request.api'));
      dynamic orderId = cProvider.orderId;
      double amount = cProvider.totalOrderAmount;
      request.body = json.encode({
        "createTransactionRequest": {
          "merchantAuthentication": {
            "name": "568Yc9uV3",
            "transactionKey": "9tzGhhbEG57V367E"
          },
          "refId": "ddffds$orderId",
          "transactionRequest": {
            "transactionType": "authCaptureTransaction",
            "amount": amount.toStringAsFixed(2),
            "payment": {
              "creditCard": {
                "cardNumber": "$card",
                "expirationDate": "${edate.year}-${edate.month}",
                "cardCode": "$ccode"
              }
            },
            "tax": {
              "amount": "0",
              "name": "level2 tax name",
              "description": "level2 tax"
            },
            "duty": {
              "amount": "0",
              "name": "duty name",
              "description": "duty description"
            },
            "shipping": {
              "amount": "0",
              "name": "level2 tax name",
              "description": "level2 tax"
            },
            "customer": {"id": "99999456654"},
            "customerIP": "192.168.1.1",
            "transactionSettings": {
              "setting": {"settingName": "testRequest", "settingValue": "false"}
            },
            "userFields": {
              "userField": [
                {
                  "name": "MerchantDefinedFieldName1",
                  "value": "MerchantDefinedFieldValue1"
                },
                {"name": "favorite_color", "value": "blue"}
              ]
            },
            "processingOptions": {"isSubsequentAuth": "true"},
            "subsequentAuthInformation": {
              "originalNetworkTransId": "d7dfas$orderId",
              "originalAuthAmount": "$amount",
              "reason": "resubmission"
            },
            "authorizationIndicatorType": {"authorizationIndicator": "final"}
          }
        }
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final data = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        if (data.contains('This transaction has been approved')) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => PaymentStatusView(false)),
              (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => PaymentStatusView(true)),
              (Route<dynamic> route) => false);
          showToast(AppLocalizations.of(context)!.payment_failed, cc.red);
        }
      } else {
        showToast(response.reasonPhrase.toString().capitalize(), cc.red);
      }
    } on TimeoutException {
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      showToast(err.toString(), cc.red);
    }
  }
}
