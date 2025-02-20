import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/services/profile_info_service.dart';

import '../../helpers/common_helper.dart';
import 'save_sign_in_info_service.dart';

class AccountDeleteService with ChangeNotifier {
  bool loadingAccountDelete = false;

  setLoadingAccountDelete(value) {
    loadingAccountDelete = value;
    notifyListeners();
  }

  accountDelete(BuildContext context) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }
    setLoadingAccountDelete(true);
    try {
      if (baseApi.toString().toLowerCase().contains("safecart")) {
        await Future.delayed(const Duration(seconds: 2));
        showToast(
            asProvider
                .getString('This feature is not available for the demo app'),
            cc.red);
        setLoadingAccountDelete(false);
        return;
      }
      var headers = {
        'Authorization': 'Bearer $getToken',
      };
      var request =
          http.Request('GET', Uri.parse('$baseApi/user/delete-account'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final data = jsonDecode(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        print(data);
        showToast(
            AppLocalizations.of(context)!.account_delete_successful, cc.primaryColor);
        Provider.of<SaveSignInInfoService>(context, listen: false).clearToken();
        Provider.of<ProfileInfoService>(context, listen: false).logout();
      } else if (data['message'] != null) {
        showToast(asProvider.getString(data['message']), cc.red);
      } else {
        showToast(response.reasonPhrase.toString().capitalize(), cc.red);
        print(data);
      }
    } on TimeoutException {
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      showToast(err.toString(), cc.red);
      print(err);
    } finally {
      setLoadingAccountDelete(false);
    }
  }
}
