/// code : 200
/// status : true
/// message : "Refund requested successfully"
/// data : []

class ResponseRefundRequest {
  ResponseRefundRequest({
      this.code, 
      this.status, 
      this.message, 
      this.data,});

  ResponseRefundRequest.fromJson(dynamic json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
    }
  }
  dynamic code;
  dynamic status;
  dynamic message;
  List<dynamic>? data;

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