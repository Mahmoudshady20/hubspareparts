import 'package:flutter/material.dart';

class ShippingInfoService with ChangeNotifier {
  String name = '';
  String email = '';
  String phone = '';
  String country = '';
  String streetAddress = '';
  String townCity = '';
  String state = '';
  setName(value) {
    name = value;
    notifyListeners();
  }

  setEmail(value) {
    email = value;
    notifyListeners();
  }

  setPhone(value) {
    phone = value;
    notifyListeners();
  }

  setCountry(value) {
    country = value;
    notifyListeners();
  }

  setStreetAddress(value) {
    streetAddress = value;
    notifyListeners();
  }

  setTownCity(value) {
    townCity = value;
    notifyListeners();
  }

  setState(value) {
    state = value;
    notifyListeners();
  }

  bool get allDataGiven {
    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        phone.trim().isEmpty ||
        country.trim().isEmpty ||
        streetAddress.trim().isEmpty ||
        townCity.trim().isEmpty ||
        state.trim().isEmpty) {
      return false;
    }
    return true;
  }

  resetShippingInfo() {
    name = '';
    email = '';
    phone = '';
    country = '';
    streetAddress = '';
    townCity = '';
    state = '';
  }
}
