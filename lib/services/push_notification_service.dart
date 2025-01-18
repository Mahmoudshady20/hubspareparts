import 'package:flutter/material.dart';

class PushNotificationService with ChangeNotifier {
  String? userToken;

  setUserToken(value) {
    userToken = value;
  }
}
