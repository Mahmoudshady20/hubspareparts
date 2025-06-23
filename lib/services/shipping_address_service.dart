import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/helpers/common_helper.dart';
import 'dart:convert';
import 'package:safecart/l10n/generated/app_localizations.dart';

import 'package:http/http.dart' as http;
import 'package:safecart/services/profile_info_service.dart';

import '../models/shipping_addresses_model.dart';

class SDFjlasjklfdjalfdj with ChangeNotifier {
  List<Datum> shippingAddresseList = [];
  Datum? selectedAddress;
  bool isLoading = false;
  bool changePassLoading = false;
  String? name;
  String? email;
  String? phone;
  String? countryCode;
  String countryId = '1';
  String stateID = '143';
  String? zipCode;
  String? address;
  String? city;
  bool alertBoxLoading = false;
  bool noData = false;
  bool firstLoad = true;
  bool currentAddress = false;

  setName(value) {
    name = value;
    notifyListeners();
  }

  clearSelectedAddress() {
    selectedAddress = null;
    noData = false;
    isLoading = false;
    firstLoad = true;
    currentAddress = false;
    notifyListeners();
  }

  clearAll() {
    noData = false;
    isLoading = false;
    name = null;
    email = null;
    phone = null;
    countryCode = null;
    zipCode = null;
    countryId = '1';
    stateID = '1';
    address = null;
    city = null;
    firstLoad = true;
    notifyListeners();
  }

  setCity(value) {
    city = value;
    notifyListeners();
  }

  setAddress(value) {
    address = value;
    notifyListeners();
  }

  setPhone(value) {
    phone = value;
    notifyListeners();
  }

  setEmail(value) {
    email = value;
    notifyListeners();
  }

  setZipCode(value) {
    zipCode = value;
    notifyListeners();
  }

  setCountryId(value) {
    countryId = value;
    notifyListeners();
  }

  setStateId(value) {
    stateID = value;
    notifyListeners();
  }

  setSelectedAddress(value, BuildContext context) async {
    if (value == null && (selectedAddress != null || firstLoad)) {
      selectedAddress = value;
      firstLoad = false;
      currentAddress = true;
      notifyListeners();
      return;
    }
    if (value == null && selectedAddress == null) {
      return;
    }
    currentAddress = false;
    selectedAddress = value;
    notifyListeners();
  }

  setDefaultCountryState(BuildContext context) {}

  setCountryCode(value) {
    countryCode = value;
    notifyListeners();
  }

  setIsLoading(value) {
    isLoading = value;
    notifyListeners();
  }

  setAlertBoxLoading(value) {
    alertBoxLoading = value;
    notifyListeners();
  }

  setNoData(value) {
    noData = value;
    selectedAddress = null;
    isLoading = false;
    notifyListeners();
  }

  Future<dynamic> fetchShippingAddress(BuildContext context,
      {bool loadShippingZone = false}) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }

    try {
      var headers = {'Authorization': 'Bearer $getToken'};
      var request =
          http.Request('GET', Uri.parse('$baseApi/user/all-shipping-address'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        final shippingAddresseList =
            ShippingAddressListModel.fromJson(jsonDecode(data)).data;
        notifyListeners();
        return;
      } else {
        showToast(response.reasonPhrase.toString().capitalize(), cc.red);
      }
    } on TimeoutException {
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      showToast(err.toString(), cc.red);
    }
  }

  Future<dynamic> addShippingAddress() async {
    final url = Uri.parse('$baseApi/user/store-shipping-address');
    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Authorization": "Bearer $getToken",
    };

    try {
      final response = await http.post(url, headers: header, body: {
        'name': name,
        'email': email,
        'phone': phone,
        'country': countryId,
        'state': stateID,
        'city': city,
        'zip_code': zipCode,
        'address': address,
      });
      debugPrint(response.body.toString());
      if (response.statusCode == 200) {
        notifyListeners();
        return;
      }
      if (response.statusCode == 422) {
        final data = json.decode(response.body);
        return data['message'];
      }

      return asProvider.getString('Something went wrong');
    } catch (error) {

      rethrow;
    }
  }

  Future<dynamic> deleteSingleAddress(id) async {
    final url = Uri.parse('$baseApi/user/shipping-address/delete/$id');
    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Authorization": "Bearer $getToken",
    };
    try {
      final response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        shippingAddresseList.removeWhere((element) => element.id == id);
        if (shippingAddresseList.isEmpty) {
          noData = true;
          selectedAddress = null;
        }
        notifyListeners();
        return;
      }
      if (response.statusCode == 422) {
        final data = json.decode(response.body);
        return data['message'];
      }

      return asProvider.getString('Something went wrong');
    } catch (error) {
      showToast(error.toString(), cc.blackColor);

      rethrow;
    }
  }
}
