/// id : 1
/// name : "ABB"
/// slug : "abb"
/// title : "ABB Electric"
/// logo : null

class BrandFilter {
  BrandFilter({
    this.id,
    this.name,
    this.slug,
    this.title,
    this.logo,
  });

  BrandFilter.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    title = json['title'];
    logo = json['logo'];
  }
  num? id;
  String? name;
  String? slug;
  String? title;
  dynamic logo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['slug'] = slug;
    map['title'] = title;
    map['logo'] = logo;
    return map;
  }
}
