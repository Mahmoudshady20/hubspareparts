import 'dart:async';
import 'dart:convert';
import 'package:safecart/l10n/generated/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:safecart/models/slider_model.dart';
import 'package:http/http.dart' as http;

import '../helpers/common_helper.dart';

class SliderService with ChangeNotifier {
  List<Datum>? sliderOneList;
  bool sliderOneLoading = false;
  List? sliderTwoList;
  bool sliderTwoLoading = false;
  List? sliderThreeList;
  bool sliderThreeLoading = false;

  setSliderOneLoading({value}) {
    sliderOneLoading = value ?? !sliderOneLoading;
    notifyListeners();
  }

  setSliderTwoLoading({value}) {
    sliderTwoLoading = value ?? !sliderTwoLoading;
    notifyListeners();
  }

  setSliderThreeLoading({value}) {
    sliderThreeLoading = value ?? !sliderThreeLoading;
    notifyListeners();
  }

  fetchSliderOne(BuildContext context, {refreshing = false}) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      sliderOneList ??= [];
      notifyListeners();
      return;
    }
    // setSliderOneLoading(value: true);
    // setSliderOneLoading(value: false);
    // notifyListeners();

    try {
      var request =
          http.MultipartRequest('GET', Uri.parse('$baseApi/mobile-slider/1'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        sliderOneList = SliderModel.fromJson(data).data;
        setSliderOneLoading(value: false);

        // notifyListeners();
      } else {
        sliderOneList = [];
        setSliderOneLoading(value: false);
      }
    } on TimeoutException {
      sliderOneList = [];
      setSliderOneLoading(value: false);
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      sliderOneList = [];
      setSliderOneLoading(value: false);
    }
  }

  fetchSliderTwo(BuildContext context, {refreshing = false}) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      sliderTwoList = [];
      notifyListeners();
      return;
    }
    if (!refreshing) {
      setSliderTwoLoading(value: true);
    }

    try {
      var request =
          http.MultipartRequest('GET', Uri.parse('$baseApi/mobile-slider/2'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        sliderTwoList = SliderModel.fromJson(data).data;
        setSliderTwoLoading(value: false);

        // notifyListeners();
      } else {
        sliderOneList = [];
        setSliderTwoLoading(value: false);
      }
    } on TimeoutException {
      sliderOneList = [];
      setSliderTwoLoading(value: false);
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      sliderOneList = [];
      setSliderTwoLoading(value: false);
    }
  }

  fetchSliderThree(BuildContext context, {refreshing = false}) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      sliderThreeList = [];
      notifyListeners();
      return;
    }
    if (!refreshing) {
      setSliderThreeLoading(value: true);
    }

    try {
      var request =
          http.MultipartRequest('GET', Uri.parse('$baseApi/mobile-slider/3'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        sliderThreeList = SliderModel.fromJson(data).data;
        setSliderThreeLoading(value: false);

        // notifyListeners();
      } else {
        sliderOneList = [];
        setSliderThreeLoading(value: false);
      }
    } on TimeoutException {
      sliderOneList = [];
      setSliderThreeLoading(value: false);
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      sliderOneList = [];
      setSliderThreeLoading(value: false);
    }
  }
}
