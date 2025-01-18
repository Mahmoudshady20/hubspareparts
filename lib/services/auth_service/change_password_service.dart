// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../helpers/common_helper.dart';

class ChangePasswordService with ChangeNotifier {
  bool loadingChangePassword = false;
  setLoadingChangePassword(value) {
    loadingChangePassword = value;
    notifyListeners();
  }

  changePassword(BuildContext context, currentPassword, newPassword) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }
    try {
      setLoadingChangePassword(true);
      var headers = {'Authorization': 'Bearer $getToken'};
      var request = http.MultipartRequest(
          'POST', Uri.parse('$baseApi/user/change-password'));
      request.fields.addAll(
          {'current_password': currentPassword, 'new_password': newPassword});

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      final data = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        showToast(
            asProvider.getString('Password change succeeded'), cc.primaryColor);
        Navigator.pop(context);

        print(data);
      } else {
        showToast(
            jsonDecode(data)['message'] ??
                asProvider.getString('Password change failed'),
            cc.red);

        print(response.reasonPhrase);
      }
    } on TimeoutException {
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (err) {
      showToast(err.toString(), cc.red);
      print(err);
    } finally {
      setLoadingChangePassword(false);
    }
  }
}
