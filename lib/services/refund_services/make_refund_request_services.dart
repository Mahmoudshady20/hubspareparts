import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safecart/helpers/common_helper.dart';
import 'package:safecart/models/response_refund_request.dart';

import '../../models/get_refund_reasons.dart';
import '../../models/make_refund_request_model.dart';
import '../../models/preferred_options_model.dart';

 // متنساش عملية الكلير علشان لما يحصل استرجاع بعد كدا

class MakeRefundRequestService extends ChangeNotifier {
  List<MakeRefundRequestModel> refunds = [];
  GetRefundReasons? refundReasons;
  PreferredOptionsModel? preferredOptionsModel;
  String? selectedRefundReason;
  String? selectedPreferredOption;
  List<String?> selectedRefundReasons = [];

  addRefund(MakeRefundRequestModel refund) {
    refunds.add(refund);
    notifyListeners();
  }
  Future<GetRefundReasons?> getRefundReasons() async{
   try {
      http.Response response = await http.get(Uri.parse('https://hubspareparts.com/api/v1/refund-requests/refund-reasons'),headers: {
        'Authorization': 'Bearer $getToken',
      });
      refundReasons = GetRefundReasons.fromJson(jsonDecode(response.body));
     return refundReasons;
   } on Exception catch (e) {
     showToast(e.toString(), cc.red);
   }
    return null;
  }
  Future<PreferredOptionsModel?> getRefundPreferredOptions() async{
   try {
      http.Response response = await http.get(Uri.parse('https://hubspareparts.com/api/v1/refund-requests/refund-preferred-options'),headers: {
        'Authorization': 'Bearer $getToken',
      });
      preferredOptionsModel = PreferredOptionsModel.fromJson(jsonDecode(response.body));
     return preferredOptionsModel;
   } on Exception catch (e) {
     showToast(e.toString(), cc.red);
   }
    return null;
  }

  void updateSelectedRefundReason(String reason) {
    selectedRefundReason = reason;
    notifyListeners();
  }
  void updateSelectedPreferredOption(String preferredOption) {
    selectedPreferredOption = preferredOption;
    notifyListeners();
  }
  void editSelectedRefundReason(int index, String reason) {
    selectedRefundReasons[index] = reason;
    notifyListeners();
  }
  void removeById(String idToRemove) {
    refunds.removeWhere((makeRefundRequestModel) => makeRefundRequestModel.requestItemId == idToRemove);
    notifyListeners();
  }
  bool containsById(String idToCheck) {
    return refunds.any((refund) => refund.requestItemId == idToCheck);
  }
  void updateRefund(MakeRefundRequestModel updatedRefund) {
    final index = refunds.indexWhere((element) => element.requestItemId == updatedRefund.requestItemId);
    if (index != -1) {
      refunds[index] = updatedRefund;
      notifyListeners();
    }
  }
  Future<void> makeRefundRequestHttp(String orderId,MakeRefundRequestModel makeRefundRequestModel) async {
    print('before uri');
    final uri = Uri.parse('$baseApi/refund-requests/make-request/$orderId');
    print('after uir');

    // افتح ملف الصورة - غيّر المسار الصحيح حسب جهازك
    final imageFile = File('/path/to/Pyramids.jpg'); // ✳️ غيّر المسار هنا

    final request = http.MultipartRequest('POST', uri);

    // إضافة الحقول
    request.fields['product_name[${makeRefundRequestModel.requestItemId.toString()}]'] = makeRefundRequestModel.productName.toString();
    request.fields['request_item_id[]'] = makeRefundRequestModel.requestItemId.toString();
    request.fields['refund_reason[${makeRefundRequestModel.requestItemId.toString()}]'] = makeRefundRequestModel.refundReason.toString();
    request.fields['refund_quantity[${makeRefundRequestModel.requestItemId.toString()}]'] = makeRefundRequestModel.refundQuantity.toString();
    request.fields['additional_information'] = makeRefundRequestModel.additionalInformation.toString();
    request.fields['preferred_option'] = makeRefundRequestModel.preferredOptions.toString();
    request.fields['fields[Manual_Payment]'] = '123';

    // إضافة الملف
    // request.files.add(
    //   await http.MultipartFile.fromPath(
    //     'files[]',
    //     imageFile.path,
    //     filename: basename(imageFile.path),
    //   ),
    // );

    // لو فيه توكن او هيدر:
    // request.headers['Authorization'] = 'Bearer YOUR_TOKEN';
    print('before try request sent');
    try {
      final response = await request.send();



      // قراءة الجسم (body) بعد الإرسال
      final responseBody = await response.stream.bytesToString();
      print('after try request sent');
      return;

    } catch (e) {
      throw Exception('Failed to make refund request: $e');
    }
  }

}