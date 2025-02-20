import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/services/auth_service/reset_password_service.dart';

import '../../helpers/common_helper.dart';

class OtpService with ChangeNotifier {
  var otpCode;
  bool loadingSendOTP = false;

  setLoadingSendOTP(value) {
    loadingSendOTP = value;
    notifyListeners();
  }

  Future sendOTP(BuildContext context, email) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }
    setLoadingSendOTP(true);
    print('sending otpCode');
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseApi/send-otp-in-mail'));
      request.fields.addAll({
        'email': email ??
            Provider.of<ResetPasswordService>(context, listen: false).email,
      });

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      final data = jsonDecode(await response.stream.bytesToString());
      print(data);
      if (response.statusCode == 200) {
        print(data['otp']);
        otpCode = data['otp'];
        return data['otp'];
      } else {
        showToast(AppLocalizations.of(context)!.oTP_send_error, cc.red);
        print(response.reasonPhrase);
      }
    } on TimeoutException {
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      showToast(err.toString(), cc.red);
    } finally {
      setLoadingSendOTP(false);
    }
  }

  Future verifyEmail(BuildContext context, userId) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseApi/otp-success'));
      request.fields
          .addAll({'user_id': userId.toString(), 'email_verified': '1'});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
        showToast(response.reasonPhrase.toString().capitalize(), cc.red);
      }
    } on TimeoutException {
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      print(err);
    }
  }
}
