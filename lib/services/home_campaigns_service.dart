import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helpers/common_helper.dart';
import '../models/home_campaign_model.dart';

class HomeCampaignsService with ChangeNotifier {
  List<Datum?>? campaigns;
  bool campaignLoading = false;
  Datum? selectedCampaign;
  bool campaignProductLoading = false;
  List? campaignProducts;

  setCampaignLoading({value}) {
    campaignLoading = value ?? !campaignLoading;
    notifyListeners();
  }

  setSelectedCampaign(value) {
    selectedCampaign = selectedCampaign;
    // fetchHomeCampaignProducts(selectedCampaign!.id);
    notifyListeners();
  }

  setCampaignProductLoading({value}) {
    campaignProductLoading = value ?? !campaignProductLoading;
    notifyListeners();
  }

  fetchHomeCampaigns(BuildContext context, {refreshing = false}) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      campaigns = [];
      notifyListeners();
      return;
    }
    if (!refreshing) {
      setCampaignLoading(value: true);
    }
    try {
      var request =
          http.MultipartRequest('GET', Uri.parse('$baseApi/campaign'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        campaigns = HomeCampaignsModel.fromJson(data).data;

        setCampaignLoading(value: false);
        if (campaigns!.first != null) {
          setSelectedCampaign(campaigns!.first);
        }
        // notifyListeners();
      } else {
        campaigns = [];
        setCampaignLoading(value: false);
      }
    } on TimeoutException {
      campaigns = [];
      setCampaignLoading(value: false);
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (err) {
      campaigns = [];
      setCampaignLoading(value: false);
    }
  }

  fetchHomeCampaignProducts(BuildContext context, id) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }
    setCampaignProductLoading(value: true);
    try {
      var request = http.MultipartRequest(
          'GET', Uri.parse('$baseApi/campaign/product/$id'));

      // http.StreamedResponse response = await request.send();

      // if (response.statusCode == 200) {
      //   final data = jsonDecode(await response.stream.bytesToString());
      //   campaignInfo = HomeCampaignProductsModel.fromJson(data).campaignInfo;
      //   homeCampaignProductsList =
      //       HomeCampaignProductsModel.fromJson(data).products;

      //   setCampaignProductLoading(value: false);
      // } else {
      //   homeCampaignProductsList = [];
      //   setCampaignProductLoading(value: false);
      //   print(response.reasonPhrase);
      // }
    } on TimeoutException {
      campaigns = [];
      setCampaignProductLoading(value: false);
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (err) {
      campaigns = [];
      setCampaignProductLoading(value: false);
    }
  }
}
