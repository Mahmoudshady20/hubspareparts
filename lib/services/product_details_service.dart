import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:safecart/helpers/common_helper.dart';

import '../models/product_details_model.dart';

class ProductDetailsService with ChangeNotifier {
  int currentIndex = 0;

  ProductDetailsModelProduct? productDetails;
  String? productUrl;
  Vendor? vendor;
  dynamic selectedInventrySetId;
  List productInventorySet = [];
  Map? additionalInfoStore = {};
  bool userHasItem = false;
  bool userAlredyrated = false;
  List<ProductElement?> relatedProduct = [];
  var additionalInventoryInfo;
  bool cartAble = false;
  bool reviewing = false;
  double productSalePrice = 0;
  int quantity = 1;
  int currentInfoPage = 0;
  String? additionalInfoImage;
  var variantId;
  String? selectedInventoryHash;
  List<String> selectedInventorySetIndex = [];
  List<String> inventoryKeys = [];
  Map<String, Map<String, List<String>>> allAttributes = {};
  List selectedAttributes = [];
  Map<String, List<Map<String, dynamic>>> inventorySet = {};
  Map<String, dynamic> selectedInventorySet = {};
  bool refreshPage = false;
  int? selectedIndex;
  List<String> inventoryHash = [];
  bool loadingFailed = false;

  setAttribute(value) {
    if (selectedAttributes.contains(value)) {
      return;
    }
    selectedAttributes.add(value);
    notifyListeners();
  }

  setCurrentInfoPage(value) {
    if (currentInfoPage == value) {
      return;
    }
    currentInfoPage = value;
    notifyListeners();
  }

  changeIndex(value) {
    currentIndex = value;
    notifyListeners();
  }

  setProductInventorySet(List<String>? value) {
    if (selectedInventorySetIndex.isEmpty) {
      selectedInventorySetIndex = value ?? [];
      notifyListeners();
      return;
    }
    if (selectedInventorySetIndex.isNotEmpty &&
        selectedInventorySetIndex.length > value!.length) {
      selectedInventorySetIndex = value;
      notifyListeners();
      return;
    }
    List<String> tempList = [];
    if (selectedInventorySetIndex != value) {
      tempList = selectedInventorySetIndex.where((v) {
        return value!.contains(v);
      }).toList();
      if (tempList.isNotEmpty) {
        selectedInventorySetIndex = tempList;
      }
    }
  }

  addSelectedAttribute(value) {
    if (selectedAttributes.contains(value)) {
      return;
    }
    selectedAttributes.add(value);

    notifyListeners();
  }

  bool isASelected(value) {
    return selectedAttributes.contains(value);
  }

  bool deselect(List<String>? value, List<String>? list) {
    bool result = false;
    for (var element in value!) {
      if ((list!.contains(element))) {
        result = true;
      }
    }
    return result;
  }

  addAdditionalPrice() {
    bool setMatched = true;
    if (selectedInventorySetIndex.length != 1) {
      for (int i = 0; i < selectedInventorySetIndex.length; i++) {
        setMatched = true;
        selectedInventorySet =
            productInventorySet[int.parse(selectedInventorySetIndex[i])];
        for (var e in selectedInventorySet.values) {
          List<dynamic> confirmingSelectedData = selectedAttributes;
          if (!confirmingSelectedData.contains(e)) {
            setMatched = false;
          }
        }
        final mapData = {};

        if (setMatched) {
          print('Inventory..............');
          selectedIndex = int.parse(selectedInventorySetIndex[i]);

          break;
        }
      }
    } else {
      selectedInventorySet =
          productInventorySet[int.parse(selectedInventorySetIndex[0])];
      List selectedInventorySetValues = selectedInventorySet.values.toList();
      if (selectedAttributes.length != selectedInventorySetValues.length) {
        for (var element in selectedInventorySetValues) {
          if (!selectedAttributes.contains(element)) {
            selectedAttributes.add(element);
          }
        }
      }
      selectedIndex = int.parse(selectedInventorySetIndex[0]);
    }
    if (setMatched) {
      showToast(
          asProvider.getString('Attribute set selected'), cc.secondaryColor);
      productSalePrice = productDetails?.campaignProduct?.campaignPrice ??
          productDetails?.salePrice;
      selectedInventoryHash = inventoryHash[selectedIndex!];
      productSalePrice += additionalInfoStore![selectedInventoryHash] == null
          ? 0
          : additionalInfoStore![selectedInventoryHash]!.additionalPrice
              as double;
      additionalInfoImage = additionalInfoStore![selectedInventoryHash] == null
          ? ''
          : additionalInfoStore![selectedInventoryHash]!.image;
      additionalInfoImage =
          additionalInfoImage == '' ? null : additionalInfoImage;
      cartAble = true;
      variantId = additionalInfoStore![selectedInventoryHash].pidId;
      selectedInventorySet.remove('hash');
      notifyListeners();
      return;
    }
    cartAble = false;
    productSalePrice = productDetails?.campaignProduct?.campaignPrice ??
        productDetails?.salePrice;
    additionalInfoImage = null;
    selectedInventorySet = {};
    selectedInventoryHash = null;
    variantId = null;
    notifyListeners();
  }

