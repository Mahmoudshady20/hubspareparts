import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences prefs;

  static String getLan() {
    return prefs.getString('language') ?? 'en';
  }

  static void setLan(String lan) {
    prefs.setString('language', lan);
  }
}
