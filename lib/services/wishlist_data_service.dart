import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';

import '../helpers/common_helper.dart';
import '../helpers/db_helper.dart';

class WishlistItem {
  final dynamic id;
  final dynamic vendorId;
  final String title;
  final double? price;
  final double? originalPrice;
  final String imgUrl;
  final bool isCartable;
  final dynamic prodCatData;
  final double rating;
  final dynamic randomKey;
  final dynamic randomSecret;
  final dynamic stock;
  WishlistItem(
      this.id,
      this.vendorId,
      this.title,
      this.price,
      this.originalPrice,
      this.imgUrl,
      this.isCartable,
      this.prodCatData,
      this.rating,
      this.randomKey,
      this.randomSecret,
      this.stock);
}

class WishlistDataService with ChangeNotifier {
  Map<String, WishlistItem> _wishListItems = {};

  Map<String, WishlistItem> get wishlistItems {
    return _wishListItems;
  }

  bool isWishlist(String id) {
    return _wishListItems.containsKey(id);
  }

  void toggleWishlist(
      BuildContext context,
      dynamic id,
      String title,
      double price,
      double? originalPrice,
      String imgUrl,
      bool isCartable,
      prodCatData,
      vendorId,
      double rating,
      {required randomKey,
      required randomSecret,
      stock}) async {
    if (_wishListItems.containsKey(id.toString())) {
      deleteWishlistItem(id, context);
      _wishListItems.remove(id);
      notifyListeners();
      return;
    }

    await DbHelper.insert('wishlist', {
      'vendorId': vendorId,
      'productId': id,
      'title': title,
      'price': price,
      'originalPrice': originalPrice,
      'imgUrl': imgUrl,
      'isCartable': isCartable ? 0 : 1,
      'prodCatData': jsonEncode(prodCatData),
      'rating': rating,
      'random_key': randomKey,
      'stock': stock,
      'random_secret': randomSecret
    });
    _wishListItems.putIfAbsent(
        id.toString(),
        () => WishlistItem(id, vendorId, title, price, originalPrice, imgUrl,
            isCartable, prodCatData, rating, randomKey, randomSecret, stock));
    showToast(AppLocalizations.of(context)!.item_added_to_wishlist, cc.blackColor);
    notifyListeners();
  }

  void fetchWishlistItem() async {
    final dbData = await DbHelper.fetchDb('wishlist');
    Map<String, WishlistItem> dataList = {};
    for (var element in dbData) {
      dataList.putIfAbsent(
        element['productId'].toString(),
        () => WishlistItem(
          element['productId'],
          element['vendorId'],
          element['title'],
          element['price'],
          element['originalPrice'],
          element['imgUrl'],
          element['isCartable'] == 0,
          jsonDecode(
            element['prodCatData'],
          ),
          element['rating'],
          element['random_key'],
          element['random_secret'],
          element['stock'],
        ),
      );
    }
    _wishListItems = dataList;
    notifyListeners();
    refreshFavList();
  }

  void deleteWishlistItem(dynamic id, BuildContext context) async {
    await DbHelper.deleteDbSI('wishlist', id);
    _wishListItems.removeWhere((key, value) {
      return value.id.toString() == id.toString();
    });
    showToast(
        AppLocalizations.of(context)!.item_removed_from_wishlist, cc.blackColor);
    notifyListeners();
  }

  refreshFavList() {
    // try {
    //   wishlistItems.forEach((key, value) async {
    //     final url = Uri.parse('$baseApiUrl/product/$key');

    //     // try {
    //     final response = await http.get(url);
    //     if (response.statusCode != 200) {
    //       await DbHelper.deleteDbSI('wishlist', value.id);
    //       _wishListItems.removeWhere((key, value) => value.id == value.id);
    //       notifyListeners();
    //     }
    //   });
    // } catch (e) {
    //   print(e);
    // }
  }

  emptyWishlist() async {
    await DbHelper.deleteDbTable('wishlist');
    _wishListItems = {};
    notifyListeners();
  }
}
