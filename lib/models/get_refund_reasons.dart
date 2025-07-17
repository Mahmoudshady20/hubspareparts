/// code : 200
/// status : true
/// message : "Refund reasons retrieved"
/// data : [{"id":3,"name":"المنتج به عيوب"},{"id":4,"name":"لا اريد هذا المنتج"},{"id":5,"name":"وجدت نفس المنتج بسعر افضل"},{"id":6,"name":"جوده سيئه"},{"id":7,"name":"طلبت عن طريق الخطأ"},{"id":8,"name":"تأخر الشحن"}]

class GetRefundReasons {
  GetRefundReasons({
      this.code, 
      this.status, 
      this.message, 
      this.dataa,});

  GetRefundReasons.fromJson(dynamic json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      dataa = [];
      json['data'].forEach((v) {
        dataa?.add(Data.fromJson(v));
      });
    }
  }
  num? code;
  bool? status;
  String? message;
  List<Data>? dataa;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['status'] = status;
    map['message'] = message;
    if (dataa != null) {
      map['data'] = dataa?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 3
/// name : "المنتج به عيوب"

class Data {
  Data({
      this.id, 
      this.name,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  num? id;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}