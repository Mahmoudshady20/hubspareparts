import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:safecart/services/profile_info_service.dart';

import '../../helpers/common_helper.dart';
import 'save_sign_in_info_service.dart';

class SignOutService with ChangeNotifier {
  bool loadingSignOut = false;

  setLoadingSignOut(value) {
    loadingSignOut = value;
    notifyListeners();
  }

  signOut(BuildContext context) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }
    setLoadingSignOut(true);
    try {
      var headers = {
        'Authorization': 'Bearer $getToken',
      };
      var request = http.Request('POST', Uri.parse('$baseApi/user/logout'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final data = jsonDecode(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        print(data);

        showToast(asProvider.getString('Sign out successful'), cc.primaryColor);
        Provider.of<SaveSignInInfoService>(context, listen: false).clearToken();
        Provider.of<ProfileInfoService>(context, listen: false).logout();

        setLoadingSignOut(false);
      } else if (data['message'] != null) {
        showToast(asProvider.getString(data['message']), cc.red);
        setLoadingSignOut(false);
      } else {
        showToast(asProvider.getString('Sign in failed'), cc.red);
        print(data);
        setLoadingSignOut(false);
      }
    } on TimeoutException {
      showToast(asProvider.getString('Request timeout'), cc.red);
      setLoadingSignOut(false);
    } catch (err) {
      showToast(err.toString(), cc.red);
      print(err);
      setLoadingSignOut(false);
    }
  }
}
