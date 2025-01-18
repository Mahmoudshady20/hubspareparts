// To parse this JSON data, do
//
//     final vendorDetailListModel = vendorDetailListModelFromJson(jsonString);

import 'dart:convert';

VendorDetailListModel vendorDetailListModelFromJson(String str) =>
    VendorDetailListModel.fromJson(json.decode(str));

String vendorDetailListModelToJson(VendorDetailListModel data) =>
    json.encode(data.toJson());

class VendorDetailListModel {
  VendorDetailListModel({
    required this.vendors,
    required this.defaultVendor,
  });

  List<Vendor> vendors;
  DefaultVendor defaultVendor;

  factory VendorDetailListModel.fromJson(Map<String, dynamic> json) =>
      VendorDetailListModel(
        vendors:
            List<Vendor>.from(json["vendors"].map((x) => Vendor.fromJson(x))),
        defaultVendor: DefaultVendor.fromJson(json["default_vendor"]),
      );

  Map<String, dynamic> toJson() => {
        "vendors": List<dynamic>.from(vendors.map((x) => x.toJson())),
        "default_vendor": defaultVendor.toJson(),
      };
}

class DefaultVendor {
  DefaultVendor({
    required this.shippingMethods,
    required this.adminShop,
  });

  List<ShippingMethod> shippingMethods;
  AdminShop adminShop;

  factory DefaultVendor.fromJson(Map<String, dynamic> json) => DefaultVendor(
        shippingMethods: List<ShippingMethod>.from(
            json["shipping_methods"].map((x) => ShippingMethod.fromJson(x))),
        adminShop: AdminShop.fromJson(json["adminShop"]),
      );

  Map<String, dynamic> toJson() => {
        "shipping_methods":
            List<dynamic>.from(shippingMethods.map((x) => x.toJson())),
        "adminShop": adminShop.toJson(),
      };
}

class AdminShop {
  AdminShop({
    required this.id,
    required this.storeName,
  });

  dynamic id;
  String storeName;

  factory AdminShop.fromJson(Map<String, dynamic> json) => AdminShop(
        id: json["id"],
        storeName: json["store_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "store_name": storeName,
      };
}

class ShippingMethod {
  ShippingMethod({
    required this.id,
    required this.zoneId,
    required this.title,
    required this.cost,
    required this.statusId,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
    required this.zone,
    this.vendorId,
  });

  dynamic id;
  dynamic zoneId;
  String title;
  double cost;
  dynamic statusId;
  bool isDefault;
  dynamic createdAt;
  dynamic updatedAt;
  Zone? zone;
  dynamic vendorId;

  factory ShippingMethod.fromJson(Map<String, dynamic> json) => ShippingMethod(
        id: json["id"],
        zoneId: json["zone_id"],
        title: json["title"],
        cost: json["cost"] is String
            ? double.parse(json["cost"])
            : json["cost"]?.toDouble() ?? 0,
        statusId: json["status_id"],
        isDefault: json["is_default"] == 1,
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        zone: json["zone"] == null ? null : Zone.fromJson(json["zone"]),
        vendorId: json["vendor_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "zone_id": zoneId,
        "title": title,
        "cost": cost,
        "status_id": statusId,
        "is_default": isDefault,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "zone": zone!.toJson(),
        "vendor_id": vendorId,
      };
}

class Zone {
  Zone({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  dynamic id;
  String name;
  dynamic createdAt;
  dynamic updatedAt;

  factory Zone.fromJson(Map<String, dynamic> json) => Zone(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Vendor {
  Vendor({
    required this.id,
    required this.ownerName,
    required this.businessName,
    required this.status,
    required this.shippingMethod,
  });

  dynamic id;
  dynamic ownerName;
  String businessName;
  dynamic status;
  List<ShippingMethod>? shippingMethod;

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        id: json["id"],
        ownerName: json["owner_name"],
        businessName: json["business_name"],
        status: json["status"],
        shippingMethod: json["shipping_method"] == null
            ? null
            : List<ShippingMethod>.from(
                json["shipping_method"].map((x) => ShippingMethod.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "owner_name": ownerName,
        "business_name": businessName,
        "status": status,
        "shipping_method":
            List<dynamic>.from(shippingMethod!.map((x) => x.toJson())),
      };
}
