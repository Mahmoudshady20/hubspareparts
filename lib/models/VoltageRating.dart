/// id : 5
/// name : "11 KVAC"
/// code : "11 KVAC"
/// slug : "11 KVAC"

class VoltageRating {
  VoltageRating({
    this.id,
    this.name,
    this.code,
    this.slug,
  });

  VoltageRating.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    slug = json['slug'];
  }
  num? id;
  String? name;
  String? code;
  String? slug;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['code'] = code;
    map['slug'] = slug;
    return map;
  }
}
