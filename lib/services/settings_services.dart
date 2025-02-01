import 'package:flutter/material.dart';
import 'package:safecart/helpers/settings_helper.dart';

class SettingsProvider extends ChangeNotifier {
  Locale myLocal = const Locale('en');
  void init() {
    myLocal =
        SharedPrefs.getLan() == 'ar' ? const Locale('ar') : const Locale('en');
    notifyListeners();
  }

  bool isEnglish() => myLocal == const Locale('en');

  void enableArabic() {
    myLocal = const Locale('ar');
    SharedPrefs.setLan('ar');
    notifyListeners();
  }

  void enableEnglish() {
    myLocal = const Locale('en');
    SharedPrefs.setLan('en');
    notifyListeners();
  }

  void resetSettings() {
    myLocal = const Locale('ar');
    SharedPrefs.setLan('ar');
    notifyListeners();
  }
}
