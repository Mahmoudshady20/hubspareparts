import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safecart/helpers/common_helper.dart';
import 'package:safecart/models/Brand_Model.dart';

class HomeBrandService with ChangeNotifier {
  BrandModel? brandModel;
  fetchHomeBrands(BuildContext context, {refreshing = false}) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      brandModel?.brands ??= [];
      notifyListeners();
      return;
    }
//https://hubspareparts.com/api/v1/all-brands
    try {
      var request =
          http.MultipartRequest('GET', Uri.parse('$baseApi/all-brands'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        brandModel = BrandModel.fromJson(data);
      } else {
        print(response.reasonPhrase);
        throw Exception('Failed to load Brands');
      }
    } on TimeoutException {
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (err) {
      showToast(err.toString(), cc.red);
      print(err);
    }
  }
}
