import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/services/auth_service/save_sign_in_info_service.dart';
import 'package:safecart/services/profile_info_service.dart';

import '../../helpers/common_helper.dart';

class SocialSignInSignUpService with ChangeNotifier {
  bool loadingGoogleSignInSignUp = false;
  bool loadingFacebookSignInSignUp = false;

  setLoadingGoogleSignInSignUp({value}) {
    loadingGoogleSignInSignUp = value ?? !loadingGoogleSignInSignUp;
    notifyListeners();
  }

  setLoadingFacebookSignInSignUp({value}) {
    loadingFacebookSignInSignUp = value ?? !loadingFacebookSignInSignUp;
    notifyListeners();
  }

  Future facebookSignInSignUp(BuildContext context, toastText) async {
    setLoadingFacebookSignInSignUp(value: true);
    try {
      final response = await FacebookAuth.i.login(
        permissions: [
          'email',
          'public_profile',
        ],
      );
      if (response.status == LoginStatus.success) {
        final userData = await FacebookAuth.i.getUserData(
          fields: "name,email,id",
        );
        print(userData['email']);
        print(userData['id']);
        print(userData['name']);
        await socialLogin(
            context, '0', userData['email'], userData['name'], userData['id']);
        setLoadingFacebookSignInSignUp(value: false);
        return;
      }
      setLoadingFacebookSignInSignUp(value: false);
      showToast(asProvider.getString(toastText), cc.red);
    } catch (e) {
      setLoadingFacebookSignInSignUp(value: false);
      showToast(asProvider.getString(toastText), cc.red);
    }
  }

  Future googleSignInSignUp(BuildContext context, toastText) async {
    setLoadingGoogleSignInSignUp(value: true);
    try {
      await GoogleSignIn().signOut();
      print('trying to login');
      final response = await GoogleSignIn().signIn();
      print('login success');
      await socialLogin(
          context, '1', response!.email, response.displayName, response.id);
      setLoadingGoogleSignInSignUp(value: false);
      return;
    } catch (e) {
      print(e);
      setLoadingGoogleSignInSignUp(value: false);
      showToast(asProvider.getString(toastText), cc.red);
      loadingGoogleSignInSignUp = false;
      notifyListeners();
    }
  }

  Future socialLogin(BuildContext context, isGoogle, email, name, id) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseApi/social/login'));
      request.fields.addAll({
        'email': email,
        'isGoogle': isGoogle,
        'displayName': name,
        'id': id
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        print(data);
        Provider.of<SaveSignInInfoService>(context, listen: false)
            .saveToken(data["token"]);
        await Provider.of<ProfileInfoService>(context, listen: false)
            .fetchProfileInfo(context);
        Navigator.pop(context, true);
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
