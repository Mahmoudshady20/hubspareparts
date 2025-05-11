import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helpers/common_helper.dart';
import '../models/home_campaign_products_model.dart';

class HomeCampaignProductsService with ChangeNotifier {
  List<Product?>? homeCampaignProductsList;
  CampaignInfo? campaignInfo;
  bool homeCampaignProductsLoading = false;

  setHomeCampaignProductsLoading({value}) {
    homeCampaignProductsLoading = value ?? !homeCampaignProductsLoading;
    notifyListeners();
  }

  fetchHomeCampaignProducts(BuildContext context, {refreshing = false}) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      homeCampaignProductsList ??= [];
      notifyListeners();
      return;
    }
    if (!refreshing) {
      setHomeCampaignProductsLoading(value: true);
    }
    try {
      var request =
          http.MultipartRequest('GET', Uri.parse('$baseApi/campaign/product'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        campaignInfo = HomeCampaignProductsModel.fromJson(data).campaignInfo;
        homeCampaignProductsList =
            HomeCampaignProductsModel.fromJson(data).products;

        setHomeCampaignProductsLoading(value: false);
      } else {
        homeCampaignProductsList = [];
        setHomeCampaignProductsLoading(value: false);
      }
    } on TimeoutException {
      homeCampaignProductsList = [];
      setHomeCampaignProductsLoading(value: false);
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (err) {
      homeCampaignProductsList = [];
      setHomeCampaignProductsLoading(value: false);
    }
  }
}
