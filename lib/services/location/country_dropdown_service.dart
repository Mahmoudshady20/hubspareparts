import 'package:flutter/material.dart';
import 'package:safecart/helpers/common_helper.dart';

import '../../data/network/network_api_services.dart';
import '../../models/country_model.dart';

class CountryDropdownService with ChangeNotifier {
  bool countryLoading = false;
  String countrySearchText = '';

  List<Country?> countryDropdownList = [];

  bool nextPageLoading = false;

  String? nextPage;

  bool nexLoadingFailed = false;

  setCountrySearchValue(value) {
    if (value == countrySearchText) {
      return;
    }
    countrySearchText = value;
    // notifyListeners();
  }

  resetList() {
    if (countrySearchText.isEmpty && countryDropdownList.isNotEmpty) {
      return;
    }
    countrySearchText = '';
    countryDropdownList = [];
    getCountries();
  }

  void getCountries() async {
    countryLoading = true;
    nextPage = null;
    notifyListeners();
    final url = "$baseApi/country?name=$countrySearchText";
    final responseData =
        await NetworkApiServices().getApi(url, asProvider.getString("Country"));

    if (responseData != null) {
      final tempData = CountryModel.fromJson(responseData);
      countryDropdownList = tempData.countries ?? [];
      nextPage = tempData.nextPage;
      notifyListeners();
    } else {}

    countryLoading = false;
    notifyListeners();
  }

  fetchNextPage() async {
    if (nextPageLoading || nextPage == null) return;
    nextPageLoading = true;
    final responseData =
        await NetworkApiServices().getApi(nextPage!, "Country fetching");

    if (responseData != null) {
      // chatList = responseData;
      final tempData = CountryModel.fromJson(responseData);
      tempData.countries?.forEach((element) {
        countryDropdownList.add(element);
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
