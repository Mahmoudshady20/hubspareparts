import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) =>
    OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) =>
    json.encode(data.toJson());

class OrderDetailsModel {
  OrderDetailsModel({
    required this.order,
    required this.paymentDetails,
    required this.orderTrack,
  });

  List<Order> order;
  PaymentDetails paymentDetails;
  OrderTrack orderTrack;

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailsModel(
        order: List<Order>.from(json["order"].map((x) => Order.fromJson(x))),
        paymentDetails: PaymentDetails.fromJson(json["payment_details"]),
        orderTrack: OrderTrack.fromJson(json["order_track"]),
      );

  Map<String, dynamic> toJson() => {
        "order": List<dynamic>.from(order.map((x) => x.toJson())),
        "payment_details": paymentDetails.toJson(),
        "order_track": orderTrack.toJson(),
      };
}

class Order {
  Order({
    this.id,
    this.orderId,
    this.vendorId,
    required this.totalAmount,
    required this.shippingCost,
    required this.taxAmount,
    this.orderAddressId,
    this.createdAt,
    this.updatedAt,
    this.orderNumber,
    required this.paymentStatus,
    required this.orderStatus,
    required this.order,
    required this.vendor,
    required this.orderItem,
  });

  dynamic id;
  dynamic orderId;
  dynamic vendorId;
  double totalAmount;
  double shippingCost;
  double taxAmount;
  dynamic orderAddressId;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic orderNumber;
  String paymentStatus;
  String orderStatus;
  PaymentDetails order;
  Vendor? vendor;
  List<OrderItem> orderItem;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        orderId: json["order_id"],
        vendorId: json["vendor_id"],
        totalAmount: json["total_amount"] is String
            ? double.parse(json["total_amount"])
            : json["total_amount"].toDouble(),
        shippingCost: json["shipping_cost"] is String
            ? double.parse(json["shipping_cost"])
            : json["shipping_cost"].toDouble(),
        taxAmount: json["tax_amount"] is String
            ? double.parse(json["tax_amount"])
            : json["tax_amount"].toDouble(),
        orderAddressId: json["order_address_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        orderNumber: json["order_number"],
        paymentStatus: json["payment_status"],
        orderStatus: json["order_status"],
        order: PaymentDetails.fromJson(json["order"]),
        vendor: json["vendor"] == null ? null : Vendor.fromJson(json["vendor"]),
        orderItem: List<OrderItem>.from(
            json["order_item"].map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "vendor_id": vendorId,
        "total_amount": totalAmount,
        "shipping_cost": shippingCost,
        "tax_amount": taxAmount,
        "order_address_id": orderAddressId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "order_number": orderNumber,
        "payment_status": paymentStatus,
        "order_status": orderStatus,
        "order": order.toJson(),
        "vendor": vendor?.toJson(),
        "order_item": List<dynamic>.from(orderItem.map((x) => x.toJson())),
      };
}

class PaymentDetails {
  PaymentDetails({
    this.id,
    this.coupon,
    required this.couponAmount,
    this.paymentTrack,
    this.paymentGateway,
    this.transactionId,
    this.orderStatus,
    this.paymentStatus,
    this.invoiceNumber,
    this.createdAt,
    this.updatedAt,
    this.userId,
    required this.address,
    required this.paymentMeta,
  });

  dynamic id;
  dynamic coupon;
  dynamic couponAmount;
  dynamic paymentTrack;
  dynamic paymentGateway;
  dynamic transactionId;
  String? orderStatus;
  String? paymentStatus;
  dynamic invoiceNumber;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic userId;
  Address? address;
  PaymentMeta? paymentMeta;

