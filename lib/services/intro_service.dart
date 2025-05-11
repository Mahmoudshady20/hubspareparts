import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helpers/common_helper.dart';

class IntroService with ChangeNotifier {
  List? introList;
  bool introLoading = false;
  int currentIndex = 0;
  setIndex(value) {
    currentIndex = value;
    notifyListeners();
  }

  setIntroLoading({value}) {
    introLoading = value ?? !introLoading;
    notifyListeners();
  }

  fetchIntro(BuildContext context) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }
    setIntroLoading(value: true);
    await Future.delayed(const Duration(seconds: 1));

    try {
      var request =
          http.MultipartRequest('GET', Uri.parse('$baseApi/mobile-intro'));

      http.StreamedResponse response = await request.send();

      final data = jsonDecode(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        introList = data['data'];

        setIntroLoading(value: false);
      } else {
        introList = [];
        setIntroLoading(value: false);
      }
    } on TimeoutException {
      introList = [];
      setIntroLoading(value: false);
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (err) {
      introList = [];
      setIntroLoading(value: false);
    }
  }
}