  bool isInSet(fieldName, value, List<String>? list) {
    bool result = false;
    if (selectedInventorySetIndex.isEmpty) {
      result = true;
    }
    for (var element in allAttributes[fieldName]!.keys.toList()) {
      if (selectedAttributes.contains(element) && value == element) {
        result == true;
        return true;
      }
      if (selectedAttributes.contains(element) && value != element) {
        result == false;
        return false;
      }
    }
    for (var element in list ?? ['0']) {
      if (selectedInventorySetIndex.contains(element)) {
        result = true;
      }
    }
    return result;
  }

  clearSelection() {
    selectedAttributes = [];
    additionalInfoImage = null;
    cartAble = false;
    productSalePrice = productDetails!.salePrice;
    selectedInventorySetIndex = [];
    selectedAttributes = [];
    notifyListeners();
  }

  addToMap(value, int index, Map<String, List<String>> map) {
    if (value == null || map == {}) {
      return;
    }
    if (!map[value]!.contains(index.toString())) {
      map.update(value, (valuee) {
        valuee.add(index.toString());
        return valuee;
      });
    }

    return map;
  }

  clearProductDetails({pop = false}) {
    print('clearing product details');
    productDetails = null;
    reviewing = false;
    productSalePrice = 0;
    productDetails = null;
    additionalInfoImage = null;
    quantity = 1;
    selectedInventorySetIndex = [];
    cartAble = false;
    inventoryKeys = [];
    allAttributes = {};
    selectedAttributes = [];
    reviewing = false;
    refreshPage = false;
    currentInfoPage = 0;
    currentIndex = 0;
    variantId = null;
  }

  fetchProductDetails(id) async {
    print('product id is- $id');
    var headers = {'Authorization': 'Bearer $getToken'};
    var request = http.Request('GET', Uri.parse('$baseApi/product/$id'));
    request.headers.addAll(headers);
    print('$baseApi/${getToken.isNotEmpty ? "user/" : ""}product/$id');

    try {
      http.StreamedResponse response = await request.send();
      List productInvenSet = [];

      final data = jsonDecode(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        productDetails = ProductDetailsModel.fromJson(data).product;
        print('Product details data');
        print(productDetails);
        vendor = ProductDetailsModel.fromJson(data).product!.vendor;
        productUrl = ProductDetailsModel.fromJson(data).productUrl;
        relatedProduct = ProductDetailsModel.fromJson(data).relatedProducts;
        userHasItem =
            ProductDetailsModel.fromJson(data).userHasItem.toString() == "1";
        userAlredyrated =
            ProductDetailsModel.fromJson(data).userRatedAlready.toString() ==
                "true";
        debugPrint([
          data["user_has_item"].toString(),
          ProductDetailsModel.fromJson(data).userRatedAlready.toString()
        ].toString());
        productInvenSet =
            ProductDetailsModel.fromJson(data).productInventorySet;
        additionalInfoStore =
            ProductDetailsModel.fromJson(data).additionalInfoStore;
        productInventorySet =
            ProductDetailsModel.fromJson(data).productInventorySet;
        cartAble = additionalInfoStore?.isEmpty ?? true == true;
        productSalePrice = productDetails?.campaignProduct?.campaignPrice ??
            productDetails?.salePrice;
        inventoryHash = [];
        for (var element in productInvenSet) {
          inventoryHash.add(element['hash']);
          element.remove('color_code');
          element.remove('hash');
          print(element);
          final keys = element.keys;
          for (var e in keys) {
            if (inventoryKeys.contains(e)) {
              continue;
            }
            if (e == 'Size' || e == 'Color') {
              print('adding at index 0 $e');
              inventoryKeys.insert(0, e);
              continue;
            }

            inventoryKeys.add(e);
          }
        }
        print(inventoryKeys);
        for (var e in inventoryKeys) {
          int index = 0;
          Map<String, List<String>> map = {};
          for (dynamic element in productInvenSet) {
            if (element.containsKey(e)) {
              map.putIfAbsent(element[e], () => []);
              if (allAttributes.containsKey(e)) {
                allAttributes.update(
                    e, (value) => addToMap(element[e], index, value));
              }
              allAttributes.putIfAbsent(e, () {
                return addToMap(element[e], index, map);
              });
            }
            index++;
          }
        }

        print(allAttributes);
      } else {
        showToast(response.reasonPhrase.toString(), cc.red);
        print(data);
      }
    } catch (e) {
      loadingFailed = true;
    }
    notifyListeners();
    return;
  }
}
