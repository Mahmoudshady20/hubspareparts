import 'dart:convert';

HomeCategoriesModel? homeCategoriesModelFromJson(String str) =>
    HomeCategoriesModel.fromJson(json.decode(str));

String homeCategoriesModelToJson(HomeCategoriesModel? data) =>
    json.encode(data!.toJson());

class HomeCategoriesModel {
  HomeCategoriesModel({
    this.categories,
    this.success,
  });

  List<Category?>? categories;
  bool? success;

  factory HomeCategoriesModel.fromJson(Map<String, dynamic> json) =>
      HomeCategoriesModel(
        categories: json["categories"] == null
            ? []
            : List<Category?>.from(
                json["categories"]!.map((x) => Category.fromJson(x))),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x!.toJson())),
        "success": success,
      };
}

class Category {
  Category({
    this.id,
    this.name,
    this.nameAr,
    this.imageUrl,
  });

  dynamic id;
  String? name;
  String? nameAr;
  String? imageUrl;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        nameAr: json["name_ar"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "name_ar": nameAr,
        "image_url": imageUrl,
      };
}
