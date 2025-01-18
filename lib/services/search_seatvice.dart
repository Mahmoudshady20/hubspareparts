import 'package:flutter/cupertino.dart';

class SearchService with ChangeNotifier {
  bool showSearchBar = false;

  setShowSearchBar(value) {
    if (showSearchBar == value) {
      return;
    }
    showSearchBar = value;
    notifyListeners();
  }
}
