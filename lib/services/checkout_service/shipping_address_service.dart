// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/services/checkout_service/calculate_tax_service.dart';
import 'package:safecart/services/profile_info_service.dart';

import '../../../helpers/common_helper.dart';
import '../../../models/city_dropdown_model.dart';
import '../../../models/country_model.dart' as cm;
import '../../../models/shipping_addresses_model.dart';
import '../../../models/state_model.dart';

class ShippingAddressService with ChangeNotifier {
  List<Datum>? shippingAddressList;
  String? title = '';
  String? email = '';
  String? phone = '';
  String? country;
  String? streetAddress = '';
  String? townCity = '';
  String? zipcode = '';
  String? orderNote = '';
  bool currentAddress = true;
  String? state;
  Datum? selectedShippingAddress;
  bool loadingNewAddress = false;
  bool loadingDeleteAddress = false;
  setTitle(value) {
    title = value;
    notifyListeners();
  }

  cm.Country? selectedCountry;
  States? selectedState;
  City? selectedCity;

  setEmail(value) {
    email = value;
    notifyListeners();
  }

  setPhone(value) {
    phone = value;
    notifyListeners();
  }

  setCountry(value) {
    selectedCountry = value;
    notifyListeners();
  }

  setStreetAddress(value) {
    streetAddress = value;
    notifyListeners();
  }

  setZipCode(value) {
    zipcode = value;
    notifyListeners();
  }

  setOrderNote(value) {
    orderNote = value;
    notifyListeners();
  }

  setTownCity(value) {
    selectedCity = value;
    notifyListeners();
  }

  setState(value) {
    selectedState = value;
    notifyListeners();
  }

  setLoadingNewAddress(value) {
    loadingNewAddress = value;
    notifyListeners();
  }

  setShippingAddressFromProfile(BuildContext context) async {
    final piProvider = Provider.of<ProfileInfoService>(context, listen: false);
    if (piProvider.profileInfo == null) {
      return;
    }
    title = piProvider.profileInfo!.userDetails.name;
    email = piProvider.profileInfo!.userDetails.email;
    phone = piProvider.profileInfo!.userDetails.phone ?? '';
    townCity = piProvider.profileInfo!.userDetails.city ?? '';
    streetAddress = piProvider.profileInfo!.userDetails.address ?? '';
    zipcode = piProvider.profileInfo!.userDetails.zipcode ?? '';
    if (piProvider.profileInfo!.userDetails.userCountry == null) {
      return;
    }
    selectedShippingAddress = null;
    final ctProvider = Provider.of<CalculateTaxService>(context, listen: false);
    var country = cm.Country(
        id: piProvider.profileInfo!.userDetails.userCountry?.id,
        name: piProvider.profileInfo!.userDetails.userCountry?.name);
    var state = States(
        id: piProvider.profileInfo!.userDetails.userState?.id,
        name: piProvider.profileInfo!.userDetails.userState?.name);
    var city = City(
        id: piProvider.profileInfo!.userDetails.userState?.id,
        name: piProvider.profileInfo!.userDetails.userState?.name);
    await ctProvider.setFromSA(context, country, state, city);
  }

  setLoadingDeleteAddress(value) {
    loadingDeleteAddress = value;
    notifyListeners();
  }

  setSelectedShippingAddress(value, BuildContext context) async {
    if (value == null && (selectedShippingAddress != null)) {
      selectedShippingAddress = null;
      notifyListeners();
      return;
    }
    if (value == null && selectedShippingAddress == null) {
      return;
    }
    currentAddress = false;
    print('selecting $value');
    selectedShippingAddress = value;
    notifyListeners();
    title = selectedShippingAddress!.shippingAddressName ?? "";
    email = selectedShippingAddress!.email;
    phone = selectedShippingAddress!.phone;
    selectedCity = City(
      id: selectedShippingAddress?.city?.id,
    );
    streetAddress = selectedShippingAddress!.address ?? "";
    zipcode = selectedShippingAddress!.zipCode ?? "";

    {
      await Provider.of<CalculateTaxService>(context, listen: false).setFromSA(
          context,
          cm.Country(
              id: selectedShippingAddress?.country?.id,
              name: selectedShippingAddress?.country?.name),
          States(
            name: selectedShippingAddress!.state?.name,
            id: selectedShippingAddress!.state?.id,
          ),
          City(
            id: selectedShippingAddress?.city?.id,
            name: selectedShippingAddress?.city?.name,
          ));
    }

    await Provider.of<CalculateTaxService>(context, listen: false)
        .setSelectedState(
      context,
      States(
        name: selectedShippingAddress!.state?.name,
        id: selectedShippingAddress!.state?.id,
      ),
    );
    print('selection done $value');
  }

