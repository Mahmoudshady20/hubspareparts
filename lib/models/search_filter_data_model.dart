import 'dart:convert';

SearchFilterDataModel searchFilterDataModelFromJson(String str) =>
    SearchFilterDataModel.fromJson(json.decode(str));

class SearchFilterDataModel {
  SearchFilterDataModel({
    this.allCategory,
    this.allUnits,
    this.allColors,
    this.allSizes,
    this.allBrands,
    required this.maxPrice,
    required this.minPrice,
    this.itemStyle,
  });

  List<AllBrand>? allCategory;
  List<AllUnit>? allUnits;
  List<All>? allColors;
  List<All>? allSizes;
  List<AllBrand>? allBrands;
  double maxPrice;
  double minPrice;
  List<String>? itemStyle;

  factory SearchFilterDataModel.fromJson(Map<String, dynamic> json) =>
      SearchFilterDataModel(
        allCategory: List<AllBrand>.from(
            json["all_category"].map((x) => AllBrand.fromJson(x))),
        allUnits: List<AllUnit>.from(
            json["all_units"].map((x) => AllUnit.fromJson(x))),
        allColors:
            List<All>.from(json["all_colors"].map((x) => All.fromJson(x))),
        allSizes: List<All>.from(json["all_sizes"].map((x) => All.fromJson(x))),
        allBrands: List<AllBrand>.from(
            json["all_brands"].map((x) => AllBrand.fromJson(x))),
        maxPrice: json["max_price"] is String
            ? double.parse(json["max_price"])
            : json["max_price"].toDouble(),
        minPrice: json["min_price"] is String
            ? double.parse(json["min_price"])
            : json["min_price"].toDouble(),
        itemStyle: List<String>.from(json["item_style"].map((x) => x)),
      );
}

class AllBrand {
  AllBrand({
    required this.name,
    this.subCategories,
    this.childCategories,
  });

  String name;
  List<AllBrand>? subCategories;
  List<AllBrand>? childCategories;

  factory AllBrand.fromJson(Map<String, dynamic> json) => AllBrand(
        name: json["name"],
        subCategories: json["sub_categories"] == null
            ? []
            : List<AllBrand>.from(
                json["sub_categories"]!.map((x) => AllBrand.fromJson(x))),
        childCategories: json["child_categories"] == null
            ? []
            : List<AllBrand>.from(
                json["child_categories"]!.map((x) => AllBrand.fromJson(x))),
      );
}

class All {
  All({
    this.id,
    required this.name,
    this.colorCode,
    this.sizeCode,
  });

  dynamic id;
  String? name;
  String? colorCode;
  String? sizeCode;

  factory All.fromJson(Map<String, dynamic> json) => All(
        id: json["id"],
        name: json["name"],
        colorCode: json["color_code"],
        sizeCode: json["size_code"],
      );
}

class AllUnit {
  AllUnit({
    this.id,
    required this.name,
  });

  dynamic id;
  String name;

  factory AllUnit.fromJson(Map<String, dynamic> json) => AllUnit(
        id: json["id"],
        name: json["name"],
      );
}
