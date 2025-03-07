/// id : 1
/// name : "0–10 kVA"
/// code : "0–10 kVA\n"
/// slug : "0–10 kVA\n"

class PowerRating {
  PowerRating({
    this.id,
    this.name,
    this.code,
    this.slug,
  });

  PowerRating.fromJson(dynamic json) {
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
