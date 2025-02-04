import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../helpers/common_helper.dart';
import '../helpers/db_helper.dart';

class CartDataService with ChangeNotifier {
  Map _cartItems = {};

  Map get cartList {
    return Map.from(_cartItems);
  }

  Map get cartListWithoutAdmin {
    String ran = jsonEncode(cartList);
    Map<String, dynamic> clist = jsonDecode(ran); // Make a copy of cartList
    clist.forEach((key, value) {
      if (clist[key]['options']['vendor_id'] == 'admin') {
        clist[key]['options']['vendor_id'] = '';
      }
    });
    return clist;
  }

  num calculateSubtotal() {
    num sum = 0;
    _cartItems.forEach((key, value) {
      sum +=
          ((value?['price'] ?? 1.0) as double) * ((value?['qty'] ?? 1) as int);
    });
    return sum;
  }

  productListFormVendorId(vendorId) {
    List productByVendorIdList = [];
    final vendorRowId = vendorRowIds(vendorId.toString());
    vendorRowId.forEach((rowId) {
      productByVendorIdList.add(cartList[rowId]);
    });
    return productByVendorIdList;
  }

  vendorRowIds(vendorId) {
    List rowIds = [];
    cartList.forEach((key, value) {
      if (value != null &&
          value['options']['vendor_id'].toString() == vendorId.toString()) {
        rowIds.add(value['rowId']);
      }
    });
    return rowIds;
  }

  num calculateVendorSubtotal(vendorId) {
    num sum = 0;

    final rowIds = vendorRowIds(vendorId);
    for (var element in rowIds) {
      sum += (cartList[element]['price'] as double) *
          (cartList[element]['qty'] as int);
    }
    return sum;
  }

  formatItems() {
    Map map = {};

    for (var element in _cartItems.keys) {
      List list = [];
      //
      for (var e in _cartItems[element]!['product']!) {
        if (e['attributes'] == null) {
          list.add(({
            'id': e['id'],
            'qty': e['qty'],
            'attributes': {"price": e['price']},
          }));
        }
        if (e['attributes'] != null) {
          (e['attributes'] as Map).putIfAbsent("price", () => e['price']);
          list.add(({
            'id': e['id'],
            'qty': e['qty'],
            'hash': e['hash'],
            'attributes': e['attributes'],
          }));
        }
      }
      (list[0]['attributes'] as Map).remove('Color_name');
      (list[0]['attributes'] as Map).remove('Color');
      //
      map.putIfAbsent(element, () => list);
      //
    }
    //
    return map;
  }

  cartItemIds() {
    List list = [];

    for (var e in _cartItems.values) {
      //
      if (e != null && !list.contains(e['id'])) {
        list.add(
          e['id'],
        );
      }
    }
    return list;
  }

  void addItem(BuildContext context, vendorId, id,
      {int? extraQuantity, inventorySet, rowId}) async {
    //
    //
    if ((_cartItems[rowId]["qty"] + (extraQuantity ?? 1)) >
        _cartItems[rowId]["stock"]) {
      debugPrint(
          "stock is ${(_cartItems[rowId]["qty"] + (extraQuantity ?? 1))} and quantity is ${_cartItems[rowId]["stock"]}"
              .toString());
      showToast(AppLocalizations.of(context)!.product_stock_is_insufficient,
          cc.blackColor);
      return;
    }
    _cartItems[rowId].update('qty', (value) {
      int sum = (value as int) + (extraQuantity ?? 1);
      showToast(
          AppLocalizations.of(context)!.item_added_to_cart, cc.blackColor);
      return sum;
    });
    _cartItems[rowId].update('subtotal', (value) {
      var sum = _cartItems[rowId]['price'] * _cartItems[rowId]['qty'];

      return sum;
    });

    DbHelper.updatedb(
      'cart',
      rowId,
      {
        'data': jsonEncode(_cartItems[rowId]),
      },
    );
    final dbData = await DbHelper.fetchDb('cart');

    notifyListeners();
  }

