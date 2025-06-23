import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../helpers/common_helper.dart';
import '../../models/refund_details_model.dart';

class RefundDetailsService with ChangeNotifier {
  RefundDetailsModel? refundDetailsModel;

  void clearRefundDetails() {
    refundDetailsModel = null;
    notifyListeners();
  }

  Future<void> fetchRefundDetails(BuildContext context, int refundId) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) return;

    try {
      final url = Uri.parse(
          '$baseApi/refund-requests/show/$refundId');
      print('🟢 Fetching refund details with ID: $refundId (URL: $url)');

      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $getToken',
      }).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);
      print('🔵 refund details response: $data');

      if (response.statusCode == 200) {
        refundDetailsModel = RefundDetailsModel.fromJson(data);
        notifyListeners();
      } else {
        showToast(data['message'] ?? 'Error', cc.red);
      }
    } on TimeoutException {
      showToast('Request timeout', cc.red);
    } catch (err) {
      showToast(err.toString(), cc.red);
    }
  }
}
