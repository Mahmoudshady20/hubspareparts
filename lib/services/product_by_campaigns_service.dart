import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:safecart/models/home_campaign_products_model.dart';

import '../helpers/common_helper.dart';

class ProductByCampaignsService with ChangeNotifier {
  CampaignInfo? campaignInfo;
  bool campaignProductLoading = false;
  List<Product?>? campaignProducts;
  bool dataAlreadyLoaded = false;
  setCampaignProductLoading({value}) {
    campaignProductLoading = value ?? !campaignProductLoading;
    notifyListeners();
  }

  clearProductByCampaignData() {
    campaignInfo = null;
    campaignProductLoading = false;
    campaignProducts = null;
    dataAlreadyLoaded = false;
    notifyListeners();
  }

  fetchCampaignProducts(BuildContext context, id) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      campaignProducts ??= [];
      notifyListeners();

      return;
    }
    debugPrint("$baseApi/campaign/product/$id".toString());
    campaignProducts = null;
    dataAlreadyLoaded = true;
    setCampaignProductLoading(value: true);

    try {
      var request = http.MultipartRequest(
          'GET', Uri.parse('$baseApi/campaign/product/$id'));

      http.StreamedResponse response = await request.send();
      var resBody = await response.stream.bytesToString();
      debugPrint(resBody.toString());
      if (response.statusCode == 200) {
        final data = jsonDecode(resBody);
        final modelData = HomeCampaignProductsModel.fromJson(data);
        campaignInfo = modelData.campaignInfo;
        campaignProducts = modelData.products;
        debugPrint(data.toString());
        //
      } else {}
    } on TimeoutException {
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      rethrow;
    } finally {
      campaignProducts ??= [];
      setCampaignProductLoading(value: false);
    }
  }
}
