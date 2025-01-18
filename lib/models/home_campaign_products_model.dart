import 'dart:convert';

HomeCampaignProductsModel? homeCampaignProductsModelFromJson(String str) =>
    HomeCampaignProductsModel.fromJson(json.decode(str));

String homeCampaignProductsModelToJson(HomeCampaignProductsModel? data) =>
    json.encode(data!.toJson());

class HomeCampaignProductsModel {
  HomeCampaignProductsModel({
    this.products,
    this.campaignInfo,
    this.currentPage,
    this.lastPage,
  });

  List<Product?>? products;
  CampaignInfo? campaignInfo;
  final currentPage;
  final lastPage;

  factory HomeCampaignProductsModel.fromJson(Map<String, dynamic> json) =>
      HomeCampaignProductsModel(
        products: json["products"] == null
            ? []
            : json["products"]["data"] == null
                ? []
                : List<Product?>.from(
                    json["products"]["data"]!.map((x) => Product.fromJson(x))),
        campaignInfo: CampaignInfo.fromJson(json["campaign_info"]),
      );

  Map<String, dynamic> toJson() => {
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x!.toJson())),
        "campaign_info": campaignInfo!.toJson(),
      };
}

class CampaignInfo {
  CampaignInfo({
    this.id,
    this.title,
    this.slug,
    this.subtitle,
    this.image,
    this.startDate,
    this.endDate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.adminId,
    this.vendorId,
    this.type,
  });

  dynamic id;
  String? title;
  dynamic slug;
  String? subtitle;
  int? image;
  dynamic startDate;
  DateTime? endDate;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? adminId;
  dynamic vendorId;
  String? type;

  factory CampaignInfo.fromJson(Map<String, dynamic> json) => CampaignInfo(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        subtitle: json["subtitle"],
        image: json["image"],
        startDate: json["start_date"],
        endDate: DateTime.tryParse(json["end_date"]),
        status: json["status"],
        createdAt: DateTime.tryParse(json["created_at"]),
        updatedAt: DateTime.tryParse(json["updated_at"]),
        adminId: json["admin_id"],
        vendorId: json["vendor_id"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "subtitle": subtitle,
        "image": image,
        "start_date": startDate,
        "end_date": endDate?.toIso8601String(),
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "admin_id": adminId,
        "vendor_id": vendorId,
        "type": type,
      };
}

class Product {
  Product(
      {this.prdId,
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
      required this.vendorId,
      required this.vendorName,
      required this.categoryId,
      required this.subCategoryId,
      required this.childCategoryIds,
      this.endDate,
      this.randomKey,
      this.randomSecret,
      this.campaignStock});

  dynamic prdId;
  String? title;
  String? imgUrl;
  double? campaignPercentage;
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
  dynamic childCategoryIds;
  DateTime? endDate;
  dynamic randomKey;
  dynamic randomSecret;
  int? campaignStock;

  factory Product.fromJson(Map json) => Product(
        prdId: json["prd_id"],
        title: json["title"],
        imgUrl: json["img_url"],
        campaignPercentage: json["campaign_percentage"] is String
            ? double.tryParse(json["campaign_percentage"])
            : json["campaign_percentage"]?.toDouble(),
        price: json["price"] is String
            ? double.tryParse(json["price"])
            : json["price"]?.toDouble(),
        discountPrice: json["discount_price"] is String
            ? double.tryParse(json["discount_price"])
            : json["discount_price"]?.toDouble(),
        badge: json["badge"]["badge_name"],
        campaignProduct: json["campaign_product"],
        stockCount: json["stock_count"] is String
            ? int.tryParse(json["stock_count"]) ?? 0
            : json["stock_count"]?.toInt() ?? 0,
        campaignStock: json["campaign_stock"] is String
            ? int.tryParse(json["campaign_stock"])
            : json["campaign_stock"],
        avgRatting: json["avg_ratting"] is String
            ? double.tryParse(json["avg_ratting"])
            : json["avg_ratting"]?.toDouble() ?? 0,
        isCartAble: json["is_cart_able"],
        vendorId: json["vendor_id"],
        vendorName: json["vendor_name"],
        categoryId: json["category_id"],
        subCategoryId: json["sub_category_id"],
        endDate: json["end_date"] == null
            ? null
            : DateTime.tryParse(json["end_date"]),
        randomKey: json["random_key"],
        randomSecret: json["random_secret"],
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
