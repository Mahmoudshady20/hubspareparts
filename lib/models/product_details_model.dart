import 'dart:convert';

ProductDetailsModel productDetailsModelFromJson(String str) =>
    ProductDetailsModel.fromJson(json.decode(str));

class ProductDetailsModel {
  ProductDetailsModel(
      {required this.product,
      required this.productUrl,
      required this.relatedProducts,
      this.userHasItem,
      required this.ratings,
      this.avgRating,
      required this.productInventorySet,
      required this.additionalInfoStore,
      required this.allUnits,
      required this.maximumAvailablePrice,
      required this.minPrice,
      required this.maxPrice,
      required this.allTags,
      required this.productColors,
      required this.productSizes,
      required this.settingText,
      required this.userRatedAlready,
      this.productDeliveryOption});

  ProductDetailsModelProduct? product;
  dynamic productUrl;
  List<ProductElement?> relatedProducts;
  dynamic userHasItem;
  List<dynamic>? ratings;
  dynamic avgRating;
  dynamic productInventorySet;
  Map? additionalInfoStore;
  List<dynamic>? allUnits;
  dynamic maximumAvailablePrice;
  dynamic minPrice;
  dynamic maxPrice;
  List<Tag>? allTags;
  List<ProductColor>? productColors;
  List<ProductColor>? productSizes;
  SettingText? settingText;
  dynamic userRatedAlready;
  List<ProductDeliveryOption>? productDeliveryOption;

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailsModel(
        product: ProductDetailsModelProduct.fromJson(json["product"]),
        productUrl: json["product_url"],
        relatedProducts: json["related_products"] == null
            ? []
            : List<ProductElement?>.from(json["related_products"]
                .map((x) => ProductElement.fromJson(x))),
        userHasItem: json["user_has_item"],
        ratings: json["ratings"] == null
            ? null
            : List<dynamic>.from(json["ratings"].map((x) => x)),
        avgRating: json["avg_rating"],
        productInventorySet: json["product_inventory_set"],
        additionalInfoStore: json["additional_info_store"] == null ||
                json["additional_info_store"] is List
            ? null
            : Map.from(json["additional_info_store"]).map((k, v) =>
                MapEntry<String, AdditionalInfoStore>(
                    k, AdditionalInfoStore.fromJson(v))),
        allUnits: json["all_units"],
        maximumAvailablePrice: json["maximum_available_price"],
        minPrice: json["min_price"],
        maxPrice: json["max_price"],
        allTags: json["all_tags"] == null
            ? null
            : List<Tag>.from(json["all_tags"].map((x) => Tag.fromJson(x))),
        productColors: json["productColors"] == null
            ? null
            : List<ProductColor>.from(
                json["productColors"].map((x) => ProductColor.fromJson(x))),
        productSizes: json["productSizes"] == null
            ? null
            : List<ProductColor>.from(
                json["productSizes"].map((x) => ProductColor.fromJson(x))),
        settingText: json["setting_text"] == null
            ? null
            : SettingText.fromJson(json["setting_text"]),
        userRatedAlready: json["user_rated_already"],
        productDeliveryOption: json["product_delivery_option"] == null
            ? null
            : List<ProductDeliveryOption>.from(json["product_delivery_option"]
                .map((x) => ProductDeliveryOption.fromJson(x))),
      );
}

class AdditionalInfoStore {
  AdditionalInfoStore({
    required this.pidId,
    required this.additionalPrice,
    required this.stockCount,
    required this.image,
  });

  dynamic pidId;
  double additionalPrice;
  dynamic stockCount;
  String? image;

  factory AdditionalInfoStore.fromJson(Map<String, dynamic> json) =>
      AdditionalInfoStore(
        pidId: json["pid_id"],
        additionalPrice: json["additional_price"] is String
            ? double.parse(json["additional_price"])
            : json["additional_price"].toDouble(),
        stockCount: json["stock_count"] is String
            ? int.tryParse(json["stock_count"]) ?? 0
            : json["stock_count"].toInt(),
        image: json["image"],
      );
}

class Tag {
  Tag({
    required this.id,
    required this.tagName,
    required this.productId,
  });

  dynamic id;
  String tagName;
  dynamic productId;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"],
        tagName: json["tag_name"],
        productId: json["product_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tag_name": tagName,
        "product_id": productId,
      };
}

