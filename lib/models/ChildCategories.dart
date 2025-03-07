/// id : 729
/// name : "Electro-mechanical Power Contactor"
/// image : null

class ChildCategories {
  ChildCategories({
    this.id,
    this.name,
    this.image,
  });

  ChildCategories.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
  num? id;
  String? name;
  dynamic image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    return map;
  }
}
