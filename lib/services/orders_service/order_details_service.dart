import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../helpers/common_helper.dart';
import '../../models/order_details_model.dart';

class OrderDetailsService with ChangeNotifier {
  OrderDetailsModel? orderDetailsModel;

  clearOrderDetails() {
    orderDetailsModel = null;
  }

  Color statusColor(String status) {
    if (status == 'pending') {
      return cc.statusColors[0];
    } else if (status == 'canceled') {
      return cc.statusColors[4];
    }
    return cc.statusColors[2];
  }

  Future fetchOrderDetails(BuildContext context, String id) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }

    try {
      print(getToken);
      var headers = {
        // 'x-api-key': 'b8f4a0ba4537ad6c3ee41ec0a43549d1',
        'Authorization': 'Bearer $getToken'
      };
      var request = http.Request('GET',
          Uri.parse('$baseApi/user/order-detail/${id.replaceAll('#', '')}'));

      request.headers.addAll(headers);
      print('$baseApi/user/order-detail/${id.replaceAll('#', '')}');

      http.StreamedResponse response = await request.send();
      final data = jsonDecode(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        orderDetailsModel = OrderDetailsModel.fromJson(data);
        notifyListeners();
        return;
      } else {
        print(data);
      }
    } on TimeoutException {
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (err) {
      showToast(err.toString(), cc.red);
      print(err);
    }
  }
}
