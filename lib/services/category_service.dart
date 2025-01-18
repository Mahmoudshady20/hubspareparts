import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:safecart/models/categories_model.dart';

import '../helpers/common_helper.dart';

class CategoryService with ChangeNotifier {
  List<Datum?>? categories;
  String responseString = "";

  dynamic selectedCategory = 0;
  dynamic selectedSubCategory = '0';
  bool lodingCategoryProducts = false;
  var selectedChildCats = [];
  double minPrice = 0;
  double maxPrice = 1000;
  dynamic selectedCategorieId = 1;
  var sizes = ['M', 'S', 'XL', 'L'];
  var colors = [
    '#710404',
    '#71ff04',
    '#710ee4',
  ];
  var brands = ['Laffz', 'Lux', 'Sandlina', 'Apex'];
  bool loading = false;
  bool noSubcategory = false;

  setSelectedCategory(
    value,
  ) {
    if (selectedCategory == value) {
      return;
    }
    selectedChildCats = [];
    selectedSubCategory = null;
    selectedChildCats = [];
    lodingCategoryProducts = true;
    selectedCategory = value;
    notifyListeners();
  }

  setSelectedSubCategory(cat, subCat) {
    if (selectedCategory == subCat) {
      return;
    }
    selectedChildCats = [];
    selectedCategory = cat;
    selectedSubCategory = subCat;
    notifyListeners();
  }

  fetchCategories(BuildContext context) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }
    print('sending otpCode');
    try {
      var request = http.Request('GET', Uri.parse('$baseApi/all-categories'));

      http.StreamedResponse response = await request.send();

      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        responseString = await response.stream.bytesToString();
        debugPrint("Starting isolate in next line".toString());
        final receivePort = ReceivePort();
        Isolate.spawn(isolateTask, receivePort.sendPort);
      } else {
        print(response.reasonPhrase);
        showToast(response.reasonPhrase.toString().capitalize(), cc.red);
      }
    } on TimeoutException {
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (err) {
      print(err);
    }
  }

  setSelectedChildCats(cat, subCat, childCat) {
    // if (selectedCategory == cat &&
    //     selectedSubCategory == subCat &&
    //     selectedChildCats.contains(ChildCat)) {}
    if (selectedCategory != cat || selectedSubCategory != subCat) {
      selectedCategory = cat;
      selectedSubCategory = subCat;
      selectedChildCats = [];
    }
    print(childCat);
    if (selectedChildCats.contains(childCat)) {
      selectedChildCats.remove(childCat);
    } else {
      selectedChildCats.add(childCat);
    }
    notifyListeners();
  }

  var category = {};

  // 'Accesories',
  // 'Cloth',
  // 'Laravel Script',
  // 'Fruits',
  // 'Accesories',
  // 'Accesories',
  // 'Cloth',
  // 'Laravel Script',
  // 'Fruits',
  // 'Accesories',
  // ];

  void isolateTask(SendPort sendPort) {
    log("isolate start");
    int total = 1;
    try {
      for (int i = 1; i < 12365410; i++) {
        /// Multiplies each index by the multiplier and computes the total
        total += (i * 1254);
      }
      log(total.toString());
      final data = jsonDecode(responseString);
      categories = CategoriesModel.fromJson(data).data;
    } on TimeoutException {
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (err) {
      print(err);
    }
    sendPort.send(total);
  }
}





// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