class AllUnit {
  AllUnit({
    required this.id,
    required this.productId,
    required this.unitId,
    required this.quantity,
  });

  dynamic id;
  dynamic productId;
  dynamic unitId;
  dynamic quantity;

  factory AllUnit.fromJson(Map<String, dynamic> json) => AllUnit(
        id: json["id"],
        productId: json["product_id"],
        unitId: json["unit_id"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "unit_id": unitId,
        "quantity": quantity,
      };
}

class AvailableAttributes {
  AvailableAttributes({
    required this.mayo,
    required this.cheese,
  });

  List<String>? mayo;
  List<String>? cheese;

  factory AvailableAttributes.fromJson(Map<String, dynamic> json) =>
      AvailableAttributes(
        mayo: List<String>.from(json["Mayo"].map((x) => x)),
        cheese: List<String>.from(json["Cheese"].map((x) => x)),
      );
}

class ProductDetailsModelProduct {
  ProductDetailsModelProduct({
    this.id,
    this.name,
    this.slug,
    this.summary,
    this.description,
    this.imageId,
    this.price,
    this.salePrice,
    this.cost,
    this.badgeId,
    this.brandId,
    this.statusId,
    this.productType,
    this.soldCount,
    this.minPurchase,
    this.maxPurchase,
    this.isRefundable,
    this.isInHouse,
    this.isInventoryWarnAble,
    this.deletedAt,
    this.adminId,
    this.vendorId,
    this.reviewsAvgRating,
    this.reviewsCount,
    this.image,
    this.badge,
    this.brand,
    this.uom,
    this.category,
    this.subCategory,
    this.childCategory,
    this.tag,
    this.color,
    this.size,
    this.campaignProduct,
    this.inventoryDetail,
    this.reviews,
    this.inventory,
    this.galleryImages,
    this.productDeliveryOption,
    this.campaignSoldProduct,
    this.vendor,
    this.randomKey,
    this.randomSecret,
  });

  dynamic id;
  String? name;
  String? slug;
  String? summary;
  String? description;
  String? imageId;
  dynamic price;
  dynamic salePrice;
  dynamic cost;
  dynamic badgeId;
  dynamic brandId;
  dynamic statusId;
  dynamic productType;
  dynamic soldCount;
  dynamic minPurchase;
  dynamic maxPurchase;
  dynamic isRefundable;
  dynamic isInHouse;
  dynamic isInventoryWarnAble;
  dynamic deletedAt;
  dynamic adminId;
  dynamic vendorId;
  double? reviewsAvgRating;
  dynamic reviewsCount;
  String? image;
  dynamic badge;
  dynamic brand;
  dynamic randomKey;
  dynamic randomSecret;
  dynamic uom;
  Category? category;
  Category? subCategory;
  List<ChildCategory>? childCategory;
  List<Tag>? tag;
  List<ProductColor>? color;
  List<ProductColor>? size;
  CampaignProduct? campaignProduct;
  dynamic inventoryDetail;
  List<Review>? reviews;
  dynamic inventory;
  List<String>? galleryImages;
  List<ProductDeliveryOption>? productDeliveryOption;
  CampaignSoldProduct? campaignSoldProduct;
  Vendor? vendor;

