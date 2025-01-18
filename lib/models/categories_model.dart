import 'dart:convert';

CategoriesModel? categoriesModelFromJson(String str) =>
    CategoriesModel.fromJson(json.decode(str));

String categoriesModelToJson(CategoriesModel? data) =>
    json.encode(data!.toJson());

class CategoriesModel {
  CategoriesModel({
    this.data,
  });

  List<Datum?>? data;

  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      CategoriesModel(
        data: json["data"] == null
            ? []
            : List<Datum?>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x!.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.name,
    this.image,
    this.subCategories,
    this.childCategories,
  });

  dynamic id;
  String? name;
  String? image;
  List<Datum?>? subCategories;
  List<Datum?>? childCategories;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        subCategories: json["sub_categories"] == null
            ? []
            : json["sub_categories"] == null
                ? []
                : List<Datum?>.from(
                    json["sub_categories"]!.map((x) => Datum.fromJson(x))),
        childCategories: json["child_categories"] == null
            ? []
            : json["child_categories"] == null
                ? []
                : List<Datum?>.from(
                    json["child_categories"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "sub_categories": subCategories == null
            ? []
            : subCategories == null
                ? []
                : List<dynamic>.from(subCategories!.map((x) => x!.toJson())),
        "child_categories": childCategories == null
            ? []
            : childCategories == null
                ? []
                : List<dynamic>.from(childCategories!.map((x) => x!.toJson())),
      };
}
