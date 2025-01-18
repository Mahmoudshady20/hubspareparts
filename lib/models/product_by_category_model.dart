import 'dart:convert';

ProductByCategoryModel productByCategoryModelFromJson(String str) =>
    ProductByCategoryModel.fromJson(json.decode(str));

String productByCategoryModelToJson(ProductByCategoryModel data) =>
    json.encode(data.toJson());

class ProductByCategoryModel {
  ProductByCategoryModel({
    required this.data,
    this.nextPage,
  });

  List<Datum> data;
  dynamic nextPage;

  factory ProductByCategoryModel.fromJson(Map<String, dynamic> json) =>
      ProductByCategoryModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        nextPage: json["next_page"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "next_page": nextPage,
      };
}

class Datum {
  Datum({
    this.prdId,
    this.title,
    this.imgUrl,
    this.campaignPercentage,
    this.price,
    this.discountPrice,
    this.badge,
    this.campaignProduct,
    this.stockCount,
    required this.avgRatting,
    this.isCartAble,
    this.vendorId,
    this.vendorName,
    this.categoryId,
    this.subCategoryId,
    required this.childCategoryIds,
    this.endDate,
    this.randomKey,
    this.randomSecret,
    this.campaignStock,
  });

  dynamic prdId;
  String? title;
  String? imgUrl;
  dynamic campaignPercentage;
  dynamic price;
  dynamic discountPrice;
  String? badge;
  bool? campaignProduct;
  dynamic stockCount;
  double avgRatting;
  bool? isCartAble;
  dynamic vendorId;
  String? vendorName;
  dynamic categoryId;
  dynamic subCategoryId;
  List<dynamic> childCategoryIds;
  DateTime? endDate;
  dynamic randomKey;
  dynamic randomSecret;
  int? campaignStock;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        prdId: json["prd_id"],
        title: json["title"],
        imgUrl: json["img_url"],
        campaignPercentage: json["campaign_percentage"] is String
            ? double.tryParse(json["campaign_percentage"])
            : json["campaign_percentage"],
        price: json["price"] is String
            ? num.tryParse(json["price"])
            : json["price"],
        discountPrice: json["discount_price"] is String
            ? double.tryParse(json["discount_price"])
            : json["discount_price"],
        badge: json["badge"]["badge_name"],
        campaignProduct: json["campaign_product"],
        stockCount: json["stock_count"] is String
            ? int.tryParse(json["stock_count"]) ?? 0
            : json["stock_count"]?.toInt() ?? 0,
        campaignStock: json["campaign_stock"] is String
            ? int.tryParse(json["campaign_stock"])
            : json["campaign_stock"]?.toInt(),
        avgRatting: json["avg_ratting"] is String
            ? num.tryParse(json["avg_ratting"])
            : json["avg_ratting"]?.toDouble() ?? 0,
        isCartAble: json["is_cart_able"],
        vendorId: json["vendor_id"],
        vendorName: json["vendor_name"],
        categoryId: json["category_id"],
        subCategoryId: json["sub_category_id"],
        randomKey: json["random_key"],
        randomSecret: json["random_secret"],
        endDate: json["end_date"] == null
            ? null
            : DateTime.tryParse(json["end_date"]),
        childCategoryIds:
            List<int>.from(json["child_category_ids"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "prd_id": prdId,
        "title": title,
        "img_url": imgUrl,
        "campaign_percentage": campaignPercentage,
        "price": price,
        "discount_price": discountPrice,
        "badge": badge,
        "campaign_product": campaignProduct,
        "stock_count": stockCount,
        "avg_ratting": avgRatting,
        "is_cart_able": isCartAble,
      };
}