  factory ProductDetailsModelProduct.fromJson(Map<String, dynamic> json) =>
      ProductDetailsModelProduct(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        randomKey: json["random_key"],
        randomSecret: json["random_secret"],
        summary: json["summary"],
        description: json["description"],
        imageId: json["image_id"],
        price: json["price"] is String
            ? num.parse(json["price"]).toDouble()
            : json["price"]?.toDouble(),
        salePrice: json["sale_price"] is String
            ? num.parse(json["sale_price"]).toDouble()
            : json["sale_price"].toDouble(),
        cost: json["cost"],
        badgeId: json["badge_id"],
        brandId: json["brand_id"],
        statusId: json["status_id"],
        productType: json["product_type"],
        soldCount: json["sold_count"],
        minPurchase: json["min_purchase"],
        maxPurchase: json["max_purchase"],
        isRefundable: json["is_refundable"],
        isInHouse: json["is_in_house"],
        isInventoryWarnAble: json["is_inventory_warn_able"],
        deletedAt: json["deleted_at"],
        adminId: json["admin_id"],
        vendorId: json["vendor_id"],
        reviewsAvgRating: json["reviews_avg_rating"] is String
            ? double.parse(json["reviews_avg_rating"])
            : json["reviews_avg_rating"]?.toDouble(),
        reviewsCount: json["reviews_count"],
        image: json["image"],
        badge: json["badge"],
        uom: json["uom"],
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        subCategory: json["sub_category"] == null
            ? null
            : Category.fromJson(json["sub_category"]),
        childCategory: json["child_category"] == null
            ? null
            : List<ChildCategory>.from(
                json["child_category"].map((x) => ChildCategory.fromJson(x))),
        tag: json["tag"] == null
            ? null
            : List<Tag>.from(json["tag"].map((x) => Tag.fromJson(x))),
        brand: json["brand"]?["name"],
        color: json["color"] == null
            ? null
            : List<ProductColor>.from(
                json["color"].map((x) => ProductColor.fromJson(x))),
        size: json["size"] == null
            ? null
            : List<ProductColor>.from(
                json["size"].map((x) => ProductColor.fromJson(x))),
        campaignProduct: json["campaign_product"] == null
            ? null
            : CampaignProduct.fromJson(json["campaign_product"]),
        inventoryDetail: json["inventory_detail"],
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
        inventory: json["inventory"],
        galleryImages:
            List<String>.from(json["gallery_images"].map((x) => x["image"])),
        productDeliveryOption: json["product_delivery_option"] == null
            ? null
            : List<ProductDeliveryOption>.from(json["product_delivery_option"]
                .map((x) => ProductDeliveryOption.fromJson(x))),
        campaignSoldProduct: json["campaign_sold_product"] == null
            ? null
            : CampaignSoldProduct.fromJson(json["campaign_sold_product"]),
        vendor: json["vendor"] == null ? null : Vendor.fromJson(json["vendor"]),
      );
}

class ChildCategory {
  ChildCategory({
    this.id,
    required this.name,
    this.image,
  });
  dynamic id;
  String? name;
  dynamic image;

  factory ChildCategory.fromJson(Map<String, dynamic> json) => ChildCategory(
        id: json['id'],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
      };
}

class CampaignProduct {
  CampaignProduct({
    required this.id,
    required this.productId,
    required this.campaignId,
    required this.campaignPrice,
    required this.unitsForSale,
    required this.startDate,
    required this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic productId;
  dynamic campaignId;
  double campaignPrice;
  dynamic unitsForSale;
  DateTime startDate;
  DateTime? endDate;
  dynamic createdAt;
  dynamic updatedAt;

  factory CampaignProduct.fromJson(Map<String, dynamic> json) =>
      CampaignProduct(
        id: json["id"],
        productId: json["product_id"],
        campaignId: json["campaign_id"],
        campaignPrice: json["campaign_price"] is String
            ? double.parse(json["campaign_price"])
            : json["campaign_price"].toDouble(),
        unitsForSale: json["units_for_sale"],
        startDate: DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "campaign_id": campaignId,
        "campaign_price": campaignPrice,
        "units_for_sale": unitsForSale,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class CampaignSoldProduct {
  CampaignSoldProduct({
    required this.id,
    required this.productId,
    required this.soldCount,
    required this.totalAmount,
  });

  dynamic id;
  dynamic productId;
  dynamic soldCount;
  dynamic totalAmount;

  factory CampaignSoldProduct.fromJson(Map<String, dynamic> json) =>
      CampaignSoldProduct(
        id: json["id"],
        productId: json["product_id"],
        soldCount: json["sold_count"],
        totalAmount: json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "sold_count": soldCount,
        "total_amount": totalAmount,
      };
}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
  });

  dynamic id;
  dynamic name;
  dynamic slug;
  dynamic description;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "description": description,
      };
}

class ProductColor {
  ProductColor({
    required this.id,
    required this.name,
    this.colorCode,
    this.sizeCode,
  });

  dynamic id;
  String name;
  String? colorCode;
  String? sizeCode;

  factory ProductColor.fromJson(Map<String, dynamic> json) => ProductColor(
        id: json["id"],
        name: json["name"],
        colorCode: json["color_code"],
        sizeCode: json["size_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "color_code": colorCode,
        "size_code": sizeCode,
      };
}

class Inventory {
  Inventory({
    required this.id,
    required this.productId,
    required this.sku,
    required this.stockCount,
    required this.soldCount,
  });

