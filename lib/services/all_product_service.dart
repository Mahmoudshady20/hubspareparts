import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:safecart/models/search_product_model.dart';

import '../helpers/common_helper.dart';

class AllProductsService with ChangeNotifier {
  List<Datum>? allProducts;
  bool loading = false;
  bool noSubcategory = false;
  String? nextPage;
  bool nextLoading = false;

  setLoading(value) {
    loading = value ?? !loading;
    notifyListeners();
  }

  setNextLoading(value) {
    nextLoading = value ?? !nextLoading;
    notifyListeners();
  }

  resetProducts() {
    allProducts = null;
  }

  fetchProducts(BuildContext context) async {
    allProducts = null;
    setLoading(true);
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      setLoading(false);
      return;
    }

    try {
      var request = http.Request('GET', Uri.parse('$baseApi/product'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        print(data);
        allProducts = SearchProductModel.fromJson(data).data;

        final tempPL = SearchProductModel.fromJson(data);
        nextPage = tempPL.currentPage < tempPL.lastPage
            ? "$baseApi/product?&page=${tempPL.currentPage + 1}"
            : null;
        debugPrint("next page is $nextPage".toString());
      } else {
        print(response.reasonPhrase);
      }
    } on TimeoutException {
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      print(err);
    } finally {
      allProducts ??= [];
      setLoading(false);
    }
  }

  fetchNextPageProducts(BuildContext context) async {
    setNextLoading(true);
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      setNextLoading(false);
      // allProducts = [];
      return;
    }
    print('getting next page $nextPage');
    try {
      var request = http.Request('GET', Uri.parse('$nextPage'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        print(data);
        for (var element in SearchProductModel.fromJson(data).data) {
          allProducts?.add(element);
        }
        final tempPL = SearchProductModel.fromJson(data);
        nextPage = tempPL.currentPage < tempPL.lastPage
            ? "$baseApi/product?&page=${tempPL.currentPage + 1}"
            : null;
        print(allProducts?.length);
      } else {
        print(response.reasonPhrase);
      }
    } on TimeoutException {
      showToast(AppLocalizations.of(context)!.request_timeout, cc.red);
    } catch (err) {
      print(err);
    } finally {
      setNextLoading(false);
    }
  }
}
