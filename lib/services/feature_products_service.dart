import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safecart/models/feature_products_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../helpers/common_helper.dart';

class FeatureProductsService with ChangeNotifier {
  List<Datum?>? featureProductsList;
  bool featureProductsLoading = false;

  setFeatureProductsLoading({value}) {
    featureProductsLoading = value ?? !featureProductsLoading;
    notifyListeners();
  }

  fetchFeatureProducts(BuildContext context, {refreshing = false}) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      featureProductsList = [];
      notifyListeners();
      print('NO connection');
      return;
    }
    if (!refreshing) {
      setFeatureProductsLoading(value: true);
    }

    try {
      var request =
          http.MultipartRequest('GET', Uri.parse('$baseApi/featured/product'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        featureProductsList = FeatureProductsModel.fromJson(data).data;

        setFeatureProductsLoading(value: false);
      } else {
        featureProductsList = [];
        setFeatureProductsLoading(value: false);
        print(response.reasonPhrase);
      }
    } on TimeoutException {
      featureProductsList = [];
      setFeatureProductsLoading(value: false);
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      featureProductsList = [];
      setFeatureProductsLoading(value: false);
      print(err);
    }
  }
}