  factory PaymentDetails.fromJson(Map<String, dynamic> json) => PaymentDetails(
        id: json["id"],
        coupon: json["coupon"],
        couponAmount: json["coupon_amount"],
        paymentTrack: json["payment_track"],
        paymentGateway: json["payment_gateway"],
        transactionId: json["transaction_id"],
        orderStatus: json["order_status"],
        paymentStatus: json["payment_status"],
        invoiceNumber: json["invoice_number"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        userId: json["user_id"],
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        paymentMeta: json["payment_meta"] == null
            ? null
            : PaymentMeta.fromJson(json["payment_meta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "coupon": coupon,
        "coupon_amount": couponAmount,
        "payment_track": paymentTrack,
        "payment_gateway": paymentGateway,
        "transaction_id": transactionId,
        "order_status": orderStatus,
        "payment_status": paymentStatus,
        "invoice_number": invoiceNumber,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user_id": userId,
        "address": address?.toJson(),
        "payment_meta": paymentMeta?.toJson(),
      };
}

class Address {
  Address({
    this.id,
    this.orderId,
    this.name,
    this.email,
    this.phone,
    this.countryId,
    this.stateId,
    this.city,
    this.address,
    this.userId,
    this.zipcode,
    this.cityInfo,
    this.country,
    this.state,
  });

  dynamic id;
  dynamic orderId;
  String? name;
  String? email;
  dynamic phone;
  dynamic countryId;
  dynamic stateId;
  dynamic city;
  dynamic address;
  dynamic userId;
  dynamic zipcode;
  Loc? country;
  Loc? state;
  Loc? cityInfo;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
      id: json["id"],
      orderId: json["order_id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      countryId: json["country_id"],
      stateId: json["state_id"],
      city: json["city"],
      address: json["address"],
      userId: json["user_id"],
      zipcode: json["zipcode"],
      country: json["country"] == null ? null : Loc.fromJson(json["country"]),
      state: json["state"] == null ? null : Loc.fromJson(json["state"]),
      cityInfo:
          json["city_info"] == null ? null : Loc.fromJson(json["city_info"]));

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "name": name,
        "email": email,
        "phone": phone,
        "country_id": countryId,
        "state_id": stateId,
        "city": city,
        "address": address,
        "user_id": userId,
        "zipcode": zipcode,
      };
}

class PaymentMeta {
  PaymentMeta({
    this.id,
    this.orderId,
    required this.subTotal,
    required this.couponAmount,
    required this.shippingCost,
    required this.taxAmount,
    required this.totalAmount,
  });

  dynamic id;
  dynamic orderId;
  double subTotal;
  double couponAmount;
  double shippingCost;
  double taxAmount;
  double totalAmount;

  factory PaymentMeta.fromJson(Map<String, dynamic> json) => PaymentMeta(
        id: json["id"],
        orderId: json["order_id"],
        subTotal: json["sub_total"] is String
            ? double.parse(json["sub_total"])
            : json["sub_total"].toDouble(),
        couponAmount: json["coupon_amount"] is String
            ? double.parse(json["coupon_amount"])
            : json["coupon_amount"].toDouble(),
        shippingCost: json["shipping_cost"] is String
            ? double.parse(json["shipping_cost"])
            : json["shipping_cost"].toDouble(),
        taxAmount: json["tax_amount"] is String
            ? double.parse(json["tax_amount"])
            : json["tax_amount"].toDouble(),
        totalAmount: json["total_amount"] is String
            ? double.parse(json["total_amount"])
            : json["total_amount"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "sub_total": subTotal,
        "coupon_amount": couponAmount,
        "shipping_cost": shippingCost,
        "tax_amount": taxAmount,
        "total_amount": totalAmount,
      };
}

class OrderItem {
  OrderItem(
      {this.id,
      this.subOrderId,
      this.orderId,
      this.productId,
      this.variantId,
      required this.quantity,
      required this.price,
      required this.salePrice,
      required this.product,
      required this.attribute,
      required this.variantPrice,
      this.variantImage,
      this.productColor,
      this.productSize});

  dynamic id;
  dynamic subOrderId;
  dynamic orderId;
  dynamic productId;
  dynamic variantId;
  num quantity;
  double price;
  double salePrice;
  Product product;
  List<Attribute> attribute;
  double variantPrice;
  String? variantImage;
  String? productColor;
  String? productSize;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["id"],
        subOrderId: json["sub_order_id"],
        orderId: json["order_id"],
        productId: json["product_id"],
        variantId: json["variant_id"],
        quantity: json["quantity"] is String
            ? num.tryParse(json["quantity"]) ?? 1
            : json["quantity"] ?? 1,
        price: json["price"] is String
            ? double.parse(json["price"])
            : json["price"].toDouble(),
        salePrice: json["sale_price"] is String
            ? double.parse(json["sale_price"])
            : json["sale_price"].toDouble(),
        product: Product.fromJson(json["product"]),
        attribute: json["variant"]?['attribute'] == null
            ? []
            : List<Attribute>.from(
                json["variant"]["attribute"].map((x) => Attribute.fromJson(x))),
        variantPrice: json["variant"]?['additional_price'] is String
            ? double.parse(json["variant"]?['additional_price'])
            : (json["variant"]?['additional_price'] ?? 0).toDouble(),
        variantImage: json["variant"]?['attr_image'],
        productColor: json["variant"]?['product_color']?['name'],
        productSize: json["variant"]?['product_size']?['name'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sub_order_id": subOrderId,
        "order_id": orderId,
        "product_id": productId,
        "variant_id": variantId,
        "quantity": quantity,
        "price": price,
        "sale_price": salePrice,
        "product": product.toJson(),
        "variant": attribute,
      };
}

class Product {
  Product({
    this.id,
    required this.name,
    this.slug,
    this.summary,
    this.description,
    this.imageId,
    required this.price,
    required this.salePrice,
    required this.cost,
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
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.adminId,
    this.vendorId,
    this.image,
    this.badge,
    this.uom,
    this.campaignProduct,
  });

  dynamic id;
  String name;
  dynamic slug;
  dynamic summary;
  dynamic description;
  dynamic imageId;
  double price;
  double salePrice;
  double cost;
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
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  dynamic adminId;
  dynamic vendorId;
  String? image;
  dynamic badge;
  dynamic uom;
  dynamic campaignProduct;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        summary: json["summary"],
        description: json["description"],
        imageId: json["image_id"],
        price: json["price"] is String
            ? double.parse(json["price"])
            : json["price"].toDouble(),
        salePrice: json["sale_price"] is String
            ? double.parse(json["sale_price"])
            : json["sale_price"].toDouble(),
        cost: json["cost"] is String
            ? double.parse(json["cost"])
            : json["cost"].toDouble(),
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
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
        adminId: json["admin_id"],
        vendorId: json["vendor_id"],
        image: json["image"],
        badge: json["badge"],
        uom: json["uom"],
        campaignProduct: json["campaign_product"]?['campaign_price'] is String
            ? double.parse(json["campaign_product"]?['campaign_price'])
            : json["campaign_product"]?['campaign_price']?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "summary": summary,
        "description": description,
        "image_id": imageId,
        "price": price,
        "sale_price": salePrice,
        "cost": cost,
        "badge_id": badgeId,
        "brand_id": brandId,
        "status_id": statusId,
        "product_type": productType,
        "sold_count": soldCount,
        "min_purchase": minPurchase,
        "max_purchase": maxPurchase,
        "is_refundable": isRefundable,
        "is_in_house": isInHouse,
        "is_inventory_warn_able": isInventoryWarnAble,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "admin_id": adminId,
        "vendor_id": vendorId,
        "image": image,
        "badge": badge.toJson(),
        "uom": uom.toJson(),
        "campaign_product": campaignProduct.toJson(),
      };
}

class CampaignProduct {
  CampaignProduct({
    this.id,
    this.productId,
    this.campaignId,
    required this.campaignPrice,
    this.unitsForSale,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic productId;
  dynamic campaignId;
  double campaignPrice;
  dynamic unitsForSale;
  dynamic startDate;
  dynamic endDate;
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
        startDate: json["start_date"],
        endDate: json["end_date"],
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
        "end_date": endDate.toIso8601String(),
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Variant {
  Variant({
    this.id,
    this.productInventoryId,
    this.productId,
    required this.color,
    required this.size,
    required this.hash,
    required this.additionalPrice,
    required this.addCost,
    required this.image,
    required this.stockCount,
    required this.soldCount,
    required this.attribute,
    required this.attrImage,
    required this.productColor,
    required this.productSize,
  });

  dynamic id;
  dynamic productInventoryId;
  dynamic productId;
  String color;
  String size;
  String hash;
  int additionalPrice;
  int addCost;
  dynamic image;
  dynamic stockCount;
  dynamic soldCount;
  List<Attribute> attribute;
  String attrImage;
  dynamic productColor;
  dynamic productSize;

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
        id: json["id"],
        productInventoryId: json["product_inventory_id"],
        productId: json["product_id"],
        color: json["color"],
        size: json["size"],
        hash: json["hash"],
        additionalPrice: json["additional_price"] is String
            ? double.parse(json["total_amount"])
            : json["total_amount"].toDouble(),
        addCost: json["add_cost"] is String
            ? double.parse(json["total_amount"])
            : json["total_amount"].toDouble(),
        image: json["image"],
        stockCount: json["stock_count"] is String
            ? int.tryParse(json["stock_count"]) ?? 0
            : json["stock_count"]?.toInt() ?? 0,
        soldCount: json["sold_count"],
        attribute: List<Attribute>.from(
            json["attribute"].map((x) => Attribute.fromJson(x))),
        attrImage: json["attr_image"],
        productColor: json["product_color"],
        productSize: json["product_size"],
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
        "attr_image": attrImage,
        "product_color": productColor.toJson(),
        "product_size": productSize.toJson(),
      };
}

class Attribute {
  Attribute({
    this.id,
    this.productId,
    this.inventoryDetailsId,
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

class Vendor {
  Vendor({
    this.id,
    this.ownerName,
    this.businessName,
    this.description,
    this.businessTypeId,
    this.statusId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.username,
    this.imageId,
    this.status,
  });

  dynamic id;
  String? ownerName;
  String? businessName;
  String? description;
  dynamic businessTypeId;
  dynamic statusId;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  String? username;
  dynamic imageId;
  dynamic status;

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        id: json["id"],
        ownerName: json["owner_name"],
        businessName: json["business_name"],
        description: json["description"],
        businessTypeId: json["business_type_id"],
        statusId: json["status_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        username: json["username"],
        imageId: json["image_id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "owner_name": ownerName,
        "business_name": businessName,
        "description": description,
        "business_type_id": businessTypeId,
        "status_id": statusId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "username": username,
        "image_id": imageId,
        "status": status.toJson(),
      };
}

class OrderTrack {
  OrderTrack({
    this.id,
    this.orderId,
    this.name,
    this.updatedBy,
    this.table,
  });

  dynamic id;
  dynamic orderId;
  String? name;
  dynamic updatedBy;
  dynamic table;

  factory OrderTrack.fromJson(Map<String, dynamic> json) => OrderTrack(
        id: json["id"],
        orderId: json["order_id"],
        name: json["name"],
        updatedBy: json["updated_by"],
        table: json["table"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "name": name,
        "updated_by": updatedBy,
        "table": table,
      };
}

class Loc {
  dynamic id;
  String? name;
  Loc({
    this.id,
    this.name,
  });
  factory Loc.fromJson(Map<String, dynamic> json) => Loc(
        id: json["id"],
        name: json["name"],
      );
}
