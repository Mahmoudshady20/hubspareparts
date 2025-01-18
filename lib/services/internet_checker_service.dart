import 'package:flutter/material.dart';

import '../helpers/network_connectivity.dart';

class InternetCheckerService with ChangeNotifier {
  bool haveConnection = false;

  setHaveConnection(value) {
    if (value == haveConnection) {
      return;
    }
    haveConnection = value;
    notifyListeners();
  }

  checkConnection() async {
    NetworkConnectivity networkConnectivity = NetworkConnectivity.instance;
    bool currentConnection = await networkConnectivity.currentStatus();
    if (!currentConnection) {
      await Future.delayed(const Duration(seconds: 1));
    }
    setHaveConnection(currentConnection);
    debugPrint('Have internet connection is : $haveConnection');
  }
}
