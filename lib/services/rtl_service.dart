// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/common_helper.dart';
import 'app_strings_service.dart';

class RTLService with ChangeNotifier {
  bool langRtl = false;
  String? name;
  String? slug;
  String? taxType;
  String? taxSystem;

  String currency = '\$';
  String currencyCode = 'USD';
  bool curRtl = false;

  bool alreadyLoaded = false;
  bool alreadyRtlLoaded = false;
  bool noConnection = false;

  setNoConnection(value) {
    if (value == noConnection) {
      return;
    }
    noConnection = value;
    notifyListeners();
  }

  fetchCurrency(BuildContext context) async {
    var connection = !(await checkConnection(context));
    setNoConnection(connection);
    if (alreadyLoaded == false) {
      try {
        Timer scheduleTimeout = Timer(const Duration(seconds: 10), () {
          showToast(AppLocalizations.of(context)!.server_connection_slow,
              cc.blackColor);
        });

        var response =
            await http.get(Uri.parse('$baseApi/site_currency_symbol'));
        scheduleTimeout.cancel();
        if (response.statusCode == 200) {
          print(response.body);
          currency = jsonDecode(response.body)['symbol'];
          curRtl = jsonDecode(response.body)['currencyPosition'] == 'right';
          currencyCode = jsonDecode(response.body)['currency_code'];
          taxType = jsonDecode(response.body)['tax_type'];
          taxSystem = jsonDecode(response.body)['tax_system'];
          print(currency);
          alreadyLoaded == true;
          notifyListeners();
        } else {
          print('failed loading currency');
          print(response.body);
        }
      } on TimeoutException {
        showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
      } catch (err) {
        print(err);
      }
    }
  }

  fetchLang(BuildContext context) async {
    if (alreadyLoaded == false) {
      try {
        var response = await http.get(Uri.parse('$baseApi/language'));
        if (response.statusCode == 200) {
          print(response.body);
          name = jsonDecode(response.body)['language']['name'];
          slug = jsonDecode(response.body)['language']['slug'];
          langRtl = jsonDecode(response.body)['language']['direction'] == 'rtl';
          print(currency);
          final srf = await SharedPreferences.getInstance();
          if (!srf.containsKey('langId')) {
            print('Translating string for the first time');
            srf.setString('langId', slug!);
            await Provider.of<AppStringService>(context, listen: false)
                .fetchTranslatedStrings(context);
          } else if (srf.getString('langId') != slug) {
            print('Updating translated Strings');
            srf.setString('langId', slug!);
            await Provider.of<AppStringService>(context, listen: false)
                .fetchTranslatedStrings(context);
          } else {
            print('Loading translations from local');
            await Provider.of<AppStringService>(context, listen: false)
                .fetchTranslatedStrings(context, doNotLoad: true);
          }
          initiateAppStringProvider(context);
          alreadyLoaded == true;
          notifyListeners();
        } else {
          initiateAppStringProvider(context);
          print('failed loading language');
          print(response.body);
        }
      } on TimeoutException {
        initiateAppStringProvider(context);
        showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
      } catch (err) {
        initiateAppStringProvider(context);
        print(err);
      }
    }
  }
}
