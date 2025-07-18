import 'dart:async';

import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:http/http.dart' as http;

import '../../helpers/common_helper.dart';

class ResetPasswordService with ChangeNotifier {
  String? email;
  bool loadingResetPassword = false;
  bool obscurePasswordOne = true;
  bool obscurePasswordTwo = true;

  setLoadingResetPassword(value) {
    loadingResetPassword = value;
    notifyListeners();
  }

  setObscurePasswordOne(value) {
    obscurePasswordOne = value ?? !obscurePasswordOne;
    notifyListeners();
  }

  setObscurePasswordTwo(value) {
    obscurePasswordTwo = value ?? !obscurePasswordTwo;
    notifyListeners();
  }

  setEmail(value) {
    email = value;
    notifyListeners();
  }

  resetPassword(BuildContext context, password) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }
    setLoadingResetPassword(true);
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseApi/reset-password'));
      request.fields.addAll({
        'password': password,
        'email': email.toString(),
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        showToast(
            AppLocalizations.of(context)!.password_reset_successful, cc.green);
        Navigator.pop(context);
      } else {
        print(response.reasonPhrase);
        showToast(AppLocalizations.of(context)!.password_reset_failed, cc.red);
      }
    } on TimeoutException {
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      showToast(err.toString(), cc.red);
      print(err);
    } finally {
      setLoadingResetPassword(false);
    }
  }
}
