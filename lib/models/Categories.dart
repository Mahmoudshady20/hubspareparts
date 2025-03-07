import 'SubCategories.dart';

/// id : 28
/// name : "Contactors"
/// image : "https://hubspareparts.com/assets/uploads/media-uploader/contactors1737328776.webp"
/// sub_categories : [{"id":105,"name":"Power Contactor","image":null,"child_categories":[{"id":729,"name":"Electro-mechanical Power Contactor","image":null},{"id":730,"name":"Solid State Power Contactor","image":null},{"id":755,"name":"Power Contactor Control Voltage (220VAC/50HZ)","image":null},{"id":1223,"name":"Solid State Contactor AUX. Contact","image":null}]},{"id":106,"name":"Auxiliary Contactor","image":null,"child_categories":[{"id":979,"name":"Electro-mechanical Auxiliary Contactor","image":null},{"id":980,"name":"Solid State Auxiliary Contactor","image":null},{"id":981,"name":"Auxiliary Contactor Control Voltage (220VAC/50HZ)","image":null}]},{"id":281,"name":"Accessories","image":null,"child_categories":[{"id":988,"name":"Aux. Contact","image":null}]}]

class Categories {
  Categories({
    this.id,
    this.name,
    this.image,
    this.subCategories,
  });

  Categories.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    if (json['sub_categories'] != null) {
      subCategories = [];
      json['sub_categories'].forEach((v) {
        subCategories?.add(SubCategories.fromJson(v));
      });
    }
  }
  num? id;
  String? name;
  String? image;
  List<SubCategories>? subCategories;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    if (subCategories != null) {
      map['sub_categories'] = subCategories?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
