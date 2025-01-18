import 'package:flutter/material.dart';

class FiltersService with ChangeNotifier {
  List subCategories = [
    'Cloth',
    'Fruits',
    'Accesories',
    'Cloth',
    'Laravel Script',
    'Fruits',
    'Laravel Script',
    'Accesories',
    'Cloth',
    'Laravel Script',
    'Fruits',
    'Accesories',
    'Accesories',
    'Cloth',
    'Laravel Script',
    'Fruits',
    'Accesories',
  ];
  List tags = [
    'Cloth',
    'Fruits',
    'Accesories',
    'Cloth',
    'Laravel Script',
    'Fruits',
    'Laravel Script',
    'Accesories',
    'Cloth',
    'Laravel Script',
    'Fruits',
    'Accesories',
    'Accesories',
    'Cloth',
    'Laravel Script',
    'Fruits',
    'Accesories',
  ];
  dynamic selectedTags;
  dynamic selectedCategory;
  int selectedRating = 0;
  String selectedSubCategory = '0';
  bool loadingCategoryProducts = false;
  double minPrice = 0;
  double maxPrice = 1000;
  double? selectedMinPrice;
  double? selectedMaxPrice;
  int selectedCategoryId = 1;
  bool loading = false;
  bool noSubcategory = false;
  List ratingOptions = [
    'Show all',
    'Up to 1 Star',
    'Up to 2 Star',
    'Up to 3 Star',
    'Up to 4 Star',
  ];

  setSelectedCategory(value) {
    if (selectedCategory == value) {
      selectedCategory = null;
      // subCategories = [];
      noSubcategory = true;
      return;
    }
    selectedCategory = value;
    notifyListeners();
  }

  setSelectedTags(value) {
    if (selectedTags.contains(value)) {
      selectedTags.remove(value);
      notifyListeners();
      return;
    }
    selectedTags.add(value);
    notifyListeners();
  }

  setSelectedSubCategory(value) {
    if (selectedCategory == value) {
      selectedSubCategory = '';
      return;
    }
    selectedSubCategory = value;
    notifyListeners();
  }

  setSelectedRating(value) {
    if (value == selectedRating) {
      return;
    }
    selectedRating = value;
    notifyListeners();
  }

  setRangeValues(RangeValues value) {
    selectedMinPrice = value.start.toDouble();
    selectedMaxPrice = value.end.toDouble();
    notifyListeners();
  }
}