  dynamic id;
  dynamic productId;
  dynamic sku;
  int stockCount;
  dynamic soldCount;

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
        id: json["id"],
        productId: json["product_id"],
        sku: json["sku"],
        stockCount: json["stock_count"] is String
            ? int.tryParse(json["stock_count"]) ?? 0
            : json["stock_count"].toInt(),
        soldCount: json["sold_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "sku": sku,
        "stock_count": stockCount,
        "sold_count": soldCount,
      };
}

class InventoryDetail {
  InventoryDetail({
    required this.id,
    required this.productInventoryId,
    required this.productId,
    required this.color,
    required this.size,
    required this.hash,
    required this.additionalPrice,
    required this.addCost,
    this.image,
    required this.stockCount,
    required this.soldCount,
    required this.attribute,
    this.attrImage,
    this.productColor,
    required this.productSize,
  });

  dynamic id;
  dynamic productInventoryId;
  dynamic productId;
  String color;
  String size;
  String hash;
  dynamic additionalPrice;
  dynamic addCost;
  dynamic image;
  dynamic stockCount;
  dynamic soldCount;
  List<Attribute> attribute;
  dynamic attrImage;
  ProductColor? productColor;
  ProductColor productSize;

  factory InventoryDetail.fromJson(Map<String, dynamic> json) =>
      InventoryDetail(
        id: json["id"],
        productInventoryId: json["product_inventory_id"],
        productId: json["product_id"],
        color: json["color"],
        size: json["size"],
        hash: json["hash"],
        additionalPrice: json["additional_price"],
        addCost: json["add_cost"],
        image: json["image"],
        stockCount: json["stock_count"],
        soldCount: json["sold_count"],
        attribute: List<Attribute>.from(
            json["attribute"].map((x) => Attribute.fromJson(x))),
        attrImage: json["attr_image"],
        productColor: json["product_color"] == null
            ? null
            : ProductColor.fromJson(json["product_color"]),
        productSize: ProductColor.fromJson(json["product_size"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_inventory_id": productInventoryId,
        "product_id": productId,
        "color": color,
        "size": size,
        "hash": hash,
        "additional_price": additionalPrice,
        "add_cost": addCost,
        "image": image,
        "stock_count": stockCount,
        "sold_count": soldCount,
        "attribute": List<dynamic>.from(attribute.map((x) => x.toJson())),
        "attr_image": attrImage?.toJson(),
        "product_color": productColor?.toJson(),
        "product_size": productSize.toJson(),
      };
}

class Attribute {
  Attribute({
    required this.id,
    required this.productId,
    required this.inventoryDetailsId,
    required this.attributeName,
    required this.attributeValue,
  });

  dynamic id;
  dynamic productId;
  dynamic inventoryDetailsId;
  String attributeName;
  String attributeValue;

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        id: json["id"],
        productId: json["product_id"],
        inventoryDetailsId: json["inventory_details_id"],
        attributeName: json["attribute_name"],
        attributeValue: json["attribute_value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "inventory_details_id": inventoryDetailsId,
        "attribute_name": attributeName,
        "attribute_value": attributeValue,
      };
}

class ProductDeliveryOption {
  ProductDeliveryOption({
    required this.id,
    required this.icon,
    required this.title,
    required this.subTitle,
    this.deletedAt,
    required this.laravelThroughKey,
  });

  dynamic id;
  String icon;
  String title;
  String subTitle;
  dynamic deletedAt;
  dynamic laravelThroughKey;

  factory ProductDeliveryOption.fromJson(Map<String, dynamic> json) =>
      ProductDeliveryOption(
        id: json["id"],
        icon: json["icon"],
        title: json["title"],
        subTitle: json["sub_title"],
        deletedAt: json["deleted_at"],
        laravelThroughKey: json["laravel_through_key"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "icon": icon,
        "title": title,
        "sub_title": subTitle,
        "deleted_at": deletedAt,
        "laravel_through_key": laravelThroughKey,
      };
}

class Review {
  Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.rating,
    required this.reviewText,
    required this.createdAt,
    this.updatedAt,
    this.user,
  });

  dynamic id;
  dynamic productId;
  dynamic userId;
  int rating;
  String? reviewText;
  DateTime createdAt;
  dynamic updatedAt;
  User? user;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        productId: json["product_id"],
        userId: json["user_id"],
        rating: json["rating"] is! num
            ? num.tryParse(json["rating"].toString())?.toInt() ?? 0
            : json["rating"].toInt(),
        reviewText: json["review_msg"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );
}

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.emailVerified,
    required this.emailVerifyToken,
    required this.phone,
    required this.address,
    required this.state,
    required this.city,
    required this.zipcode,
    required this.country,
    required this.image,
    this.facebookId,
    this.googleId,
    required this.profileImage,
  });

