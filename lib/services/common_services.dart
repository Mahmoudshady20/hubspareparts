import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart' as pref;

class CommonServices with ChangeNotifier {
  num amount = 0;
  introSubmitted() async {
    final res = await pref.SharedPreferences.getInstance();
    res.setBool('intro', true);
  }

  checkIntro() async {
    final res = await pref.SharedPreferences.getInstance();
    return res.containsKey('intro');
  }

  setShippingAmount(value) {
    amount = value;
    notifyListeners();
  }
}
