import 'package:flutter/material.dart';
import 'package:safecart/helpers/common_helper.dart';

import '../../data/network/network_api_services.dart';
import '../../models/city_dropdown_model.dart';

class CityDropdownService with ChangeNotifier {
  bool cityLoading = false;
  String citySearchText = '';
  var stateId;

  List<City> cityList = [];

  bool nextPageLoading = false;

  String? nextPage;

  bool nexLoadingFailed = false;

  setCitySearchValue(value) {
    if (value == citySearchText) {
      return;
    }
    citySearchText = value;
    // notifyListeners();
  }

  resetList(sId) {
    if (citySearchText.isEmpty && cityList.isNotEmpty && sId == stateId) {
      return;
    }
    citySearchText = '';
    cityList = [];
    stateId = sId;
    getCity();
  }

  void getCity() async {
    cityLoading = true;
    nextPage = null;
    notifyListeners();
    final url =
        "$baseApi/cities/$stateId${citySearchText.isEmpty ? "" : '?name=$citySearchText'}";
    final responseData =
        await NetworkApiServices().getApi(url, asProvider.getString("City"));
    if (responseData != null) {
      final tempData = CityDropdownModel.fromJson(responseData);
      cityList = tempData.cities ?? [];
      nextPage = tempData.nextPage;
      notifyListeners();
    } else {}

    cityLoading = false;
    notifyListeners();
  }

  fetchNextPage() async {
    if (nextPageLoading || nextPage == null) return;
    nextPageLoading = true;
    debugPrint("fetching dashboard info".toString());
    final responseData =
        await NetworkApiServices().getApi(nextPage!, "Country fetching");

    if (responseData != null) {
      final tempData = CityDropdownModel.fromJson(responseData);
      tempData.cities?.forEach((element) {
        cityList.add(element);
      });
      nextPage = tempData.nextPage;
      notifyListeners();
    } else {
      nexLoadingFailed = true;
      Future.delayed(const Duration(seconds: 1)).then((value) {
        nexLoadingFailed = false;
        notifyListeners();
      });
    }
    nextPageLoading = false;
    notifyListeners();
  }
}
