import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/helpers/common_helper.dart';
import 'package:safecart/models/city_dropdown_model.dart';
import 'package:safecart/models/country_model.dart' as cm;
import 'package:safecart/models/country_tax_model.dart' as country_tax;
import 'package:safecart/models/state_model.dart';
import 'package:safecart/services/checkout_service/checkout_service.dart';

import '../cart_data_service.dart';

class CalculateTaxService with ChangeNotifier {
  cm.Country? selectedCountry;

  List<String> countryNameList = [];
  List<String> stateNameList = [];
  List<country_tax.State>? states = [];
  double tax = 0;
  States? selectedState;
  City? selectedCity;
  double countryTax = 0;

  getStateId(name) {
    final value = states!.firstWhere((element) => element.name == name);
    return value.id;
  }

  setSelectedCountry(BuildContext context, value) async {
    if (value == selectedCountry) {
      return;
    }

    selectedCountry = value;
    selectedState = null;
    selectedCity = null;
    notifyListeners();
    if (rtlProvider.taxSystem != "advance_tax_system") {
      await fetchCountryTax(context, value?.id);
    } else {
      calculateAdvanceTax(context);
    }
    notifyListeners();
  }

  setSelectedState(BuildContext context, value) {
    if (value == selectedState) {
      return;
    }
    selectedState = value;
    selectedCity = null;
    if (rtlProvider.taxSystem != "advance_tax_system") {
      fetchStateTax(context, value?.id);
    } else {
      calculateAdvanceTax(context);
    }
    notifyListeners();
  }

  setFromSA(
    BuildContext context,
    country,
    state,
    city,
  ) {
    selectedCountry = country;
    selectedState = state;
    selectedCity = city;
    if (rtlProvider.taxSystem == "advance_tax_system") {
      calculateAdvanceTax(context);
    } else if (state != null) {
      fetchStateTax(context, selectedState?.id);
    } else {
      fetchCountryTax(context, country?.id);
    }
    notifyListeners();
  }

  setSelectedCity(BuildContext context, value) {
    if (value == selectedCity) {
      return;
    }
    selectedCity = value;
    notifyListeners();
  }

  fetchCountryTax(BuildContext context, id) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseApi/calculate-tax'));
      request.fields.addAll({'id': id.toString(), 'type': 'country'});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = country_tax.CountryTaxModel.fromJson(
            jsonDecode(await response.stream.bytesToString()));
        countryTax = data.taxAmount;
        states = data.states;
        tax = countryTax / 100;

        Provider.of<CheckoutService>(context, listen: false)
            .setTaxPercentage(tax);
      } else {
        showToast(response.reasonPhrase.toString().capitalize(), cc.red);
      }
    } on TimeoutException {
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (err) {}
  }

  fetchStateTax(BuildContext context, id) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }

    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseApi/calculate-tax'));
      request.fields.addAll({'id': id.toString(), 'type': 'state'});

      http.StreamedResponse response = await request.send();
      final resData = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        debugPrint(resData.toString());
        final data = jsonDecode(resData);
        double stateTax = data['tax_amount'] is String
            ? double.parse(data['tax_amount'])
            : data['tax_amount'].toDouble();
        tax = (stateTax <= 0 ? countryTax / 100 : stateTax / 100);
        Provider.of<CheckoutService>(context, listen: false)
            .setTaxPercentage(tax);
        notifyListeners();
      } else {
        showToast(response.reasonPhrase.toString().capitalize(), cc.red);
      }
    } on TimeoutException {
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (err) {}
  }

  calculateAdvanceTax(BuildContext context) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }

    try {
      final cartData = Provider.of<CartDataService>(context, listen: false);
      var request = http.MultipartRequest(
          'POST', Uri.parse('$baseApi/calculate-tax-amount'));
      request.fields.addAll({
        'cart_items': jsonEncode(cartData.cartList),
        'country_id': selectedCountry?.id.toString() ?? "",
        'state_id': selectedState?.id.toString() ?? "",
        'city_id': selectedCity?.id.toString() ?? ""
      });
      debugPrint(jsonEncode(cartData.cartList).toString());
      debugPrint({
        'country_id': selectedCountry?.id.toString() ?? "",
        'state_id': selectedState?.id.toString() ?? "",
        'city_id': selectedCity?.id.toString() ?? ""
      }.toString());

      http.StreamedResponse response = await request.send();
      final resData = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        debugPrint(resData.toString());
        final data = jsonDecode(resData);
        final tempMap = {};
        data.keys.toList().forEach((key) {
          tempMap.putIfAbsent(key, () => ATVendor.fromJson(data[key]));
        });

        debugPrint(tempMap.toString());
        Provider.of<CheckoutService>(context, listen: false).setATData(tempMap);
      } else {
        showToast(response.reasonPhrase.toString().capitalize(), cc.red);
      }
    } on TimeoutException {
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (err) {}
  }
}