  dynamic id;
  String? name;
  String? email;
  String? username;
  String? emailVerified;
  String? emailVerifyToken;
  String? phone;
  String? address;
  String? state;
  String? city;
  String? zipcode;
  String? country;
  String? image;
  dynamic facebookId;
  dynamic googleId;
  String? profileImage;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        username: json["username"],
        emailVerified: json["email_verified"],
        emailVerifyToken: json["email_verify_token"],
        phone: json["phone"],
        address: json["address"],
        state: json["state"],
        city: json["city"],
        zipcode: json["zipcode"],
        country: json["country"],
        image: json["image"],
        facebookId: json["facebook_id"],
        googleId: json["google_id"],
        profileImage: json["image"],
      );
}

class ProfileImage {
  ProfileImage({
    required this.id,
    required this.path,
    required this.title,
    this.alt,
  });

  dynamic id;
  String path;
  String title;
  dynamic alt;

  factory ProfileImage.fromJson(Map<String, dynamic> json) => ProfileImage(
        id: json["id"],
        path: json["path"],
        title: json["title"],
        alt: json["alt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "path": path,
        "title": title,
        "alt": alt,
      };
}

class Vendor {
  Vendor({
    this.id,
    this.ownerName,
    this.businessName,
    this.description,
    this.businessTypeId,
    this.statusId,
    this.deletedAt,
    this.username,
    this.imageId,
    this.productCount,
    this.status,
    this.product,
    this.vendorAddress,
    this.image,
    this.createdAt,
  });

  dynamic id;
  String? ownerName;
  String? businessName;
  String? description;
  dynamic businessTypeId;
  dynamic statusId;
  dynamic deletedAt;
  dynamic username;
  dynamic imageId;
  dynamic productCount;
  dynamic status;
  dynamic image;
  List<ProductElement?>? product;
  VendorAddress? vendorAddress;
  DateTime? createdAt;

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
      id: json["id"],
      ownerName: json["owner_name"],
      businessName: json["business_name"],
      description: json["description"],
      businessTypeId: json["business_type_id"],
      statusId: json["status_id"],
      deletedAt: json["deleted_at"],
      username: json["username"],
      imageId: json["image_id"],
      productCount: json["product_count"],
      status: Status.fromJson(json["status"]),
      product: json["product"] == null
          ? null
          : List<ProductElement?>.from(
              json["product"].map((x) => ProductElement.fromJson(x))),
      vendorAddress: VendorAddress.fromJson(json["vendor_address"]),
      createdAt: DateTime.parse(json["created_at"]),
      image: json["image"]);
}

class ProductElement {
  ProductElement({
    required this.prdId,
    required this.title,
    required this.imgUrl,
    required this.campaignPercentage,
    required this.price,
    required this.discountPrice,
    required this.badge,
    required this.campaignProduct,
    required this.stockCount,
    required this.avgRatting,
    required this.isCartAble,
    required this.vendorId,
    required this.vendorName,
    required this.categoryId,
    required this.subCategoryId,
    required this.childCategoryIds,
    this.endDate,
    this.randomKey,
    this.randomSecret,
    this.campaignStock,
  });

  dynamic prdId;
  String? title;
  String? imgUrl;
  double? campaignPercentage;
  double price;
  double? discountPrice;
  String? badge;
  dynamic campaignProduct;
  dynamic stockCount;
  double avgRatting;
  dynamic isCartAble;
  dynamic vendorId;
  dynamic vendorName;
  dynamic categoryId;
  dynamic subCategoryId;
  List<dynamic>? childCategoryIds;
  DateTime? endDate;
  dynamic randomKey;
  dynamic randomSecret;
  dynamic campaignStock;

