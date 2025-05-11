import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safecart/models/home_categories_model.dart';
import 'package:safecart/models/product_by_category_model.dart';

import '../helpers/common_helper.dart';

class HomeCategoriesService with ChangeNotifier {
  List<Category?>? categories;
  bool categoryLoading = false;
  Category? selectedCategory;
  bool categoryProductLoading = false;
  List<Datum>? categoryProducts;
  String? tempCatName;

  setCategoryLoading({value}) {
    categoryLoading = value ?? !categoryLoading;
    notifyListeners();
  }

  setSelectedCategory(value) async {
    selectedCategory = value;
    fetchHomeCategoryProducts(selectedCategory?.name);
    notifyListeners();
  }

  setCategoryProductLoading({value}) {
    categoryProductLoading = value ?? !categoryProductLoading;
    notifyListeners();
  }

  fetchHomeCategories(BuildContext context, {refreshing = false}) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      categories ??= [];
      categoryProducts ??= [];
      notifyListeners();
      return;
    }
    if (!refreshing) {
      setCategoryLoading(value: true);
    }

    try {
      var request =
          http.MultipartRequest('GET', Uri.parse('$baseApi/category'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        categories = HomeCategoriesModel.fromJson(data).categories;
        setCategoryLoading(value: false);
        if (categories?.first != null) {
          setSelectedCategory(categories!.first);
        }
      } else {
        categories ??= [];
        setCategoryLoading(value: false);
      }
    } on TimeoutException {
      categories ??= [];
      setCategoryLoading(value: false);
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (err) {
      categories ??= [];
      setCategoryLoading(value: false);
    }
  }

  fetchHomeCategoryProducts(name, {refreshing = false}) async {
    if (name == null && tempCatName == null) {
      return;
    }
    if (!refreshing) {
      setCategoryProductLoading(value: true);
    }
    try {
      final response =
          await http.get(Uri.parse('$baseApi/product?category=$name'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        categoryProducts = ProductByCategoryModel.fromJson(data).data;
        setCategoryProductLoading(value: false);
        notifyListeners();
      } else {
        categoryProducts ??= [];
        setCategoryProductLoading(value: false);
      }
    } on TimeoutException {
      categoryProducts ??= [];
      setCategoryProductLoading(value: false);
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (e) {
      categoryProducts ??= [];
      setCategoryProductLoading(value: false);
      showToast(asProvider.getString(e.toString()), cc.red);
    }
  }
}
