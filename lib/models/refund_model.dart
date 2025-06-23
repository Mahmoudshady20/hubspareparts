/// code : 200
/// status : true
/// message : "Refund requests retrieved"
/// data : {"data":[{"id":48,"order_info":{"id":19,"status":"complete","amount":"$704.00"},"refund_info":{"id":48,"status":"Request sent","total_products":1}}],"links":{"self":"http://hubspareparts.test/api/v1/refund-requests/all"},"meta":{"pagination":{"total":1,"per_page":20,"current_page":1,"last_page":1,"from":1,"to":1}}}

class RefundModel {
  RefundModel({
      this.code, 
      this.status, 
      this.message, 
      this.data,});

  RefundModel.fromJson(dynamic json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  num? code;
  bool? status;
  String? message;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

/// data : [{"id":48,"order_info":{"id":19,"status":"complete","amount":"$704.00"},"refund_info":{"id":48,"status":"Request sent","total_products":1}}]
/// links : {"self":"http://hubspareparts.test/api/v1/refund-requests/all"}
/// meta : {"pagination":{"total":1,"per_page":20,"current_page":1,"last_page":1,"from":1,"to":1}}

class Data {
  Data({
      this.data, 
      this.links, 
      this.meta,});

  Data.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DataSub.fromJson(v));
      });
    }
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  List<DataSub>? data;
  Links? links;
  Meta? meta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    if (links != null) {
      map['links'] = links?.toJson();
    }
    if (meta != null) {
      map['meta'] = meta?.toJson();
    }
    return map;
  }

}

/// pagination : {"total":1,"per_page":20,"current_page":1,"last_page":1,"from":1,"to":1}

class Meta {
  Meta({
      this.pagination,});

  Meta.fromJson(dynamic json) {
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }
  Pagination? pagination;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (pagination != null) {
      map['pagination'] = pagination?.toJson();
    }
    return map;
  }

}

/// total : 1
/// per_page : 20
/// current_page : 1
/// last_page : 1
/// from : 1
/// to : 1

class Pagination {
  Pagination({
      this.total, 
      this.perPage, 
      this.currentPage, 
      this.lastPage, 
      this.from, 
      this.to,});

  Pagination.fromJson(dynamic json) {
    total = json['total'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    from = json['from'];
    to = json['to'];
  }
  num? total;
  num? perPage;
  num? currentPage;
  num? lastPage;
  num? from;
  num? to;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = total;
    map['per_page'] = perPage;
    map['current_page'] = currentPage;
    map['last_page'] = lastPage;
    map['from'] = from;
    map['to'] = to;
    return map;
  }

}

/// self : "http://hubspareparts.test/api/v1/refund-requests/all"

class Links {
  Links({
      this.self,});

  Links.fromJson(dynamic json) {
    self = json['self'];
  }
  String? self;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['self'] = self;
    return map;
  }

}

/// id : 48
/// order_info : {"id":19,"status":"complete","amount":"$704.00"}
/// refund_info : {"id":48,"status":"Request sent","total_products":1}

class DataSub {
  DataSub({
      this.id, 
      this.orderInfo, 
      this.refundInfo,});

  DataSub.fromJson(dynamic json) {
    id = json['id'];
    orderInfo = json['order_info'] != null ? OrderInfo.fromJson(json['order_info']) : null;
    refundInfo = json['refund_info'] != null ? RefundInfo.fromJson(json['refund_info']) : null;
  }
  dynamic id;
  OrderInfo? orderInfo;
  RefundInfo?   refundInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (orderInfo != null) {
      map['order_info'] = orderInfo?.toJson();
    }
    if (refundInfo != null) {
      map['refund_info'] = refundInfo?.toJson();
    }
    return map;
  }

}

/// id : 48
/// status : "Request sent"
/// total_products : 1

class RefundInfo {
  RefundInfo({
      this.id, 
      this.status, 
      this.totalProducts,});

  RefundInfo.fromJson(dynamic json) {
    id = json['id'];
    status = json['status'];
    totalProducts = json['total_products'];
  }
  dynamic id;
  String? status;
  num? totalProducts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['status'] = status;
    map['total_products'] = totalProducts;
    return map;
  }

}

/// id : 19
/// status : "complete"
/// amount : "$704.00"

class OrderInfo {
  OrderInfo({
      this.id, 
      this.status, 
      this.amount,});

  OrderInfo.fromJson(dynamic json) {
    id = json['id'];
    status = json['status'];
    amount = json['amount'];
  }
  num? id;
  String? status;
  String? amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['status'] = status;
    map['amount'] = amount;
    return map;
  }

}