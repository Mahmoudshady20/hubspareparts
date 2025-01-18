import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helpers/common_helper.dart';
import '../models/payment_gateway_model.dart';

class PaymentGatewayService with ChangeNotifier {
  List<Datum> gatawayList = [];
  Datum? selectedGateway;
  bool isLoading = false;
  DateTime? authPayED;
  bool doAgree = false;

  setSelectedGareaway(value) {
    selectedGateway = value;
    print(selectedGateway?.name);
    notifyListeners();
  }

  setDoAgree(value) {
    doAgree = value;
    notifyListeners();
  }

  setAuthPayED(value) {
    if (value == authPayED) {
      return;
    }
    authPayED = value;
    notifyListeners();
  }

  bool itemSelected(value) {
    if (selectedGateway == null) {
      return false;
    }
    return selectedGateway == value;
  }

  setIsLoading(value) {
    isLoading = value;
    notifyListeners();
  }

  resetGateway() {
    selectedGateway = null;
    authPayED = null;
    doAgree = false;
    notifyListeners();
  }

  fetchGateways(BuildContext context) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }
    if (gatawayList.isNotEmpty) {
      return;
    }

    try {
      var headers = {'x-api-key': paymentGatewayKey};
      var request =
          http.Request('GET', Uri.parse('$baseApi/payment-gateway-list'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      final data = jsonDecode(await response.stream.bytesToString());
      // print(data);
      if (response.statusCode == 200) {
        gatawayList = PaymentGatewayModel.fromJson(data).data;
        notifyListeners();
        return;
      } else {
        print(response.reasonPhrase);
      }
    } on TimeoutException {
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (err) {
      showToast(err.toString(), cc.red);
      print(err);
    }
  }
}
