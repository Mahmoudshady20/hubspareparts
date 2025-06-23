// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/services/auth_service/otp_service.dart';
import 'package:safecart/services/auth_service/save_sign_in_info_service.dart';
import 'package:safecart/services/profile_info_service.dart';

import '../../helpers/common_helper.dart';
import '../../views/enter_otp_view.dart';

class SignInService with ChangeNotifier {
  bool loadingSignIn = false;
  bool obscurePassword = true;
  bool rememberPassword = false;

  setLoadingSignIn(value) {
    loadingSignIn = value;
    notifyListeners();
  }

  setObscurePassword(value) {
    obscurePassword = value ?? !obscurePassword;
    notifyListeners();
  }

  setRememberPassword(value) {
    rememberPassword = value ?? !rememberPassword;
    notifyListeners();
  }

  signIn(BuildContext context, usernameEmail, password) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }
    setLoadingSignIn(true);
    if (rememberPassword) {
      Provider.of<SaveSignInInfoService>(context, listen: false)
          .saveSignInInfo(usernameEmail, password);
    } else {
      Provider.of<SaveSignInInfoService>(context, listen: false)
          .saveSignInInfo('', '');
    }
    Provider.of<SaveSignInInfoService>(context, listen: false)
        .getSaveinfos(context);
    final otpProvider = Provider.of<OtpService>(context, listen: false);
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseApi/login'));
      request.fields.addAll({
        'username': usernameEmail,
        'password': password,
      });

      http.StreamedResponse response = await request.send();

      final data = jsonDecode(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        print(data);
        final emailVerified = data['users']['email_verified'] == '1';
        if (!emailVerified) {
          await Provider.of<ProfileInfoService>(context, listen: false)
              .fetchProfileInfo(context, token: data['token']);
          final otpCode = await otpProvider.sendOTP(
              context,
              Provider.of<ProfileInfoService>(context, listen: false)
                  .profileInfo!
                  .userDetails
                  .email);
          if (otpCode != null) {
            await Navigator.of(context)
                .push(PageRouteBuilder(
                    pageBuilder: (context, animation, anotherAnimation) {
              return EnterOtpView(
                otpCode,
                fromRegister: true,
              );
            }, transitionsBuilder:
                        (context, animation, anotherAnimation, child) {
              animation =
                  CurvedAnimation(curve: Curves.decelerate, parent: animation);
              return Align(
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            }))
                .then((value) async {
              if (value == true) {
                await otpProvider.verifyEmail(
                  context,
                  data['users']['id'],
                );
                Provider.of<SaveSignInInfoService>(context, listen: false)
                    .saveToken(data['token']);
                await Provider.of<ProfileInfoService>(context, listen: false)
                    .fetchProfileInfo(context);
                Navigator.pop(context, true);
              }
            });
          }

          setLoadingSignIn(false);
          return;
        }
        Provider.of<SaveSignInInfoService>(context, listen: false)
            .saveToken(data['token']);
        await Provider.of<ProfileInfoService>(context, listen: false)
            .fetchProfileInfo(context);
        setLoadingSignIn(false);
        Navigator.pop(context, true);
      } else if (data['message'] != null) {
        showToast(asProvider.getString(data['message']), cc.red);
        setLoadingSignIn(false);
      } else {
        showToast(AppLocalizations.of(context)!.sign_in_failed, cc.red);
        print(data);
        setLoadingSignIn(false);
      }
    } on TimeoutException {
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
      setLoadingSignIn(false);
    } catch (err) {
      showToast(err.toString(), cc.red);
      print(err);
      setLoadingSignIn(false);
    }
  }
}
