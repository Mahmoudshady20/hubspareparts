import 'Banner.dart';
import 'Logo.dart';

/// id : 67
/// name : "Telemecanique"
/// slug : "telemecanique"
/// banner_id : 1759
/// title : "Telemecanique"
/// description : "Telemecanique By Schneider"
/// created_at : "2025-03-07T01:00:10.000000Z"
/// updated_at : "2025-03-07T01:00:10.000000Z"
/// deleted_at : null
/// image_url : "https://hubspareparts.com/assets/uploads/media-uploader/telemecanique-se-logo-01741309196.png"
/// logo : {"id":1759,"title":"telemecanique-se-logo_0.png","path":"telemecanique-se-logo-01741309196.png","alt":null,"size":"42.5 KB","dimensions":"406 x 126 pixels","user_id":null,"created_at":"2025-03-07T00:59:56.000000Z","updated_at":"2025-03-07T00:59:56.000000Z","vendor_id":null}
/// banner : {"id":1759,"title":"telemecanique-se-logo_0.png","path":"telemecanique-se-logo-01741309196.png","alt":null,"size":"42.5 KB","dimensions":"406 x 126 pixels","user_id":null,"created_at":"2025-03-07T00:59:56.000000Z","updated_at":"2025-03-07T00:59:56.000000Z","vendor_id":null}

class Brands {
  Brands({
    this.id,
    this.name,
    this.slug,
    this.bannerId,
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.imageUrl,
    this.logo,
    this.banner,
  });

  Brands.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    bannerId = json['banner_id'];
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    imageUrl = json['image_url'];
    logo = json['logo'] != null ? Logo.fromJson(json['logo']) : null;
    banner = json['banner'] != null ? Banner.fromJson(json['banner']) : null;
  }
  num? id;
  String? name;
  String? slug;
  num? bannerId;
  String? title;
  String? description;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? imageUrl;
  Logo? logo;
  Banner? banner;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['slug'] = slug;
    map['banner_id'] = bannerId;
    map['title'] = title;
    map['description'] = description;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    map['image_url'] = imageUrl;
    if (logo != null) {
      map['logo'] = logo?.toJson();
    }
    if (banner != null) {
      map['banner'] = banner?.toJson();
    }
    return map;
  }
}
