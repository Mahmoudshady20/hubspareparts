/// id : 1759
/// title : "telemecanique-se-logo_0.png"
/// path : "telemecanique-se-logo-01741309196.png"
/// alt : null
/// size : "42.5 KB"
/// dimensions : "406 x 126 pixels"
/// user_id : null
/// created_at : "2025-03-07T00:59:56.000000Z"
/// updated_at : "2025-03-07T00:59:56.000000Z"
/// vendor_id : null

class Banner {
  Banner({
    this.id,
    this.title,
    this.path,
    this.alt,
    this.size,
    this.dimensions,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.vendorId,
  });

  Banner.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    path = json['path'];
    alt = json['alt'];
    size = json['size'];
    dimensions = json['dimensions'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    vendorId = json['vendor_id'];
  }
  num? id;
  String? title;
  String? path;
  dynamic alt;
  String? size;
  String? dimensions;
  dynamic userId;
  String? createdAt;
  String? updatedAt;
  dynamic vendorId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['path'] = path;
    map['alt'] = alt;
    map['size'] = size;
    map['dimensions'] = dimensions;
    map['user_id'] = userId;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['vendor_id'] = vendorId;
    return map;
  }
}