  bool get allDataGiven {
    if (title?.trim().isEmpty ??
        false ||
            !EmailValidator.validate(email ?? '') ||
            phone!.trim().isEmpty ||
            selectedCountry == null ||
            selectedState == null ||
            streetAddress!.trim().isEmpty ||
            zipcode!.trim().length < 3) {
      debugPrint([
        title,
        email,
        phone,
        streetAddress,
        zipcode,
        selectedCountry?.name,
        selectedState?.name,
        selectedCity?.name
      ].toString());
      return false;
    }
    return true;
  }

  resetShippingInfo() {
    selectedShippingAddress = null;
    title = '';
    email = '';
    phone = '';
    country = '';
    streetAddress = '';
    townCity = '';
    state = '';
    zipcode = '';
    selectedCountry = null;
    selectedCity = null;
    selectedState = null;
  }

  Future<dynamic> fetchShippingAddress(BuildContext context,
      {bool loadShippingZone = false, bool fetchWithoutNew = false}) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }

    if (fetchWithoutNew &&
        shippingAddressList != null &&
        shippingAddressList!.isNotEmpty) {
      print('Shipping address already fetched');
      return;
    }
    shippingAddressList = null;
    notifyListeners();
    try {
      var headers = {'Authorization': 'Bearer $getToken'};
      var request =
          http.Request('GET', Uri.parse('$baseApi/user/all-shipping-address'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      debugPrint(response.statusCode.toString());
      var resBody = await response.stream.bytesToString();
      debugPrint(resBody.toString());
      if (response.statusCode == 200) {
        final data = jsonDecode(resBody);
        debugPrint(
            ShippingAddressListModel.fromJson(data).data.length.toString());
        shippingAddressList = ShippingAddressListModel.fromJson(data).data;
        notifyListeners();
        return;
      } else {
        shippingAddressList = [];
        print(response.reasonPhrase);
      }
    } on TimeoutException {
      shippingAddressList = [];
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      shippingAddressList = [];
      showToast(asProvider.getString(err.toString()), cc.red);
      print(err);
      rethrow;
    }
  }

  Future<dynamic> addShippingAddress(
    BuildContext context, {
    name,
    email,
    phone,
    city,
    zipcode,
    address,
  }) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }

    setLoadingNewAddress(true);

    final profileInfo = Provider.of<ProfileInfoService>(context, listen: false);
    try {
      var headers = {'Authorization': 'Bearer $getToken'};
      var request = http.MultipartRequest(
          'POST', Uri.parse('$baseApi/user/add-shipping-address'));
      request.fields.addAll({
        'name': profileInfo.profileInfo?.userDetails.name ?? '',
        'email': email,
        'phone': phone,
        'state_id': (selectedState?.id ?? '').toString(),
        'city': (selectedCity?.id ?? '').toString(),
        'zipcode': zipcode,
        'country_id': (selectedCountry?.id ?? '').toString(),
        'address': address,
        'shipping_address_name': name ?? "",
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      debugPrint({
        'name': profileInfo.profileInfo?.userDetails.name ?? '',
        'email': email,
        'phone': phone,
        'state_id': (selectedState?.id ?? '').toString(),
        'city': (selectedCity?.id ?? '').toString(),
        'zipcode': zipcode,
        'country_id': (selectedCountry?.id ?? '').toString(),
        'address': address,
        'shipping_address_name': name ?? "",
      }.toString());
      print(response.statusCode);
      var resData = await response.stream.bytesToString();
      debugPrint(resData.toString());
      if (response.statusCode == 200) {
        await fetchShippingAddress(context);
        showToast(
            AppLocalizations.of(context)!.address_added_successfully, cc.green);
        Navigator.of(context).pop();
        setLoadingNewAddress(false);
        print(resData);
      } else {
        showToast(AppLocalizations.of(context)!.failed_to_add_Address, cc.red);
        setLoadingNewAddress(false);
        print(response.reasonPhrase);
        print(resData);
      }
    } on TimeoutException {
      setLoadingNewAddress(false);
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      setLoadingNewAddress(false);
      showToast(AppLocalizations.of(context)!.something_went_wrong, cc.red);
      print(err);
      rethrow;
    }
  }

  Future<dynamic> deleteSingleAddress(BuildContext context, id) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }

    setLoadingDeleteAddress(true);
    try {
      var headers = {'Authorization': 'Bearer $getToken'};
      var request = http.Request(
          'GET', Uri.parse('$baseApi/user/shipping-address/delete/$id'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var resBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        final data = jsonDecode(resBody);
        shippingAddressList!
            .removeWhere((element) => element.id.toString() == id.toString());

        showToast(
            AppLocalizations.of(context)!.address_delete_successful, cc.green);
        setLoadingDeleteAddress(false);
        return;
      } else {
        showToast(AppLocalizations.of(context)!.address_delete_failed, cc.red);
        setLoadingDeleteAddress(false);
        print(response.reasonPhrase);
      }
    } on TimeoutException {
      setLoadingDeleteAddress(false);
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      setLoadingDeleteAddress(false);
      showToast(AppLocalizations.of(context)!.something_went_wrong, cc.red);
      print(err);
      rethrow;
    }
  }
}