  void removeItem(vendorId, dynamic id, BuildContext context,
      {inventorySet, rowId}) {
    _cartItems[rowId].update('qty', (value) {
      int sum = value as int;
      if (value != 1) {
        sum -= 1;
      }

      return sum;
    });
    _cartItems[rowId].update('subtotal', (value) {
      var sum = _cartItems[rowId]['price'] * _cartItems[rowId]['qty'];

      return sum;
    });

    DbHelper.updatedb(
      'cart',
      rowId,
      {
        'data': jsonEncode(_cartItems[rowId]),
      },
    );
    showToast(AppLocalizations.of(context)!.item_subtracted_from_cart, cc.red);

    notifyListeners();
  }

  List get vendorIds {
    List list = [];
    cartList.values.toList().forEach((element) {
      if (element != null && !list.contains(element['options']['vendor_id'])) {
        list.add(element['options']['vendor_id']);
      }
    });

    return list;
  }

  void addCartItem(BuildContext context, vendorId, id, String title,
      double price, int quantity, String imgUrl, variantId,
      {String? hash,
      inventorySet = const {},
      originalPrice,
      inventoryId,
      required randomKey,
      required randomSecret,
      prodCatData,
      required stock}) async {
    final String rowId = md5
        .convert(utf8.encode(id.toString() + inventorySet.toString()))
        .toString();

    Map<String, Map<String, dynamic>> map = {
      rowId: {
        'rowId': rowId,
        'id': id,
        'name': title,
        'price': price,
        'original_price': originalPrice,
        'imgUrl': imgUrl,
        'qty': quantity,
        'hash': hash,
        "options": {
          "pid_id": inventoryId,
          "tax_options_sum_rate": randomKey.toString().length > 23
              ? randomKey.toString().substring(8, 10)
              : "0",
          "price": randomSecret.toString().length > 23
              ? randomSecret.toString().substring(15, 17)
              : "0",
          "variant_id": variantId,
          "attributes": inventorySet,
          "used_categories": prodCatData,
          "vendor_id": vendorId ?? 'admin',
        },
        "stock": stock,
        "subtotal": quantity * price
      }
    };
    debugPrint(map.toString());
    debugPrint(stock.toString());
    debugPrint(quantity.toString());
    if (!_cartItems.containsKey(rowId)) {
      if (stock < quantity) {
        debugPrint("stock is $stock and quantity is $quantity".toString());
        showToast(AppLocalizations.of(context)!.product_stock_is_insufficient,
            cc.blackColor);
        return;
      }
      _cartItems[rowId] = map[rowId];
      await DbHelper.insert('cart', {
        'rowId': rowId,
        'data': jsonEncode(map[rowId]),
      });

      showToast(
          AppLocalizations.of(context)!.item_added_to_cart, cc.blackColor);
      notifyListeners();
      return;
    }
    if (_cartItems.containsKey(rowId)) {
      addItem(context, vendorId, id,
          extraQuantity: quantity, inventorySet: inventorySet, rowId: rowId);
      notifyListeners();
      return;
    }
  }

  void fetchCarts() async {
    final dbData = await DbHelper.fetchDb('cart');

    if (dbData.isEmpty) {
      return;
    }

    for (var element in dbData) {
      final data = jsonDecode(element['data']);
      if (data != null) {
        _cartItems.putIfAbsent(element['rowId'], () => data);
      }
    }

    notifyListeners();
    refreshCartList();
    //
  }

  void deleteCartItem(dynamic id, rowId) async {
    //
    if (!cartList.containsKey(rowId)) {
      return;
    }

    _cartItems.remove(rowId.toString());

    DbHelper.updatedb(
      'cart',
      rowId,
      {
        'data': jsonEncode(_cartItems[rowId]),
      },
    );

    notifyListeners();
  }

  int totalQuantity() {
    var total = 0;
    _cartItems.values.toList().forEach((element) {
      if (element != null) {
        total += element['qty'] as int;
      }
    });
    return total;
  }

  refreshCartList() async {}

  emptyCart() async {
    await DbHelper.deleteDbTable('cart');
    _cartItems = {};
    notifyListeners();
  }

  removeCharactersFromRandomSecret(
      String originalString, int firstNumber, int lastNumber) {
    if (firstNumber > 0 &&
        firstNumber < originalString.length &&
        lastNumber > 0 &&
        lastNumber < originalString.length) {
      String stringWithoutFirst = originalString.substring(firstNumber);
      String stringWithoutLast = stringWithoutFirst.substring(
          0, stringWithoutFirst.length - lastNumber);

      return stringWithoutLast; // Remove the specified targetString
    } else {
      return "";
    }
  }
}
