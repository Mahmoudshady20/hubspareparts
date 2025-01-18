import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../widgets/common/custom_common_button.dart';
import 'common_helper.dart';
import 'empty_space_helper.dart';

class NetworkConnectivity {
  StreamSubscription<dynamic>? streamSubscription;
  NetworkConnectivity._();
  static final _instance = NetworkConnectivity._();
  static NetworkConnectivity get instance => _instance;
  final _networkConnectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;
  void initialise() async {
    var result = await _networkConnectivity.checkConnectivity();
    _checkStatus(result);
    _networkConnectivity.onConnectivityChanged.listen((result) {
      print(result);
      _checkStatus(result);
    });
  }

  Future<bool> currentStatus() async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    return isOnline;
  }

  void _checkStatus(List<ConnectivityResult> result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result.firstOrNull: isOnline});
  }

  void disposeStream() => _controller.close();

  listenToConnectionChange(BuildContext context) {
    Map source = {ConnectivityResult.none: false};
    String string = '';
    initialise();
    bool isOffline = false;
    streamSubscription ??= myStream.listen((source) {
      source = source;
      print('source $source');
      // 1.
      switch (source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          string =
              source.values.toList()[0] ? 'Mobile: Online' : 'Mobile: Offline';
          break;
        case ConnectivityResult.wifi:
          string = source.values.toList()[0] ? 'WiFi: Online' : 'WiFi: Offline';
          break;
        case ConnectivityResult.none:
        default:
          string = 'Offline';
      }
      if (string.contains('Online') && isOffline) {
        isOffline = false;
        Navigator.pop(context);
      }
      if (string.contains('Offline') && !isOffline) {
        isOffline = true;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Container(
              height: 400,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), color: cc.pureWhite),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LottieBuilder.asset(
                      'assets/animations/no_internet.json',
                      height: 240,
                    ),
                    Text(
                      asProvider.getString('Oops!'),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    EmptySpaceHelper.emptyHight(8),
                    Text(
                      asProvider.getString('No wifi or cellular data found'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    EmptySpaceHelper.emptyHight(16),
                    CustomCommonButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        btText: 'Okay',
                        isLoading: false)
                  ]),
            ),
          ),
        ).then((value) => isOffline = false);
      }
    });
  }
}
