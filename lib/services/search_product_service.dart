import 'dart:async';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/cupertino.dart';
import 'package:safecart/models/search_product_model.dart';

import '../helpers/common_helper.dart';
import 'package:http/http.dart' as http;

class SearchProductService with ChangeNotifier {
  List<Datum>? searchedProduct;
  String selectedName = '';
  dynamic selectedCategory = '';
  dynamic selectedSubCategory = '';
  bool lodingCategoryProducts = false;
  String selectedChildCats = '';
  dynamic selectedMinPrice = '';
  dynamic selectedMaxPrice = '';
  int selectedRating = 0;
  dynamic selectedColor = '';
  dynamic selectedSize = '';
  dynamic selectedBrand = '';
  dynamic selectedTags;
  bool loading = false;
  bool noSubcategory = false;
  String? nextPage;
  bool nextLoading = false;
  String url = '';

  setLoading(value) {
    loading = value ?? !loading;
    notifyListeners();
  }

  setNextLoading(value) {
    nextLoading = value ?? !nextLoading;
    notifyListeners();
  }

  setFilterOptions(
      {nameVal,
      catVal,
      subCatVal,
      childCatVal,
      colorVal,
      sizeVal,
      brandVal,
      minPrice,
      maxPrice,
      rating}) {
    selectedName = nameVal ?? selectedName;
    selectedCategory = catVal ?? selectedCategory;
    selectedSubCategory = subCatVal ?? selectedSubCategory;
    selectedChildCats = childCatVal ?? selectedChildCats;
    selectedColor = colorVal ?? selectedColor;
    selectedSize = sizeVal ?? selectedSize;
    selectedBrand = brandVal ?? selectedBrand;
    selectedMinPrice = minPrice ?? selectedMinPrice;
    selectedMaxPrice = maxPrice ?? selectedMaxPrice;
    selectedRating = rating ?? selectedRating;
  }

  resetFilterOptions() {
    searchedProduct = null;
    // selectedName = '';
    selectedCategory = '';
    selectedSubCategory = '';
    selectedChildCats = '';
    selectedColor = '';
    selectedSize = '';
    selectedBrand = '';
    selectedMinPrice = '';
    selectedMaxPrice = '';
    selectedRating = 0;
  }

  resetSearch() {
    selectedName = '';
    nextPage = null;
  }

  fetchProducts(BuildContext context) async {
    searchedProduct = null;
    setLoading(true);
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      setLoading(false);
      searchedProduct = [];
      return;
    }
    selectedMinPrice = selectedMinPrice == 'null' || selectedMinPrice == null
        ? ''
        : selectedMinPrice;
    selectedMaxPrice = selectedMaxPrice == 'null' || selectedMaxPrice == null
        ? ''
        : selectedMaxPrice;
    final url =
        "$baseApi/product?name=$selectedName&category=$selectedCategory&sub_category=$selectedSubCategory&child_category=$selectedChildCats&size=$selectedSize&brand=$selectedBrand&color=$selectedColor&min_price=$selectedMinPrice&max_price=$selectedMaxPrice&rating=$selectedRating&sku&tag&delivery_option&refundable&inventory_warning&from_price&to_price&date_range&count";
    try {
      var request = http.Request('GET', Uri.parse(url));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        print(data);
        final tempPL = SearchProductModel.fromJson(data);
        searchedProduct = tempPL.data;
        nextPage = tempPL.currentPage < tempPL.lastPage
            ? "$url&page=${tempPL.currentPage + 1}"
            : null;
        setLoading(false);
      } else {
        setLoading(false);
        searchedProduct ??= [];
        print(response.reasonPhrase);
      }
    } on TimeoutException {
      setLoading(false);
      searchedProduct ??= [];
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      setLoading(false);
      searchedProduct ??= [];
      print(err);
    }
  }

  fetchNextPageProducts(BuildContext context) async {
    setNextLoading(true);
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      setNextLoading(false);
      searchedProduct ??= [];
      return;
    }
    print(selectedName);
    print('searching products '
        '$nextPage');
    try {
      var request = http.Request('GET', Uri.parse('$nextPage'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        final tempPL = SearchProductModel.fromJson(data);
        print(data);
        for (var element in tempPL.data) {
          searchedProduct!.add(element);
        }

        nextPage = tempPL.currentPage < tempPL.lastPage
            ? "$url&page=${tempPL.currentPage + 1}"
            : null;
        print(searchedProduct?.length);
        setNextLoading(false);
      } else {
        setNextLoading(false);
        searchedProduct ??= [];
        print(response.reasonPhrase);
      }
    } on TimeoutException {
      setNextLoading(false);
      searchedProduct ??= [];
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      setNextLoading(false);
      searchedProduct ??= [];
      print(err);
    }
  }
}
