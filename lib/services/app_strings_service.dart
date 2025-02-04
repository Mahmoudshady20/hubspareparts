import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:safecart/helpers/app_strings_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/common_helper.dart';

class AppStringService with ChangeNotifier {
  var tStrings;

  Future fetchTranslatedStrings(BuildContext context,
      {doNotLoad = false}) async {
    if (tStrings != null) {
      //if already loaded. no need to load again
      return;
    }
    var connection = await checkConnection(context);
    if (connection) {
      //internet connection is on
      // var data = jsonEncode({
      //   'strings': jsonEncode(appStrings),
      // });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (doNotLoad) {
        final strings = prefs.getString('translated_string');
        tStrings = jsonDecode(strings ?? 'null');
        return;
      }

      try {
        var request = http.MultipartRequest(
            'POST', Uri.parse('$baseApi/translate-string'));
        request.fields
            .addAll({'strings': jsonEncode(AppStringsHelper.appStrings)});

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          final data = jsonDecode(await response.stream.bytesToString());
          // print(data);
          tStrings = data["strings"];

          prefs.setString('translated_string', jsonEncode(tStrings));
          // print(data);
        } else {
          print('error fetching translations ');
          showToast(
              AppLocalizations.of(context)!.something_went_wrong, Colors.black);
          notifyListeners();
        }
      } on TimeoutException {
        showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
      } catch (err) {
        showToast(AppLocalizations.of(context)!.something_went_wrong, cc.red);
        print(err);
      }
    }
  }

  getString(String staticString) {
    if (tStrings == null) {
      return staticString;
    }
    if (tStrings.containsKey(staticString)) {
      return tStrings[staticString];
    } else {
      return staticString;
    }
  }
}
