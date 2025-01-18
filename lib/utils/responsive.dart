import 'dart:io';

import 'package:flutter/material.dart';

import '../helpers/common_helper.dart';

late bool isIos;
late bool isAndroid;

late double screenWidth;
late double screenHeight;

getScreenSize(BuildContext context) {
  screenWidth = MediaQuery.of(context).size.width;
  screenHeight = MediaQuery.of(context).size.height;
}

screenSizeAndPlatform(BuildContext context) {
  getScreenSize(context);
  initiateAppStringProvider(context);
  checkPlatform();
}
//responsive screen codes ========>

var fourinchScreenHeight = 610;
var fourinchScreenWidth = 385;

checkPlatform() {
  isAndroid = Platform.isAndroid;
  isIos = Platform.isIOS;
}
