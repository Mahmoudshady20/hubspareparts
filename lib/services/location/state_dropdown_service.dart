import 'package:flutter/material.dart';
import 'package:safecart/helpers/common_helper.dart';

import '../../data/network/network_api_services.dart';
import '../../models/state_model.dart';

class StatesDropdownService with ChangeNotifier {
  bool statesLoading = false;
  String statesSearchText = '';
  var countryId;

  List<States?> statesList = [];

  bool nextPageLoading = false;

  String? nextPage;

  bool nexLoadingFailed = false;

  setStatesSearchValue(value) {
    if (value == statesSearchText) {
      return;
    }
    statesSearchText = value;
    // notifyListeners();
  }

  resetList(cId) {
    if (statesSearchText.isEmpty && statesList.isNotEmpty && cId == countryId) {
      return;
    }
    statesSearchText = '';
    countryId = cId;
    statesList = [];
    getStates();
  }

  void getStates() async {
    statesLoading = true;
    nextPage = null;
    notifyListeners();
    final url = "$baseApi/state/$countryId?name=$statesSearchText";
    final responseData =
        await NetworkApiServices().getApi(url, asProvider.getString("State"));

    if (responseData != null) {
      final tempData = StateModel.fromJson(responseData);
      statesList = tempData.state ?? [];
      nextPage = tempData.nextPage;
      notifyListeners();
    } else {}

    statesLoading = false;
    notifyListeners();
  }

  fetchNextPage() async {
    if (nextPageLoading || nextPage == null) return;
    nextPageLoading = true;
    debugPrint("fetching dashboard info".toString());
    final responseData =
        await NetworkApiServices().getApi(nextPage!, "Country fetching");

    if (responseData != null) {
      // chatList = responseData;
      final tempData = StateModel.fromJson(responseData);
      tempData.state?.forEach((element) {
        statesList.add(element);
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
