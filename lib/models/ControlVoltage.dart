/// id : 4
/// name : "110 VAC , 50/60 HZ"
/// code : "110 VAC , 50/60 HZ"
/// slug : "110 VAC , 50/60 HZ"

class ControlVoltage {
  ControlVoltage({
    this.id,
    this.name,
    this.code,
    this.slug,
  });

  ControlVoltage.fromJson(dynamic json) {
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
