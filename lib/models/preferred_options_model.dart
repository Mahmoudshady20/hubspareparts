/// code : 200
/// status : true
/// message : "Refund preferred options retrieved"
/// data : [{"id":1,"name":"Instapay account","fields":"a:2:{i:0;s:15:\"Instapay number\";i:1;s:10:\"Referrence\";}"},{"id":2,"name":"Bank Payment","fields":"a:4:{i:0;s:14:\"Account Number\";i:1;s:14:\"Routing Number\";i:2;s:6:\"Branch\";i:3;s:9:\"Bank Name\";}"},{"id":3,"name":"Paypal","fields":"a:1:{i:0;s:7:\"account\";}"}]

class PreferredOptionsModel {
  PreferredOptionsModel({
      this.code, 
      this.status, 
      this.message, 
      this.data,});

  PreferredOptionsModel.fromJson(dynamic json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  num? code;
  bool? status;
  String? message;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// name : "Instapay account"
/// fields : "a:2:{i:0;s:15:\"Instapay number\";i:1;s:10:\"Referrence\";}"

class Data {
  Data({
      this.id, 
      this.name, 
      this.fields,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    fields = json['fields'];
  }
  num? id;
  String? name;
  String? fields;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['fields'] = fields;
    return map;
  }

}