  factory ProductElement.fromJson(Map<String, dynamic> json) => ProductElement(
        prdId: json["prd_id"],
        title: json["title"],
        imgUrl: json["img_url"],
        campaignPercentage: json["campaign_percentage"] is String
            ? double.tryParse(json["campaign_percentage"])
            : json["campaign_percentage"]?.toDouble(),
        price: json["price"] is String
            ? double.tryParse(json["price"])
            : json["price"].toDouble(),
        discountPrice: json["discount_price"] is String
            ? double.tryParse(json["discount_price"])
            : json["discount_price"]?.toDouble(),
        badge: json["badge"]['badge_name'],
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
        randomKey: json["random_key"],
        randomSecret: json["random_secret"],
        endDate: json["end_date"] == null
            ? null
            : DateTime.tryParse(json["end_date"]),
        childCategoryIds:
            List<int>.from(json["child_category_ids"].map((x) => x)),
      );
}

class Status {
  Status({
    required this.id,
    required this.name,
    this.deletedAt,
  });

  dynamic id;
  String? name;
  dynamic deletedAt;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json["id"],
        name: json["name"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "deleted_at": deletedAt,
      };
}

class VendorAddress {
  VendorAddress({
    required this.id,
    required this.vendorId,
    required this.countryId,
    required this.stateId,
    required this.cityId,
    required this.zipCode,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.country,
  });

  dynamic id;
  dynamic vendorId;
  dynamic countryId;
  dynamic stateId;
  dynamic cityId;
  String? zipCode;
  String? address;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  Country country;

  factory VendorAddress.fromJson(Map<String, dynamic> json) => VendorAddress(
        id: json["id"],
        vendorId: json["vendor_id"],
        countryId: json["country_id"],
        stateId: json["state_id"],
        cityId: json["city_id"],
        zipCode: json["zip_code"],
        address: json["address"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        country: Country.fromJson(json["country"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vendor_id": vendorId,
        "country_id": countryId,
        "state_id": stateId,
        "city_id": cityId,
        "zip_code": zipCode,
        "address": address,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "country": country.toJson(),
      };
}

class Country {
  Country({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  dynamic id;
  String? name;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class ProductInventorySet {
  ProductInventorySet({
    required this.mayo,
    this.color,
    required this.size,
    required this.cheese,
    required this.hash,
  });

  String mayo;
  String? color;
  String size;
  String cheese;
  String hash;

  factory ProductInventorySet.fromJson(Map<String, dynamic> json) =>
      ProductInventorySet(
        mayo: json["Mayo"],
        color: json["Color"],
        size: json["Size"],
        cheese: json["Cheese"],
        hash: json["hash"],
      );

  Map<String, dynamic> toJson() => {
        "Mayo": mayo,
        "Color": color,
        "Size": size,
        "Cheese": cheese,
        "hash": hash,
      };
}

class SettingText {
  SettingText({
    required this.productInStockText,
    required this.productOutOfStockText,
    required this.additionalInformationText,
    required this.reviewsText,
    required this.yourReviewsText,
    required this.writeYourFeedbackText,
    required this.postYourFeedbackText,
  });

  String productInStockText;
  String productOutOfStockText;
  String additionalInformationText;
  String reviewsText;
  String yourReviewsText;
  String writeYourFeedbackText;
  String postYourFeedbackText;

  factory SettingText.fromJson(Map<String, dynamic> json) => SettingText(
        productInStockText: json["product_in_stock_text"],
        productOutOfStockText: json["product_out_of_stock_text"],
        additionalInformationText: json["additional_information_text"],
        reviewsText: json["reviews_text"],
        yourReviewsText: json["your_reviews_text"],
        writeYourFeedbackText: json["write_your_feedback_text"],
        postYourFeedbackText: json["post_your_feedback_text"],
      );

  Map<String, dynamic> toJson() => {
        "product_in_stock_text": productInStockText,
        "product_out_of_stock_text": productOutOfStockText,
        "additional_information_text": additionalInformationText,
        "reviews_text": reviewsText,
        "your_reviews_text": yourReviewsText,
        "write_your_feedback_text": writeYourFeedbackText,
        "post_your_feedback_text": postYourFeedbackText,
      };
}