var dat = {
  "bc1qre8jdw2azrg6tf49wmp652w00xltddxmpk98xp": {
    "rowId": "bc1qre8jdw2azrg6tf49wmp652w00xltddxmpk98xp",
    "id": 81,
    "name": "Tatyana Phelps",
    "price": 4.0,
    "original_price": 4.5,
    "imgUrl": "",
    "qty": 1,
    "hash": null,
    "options": {
      "pid_id": null,
      "tax_options_sum_rate": "36",
      "price": "49",
      "variant_id": null,
      "attributes": {},
      "used_categories": {
        "category": 3,
        "subcategory": 2,
        "childcategory": [2, 6]
      },
      "vendor_id": "admin"
    },
    "subtotal": 4.0
  },
  "91bfadd3920a88c18c4e7063ba23d2d9": {
    "rowId": "91bfadd3920a88c18c4e7063ba23d2d9",
    "id": 86,
    "name": "Ultra-Lightweight Camping Hammock",
    "price": 39.99,
    "original_price": 49.99,
    "imgUrl":
        "https://zahid.xgenious.com/safecart-api/assets/uploads/media-uploader/hammock-beach-sea-11697023958.jpg",
    "qty": 1,
    "hash": null,
    "options": {
      "pid_id": null,
      "tax_options_sum_rate": "29",
      "price": "39",
      "variant_id": null,
      "attributes": {},
      "used_categories": {
        "category": 3,
        "subcategory": 2,
        "childcategory": [2]
      },
      "vendor_id": "admin"
    },
    "subtotal": 39.99
  }
};
final data = {
  "7627324576ffc906f29c1e697feca029": {
    "rowId": "7627324576ffc906f29c1e697feca029",
    "id": "1",
    "name": "Ruby Sweeney dsf",
    "qty": "1",
    "price": 230,
    "weight": 0,
    "options": {
      "variant_id": "10",
      "color_name": "Red",
      "size_name": "Small",
      "attributes": {"Mayo": "Lime", "Cheese": "mozzarella"},
      "image": {
        "id": 539,
        "title": "up10_11zon.png",
        "path": "up10-11zon1664799603.png",
        "alt": null,
        "size": "18.65 KB",
        "dimensions": "195 x 210 pixels",
        "user_id": 8,
        "created_at": "2022-10-03T12:20:03.000000Z",
        "updated_at": "2022-10-03T12:20:03.000000Z",
        "vendor_id": null
      },
      "used_categories": {"category": 3, "subcategory": 2},
      "vendor_id": 31
    },
    "discount": 0,
    "tax": 0,
    "subtotal": 230
  },
  "e9de904a9f4512c52054183bea7739b1": {
    "rowId": "e9de904a9f4512c52054183bea7739b1",
    "id": "1",
    "name": "Ruby Sweeney dsf",
    "qty": "1",
    "price": 240,
    "weight": 0,
    "options": {
      "variant_id": "11",
      "color_name": "",
      "size_name": "Large",
      "attributes": {"Mayo": "Wasabi", "Cheese": "white"},
      "image": {
        "id": 510,
        "title": "cases (1).png",
        "path": "cases-11653287064.png",
        "alt": null,
        "size": "12.19 KB",
        "dimensions": "160 x 160 pixels",
        "user_id": null,
        "created_at": "2022-05-23T16:24:24.000000Z",
        "updated_at": "2022-05-23T16:24:24.000000Z",
        "vendor_id": null
      },
      "used_categories": {"category": 3, "subcategory": 2},
      "vendor_id": 31
    },
    "discount": 0,
    "tax": 0,
    "subtotal": 240
  },
  "a60776af6497b159332161f0126ac07e": {
    "rowId": "a60776af6497b159332161f0126ac07e",
    "id": "74",
    "name": "Champion Women's Active Tank",
    "qty": "1",
    "price": 399.98,
    "weight": 0,
    "options": {
      "image": {
        "id": 469,
        "title": "woman-suglasses-with-1k0bj1638270968.jpg",
        "path": "woman-suglasses-with-1k0bj16382709681650339532.jpg",
        "alt": null,
        "size": "84.44 KB",
        "dimensions": "1280 x 1280 pixels",
        "user_id": null,
        "created_at": "2022-04-19T03:38:53.000000Z",
        "updated_at": "2022-04-19T03:38:53.000000Z",
        "vendor_id": null
      },
      "used_categories": {"category": 8, "subcategory": 4},
      "vendor_id": 4
    },
    "discount": 0,
    "tax": 0,
    "subtotal": 399.98
  }
};

class ATVendor {
  num taxAmount;
  List<Products> products;
  num subTotal;

  ATVendor({
    required this.taxAmount,
    required this.products,
    required this.subTotal,
  });

  factory ATVendor.fromJson(Map<String, dynamic> json) => ATVendor(
        taxAmount: json["tax_amount"] is String
            ? num.tryParse(json["tax_amount"]) ?? 0
            : json["tax_amount"] ?? 0,
        products: json["products"] == null
            ? []
            : List<Products>.from(
                json["products"]!.map((x) => Products.fromJson(x))),
        subTotal: json["sub_total"] is String
            ? num.tryParse(json["sub_total"]) ?? 0
            : json["sub_total"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "tax_amount": taxAmount,
        "products": products == null
            ? []
            : List<dynamic>.from(products.map((x) => x.toJson())),
        "sub_total": subTotal,
      };
}

class Products {
  String id;
  num price;
  num oldPrice;

  Products({
    required this.id,
    required this.price,
    required this.oldPrice,
  });

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        id: json["id"].toString(),
        price: json["price"] is String
            ? num.tryParse(json["price"]) ?? 0
            : json["price"] ?? 0,
        oldPrice: json["old_price"] is String
            ? num.tryParse(json["old_price"]) ?? 0
            : json["old_price"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "old_price": oldPrice,
      };
}
