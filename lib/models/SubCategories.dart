import 'ChildCategories.dart';

/// id : 105
/// name : "Power Contactor"
/// image : null
/// child_categories : [{"id":729,"name":"Electro-mechanical Power Contactor","image":null},{"id":730,"name":"Solid State Power Contactor","image":null},{"id":755,"name":"Power Contactor Control Voltage (220VAC/50HZ)","image":null},{"id":1223,"name":"Solid State Contactor AUX. Contact","image":null}]

class SubCategories {
  SubCategories({
    this.id,
    this.name,
    this.image,
    this.childCategories,
  });

  SubCategories.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    if (json['child_categories'] != null) {
      childCategories = [];
      json['child_categories'].forEach((v) {
        childCategories?.add(ChildCategories.fromJson(v));
      });
    }
  }
  num? id;
  String? name;
  dynamic image;
  List<ChildCategories>? childCategories;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    if (childCategories != null) {
      map['child_categories'] =
          childCategories?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
