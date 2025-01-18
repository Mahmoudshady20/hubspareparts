import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

import '../helpers/common_helper.dart';

class TermsAndCondition with ChangeNotifier {
  bool rtl = false;
  String html = '';

  Future getTermsAndCondi(uri) async {
    final url = Uri.parse(uri);

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        html = jsonDecode(response.body)["content"];
        if (html.isEmpty) {
          return '';
        }
        notifyListeners();
        return;
      }
      throw '';
    } on TimeoutException {
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (err) {
      showToast(err.toString(), cc.red);
      print(err);
    }
  }
}
