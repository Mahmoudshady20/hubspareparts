/// code : 200
/// status : true
/// message : "Refund request retrieved"
/// data : {"id":48,"order_details":{"id":19,"transaction_id":"6JK8iJOCzyGRsfBFZ5ZY","payment_gateway":"Cash On Delivery","status":"complete","total_products":1,"items_total":"$500.00","discount_amount":"$0.00","shipping_cost":"$204.00","tax_amount":"$0.00","total_amount":"$704.00"},"refund_info":{"id":48,"additional_info":"Test Additional Info","preferred_option":{"option":"Manual Payment","option_data":{"Manual_Payment":"123"}},"total_products":1},"refund_items":[{"id":46,"product_id":160,"name":"Cailin Kelley test","image":"image-3-6551d51d45db31699861877.webp","quantity":1,"price":"$250.00","total":"$250.00"}],"refund_tracks":[{"id":18,"name":"Request sent","created_at":"2025-05-13 19:40:15"}]}

class RefundDetailsModel {
  RefundDetailsModel({
      this.code, 
      this.status, 
      this.message, 
      this.data,});

  RefundDetailsModel.fromJson(dynamic json) {
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

/// id : 48
/// order_details : {"id":19,"transaction_id":"6JK8iJOCzyGRsfBFZ5ZY","payment_gateway":"Cash On Delivery","status":"complete","total_products":1,"items_total":"$500.00","discount_amount":"$0.00","shipping_cost":"$204.00","tax_amount":"$0.00","total_amount":"$704.00"}
/// refund_info : {"id":48,"additional_info":"Test Additional Info","preferred_option":{"option":"Manual Payment","option_data":{"Manual_Payment":"123"}},"total_products":1}
/// refund_items : [{"id":46,"product_id":160,"name":"Cailin Kelley test","image":"image-3-6551d51d45db31699861877.webp","quantity":1,"price":"$250.00","total":"$250.00"}]
/// refund_tracks : [{"id":18,"name":"Request sent","created_at":"2025-05-13 19:40:15"}]

class Data {
  Data({
      this.id, 
      this.orderDetails, 
      this.refundInfo, 
      this.refundItems, 
      this.refundTracks,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    orderDetails = json['order_details'] != null ? OrderDetails.fromJson(json['order_details']) : null;
    refundInfo = json['refund_info'] != null ? RefundInfo.fromJson(json['refund_info']) : null;
    if (json['refund_items'] != null) {
      refundItems = [];
      json['refund_items'].forEach((v) {
        refundItems?.add(RefundItems.fromJson(v));
      });
    }
    if (json['refund_tracks'] != null) {
      refundTracks = [];
      json['refund_tracks'].forEach((v) {
        refundTracks?.add(RefundTracks.fromJson(v));
      });
    }
  }
  dynamic id;
  OrderDetails? orderDetails;
  RefundInfo? refundInfo;
  List<RefundItems>? refundItems;
  List<RefundTracks>? refundTracks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (orderDetails != null) {
      map['order_details'] = orderDetails?.toJson();
    }
    if (refundInfo != null) {
      map['refund_info'] = refundInfo?.toJson();
    }
    if (refundItems != null) {
      map['refund_items'] = refundItems?.map((v) => v.toJson()).toList();
    }
    if (refundTracks != null) {
      map['refund_tracks'] = refundTracks?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 18
/// name : "Request sent"
/// created_at : "2025-05-13 19:40:15"

class RefundTracks {
  RefundTracks({
      this.id, 
      this.name, 
      this.createdAt,});

  RefundTracks.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
  }
  dynamic id;
  String? name;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['created_at'] = createdAt;
    return map;
  }

}

/// id : 46
/// product_id : 160
/// name : "Cailin Kelley test"
/// image : "image-3-6551d51d45db31699861877.webp"
/// quantity : 1
/// price : "$250.00"
/// total : "$250.00"

class RefundItems {
  RefundItems({
      this.id, 
      this.productId, 
      this.name, 
      this.image, 
      this.quantity, 
      this.price, 
      this.total,});

  RefundItems.fromJson(dynamic json) {
    id = json['id'];
    productId = json['product_id'];
    name = json['name'];
    image = json['image'];
    quantity = json['quantity'];
    price = json['price'];
    total = json['total'];
  }
  dynamic id;
  num? productId;
  String? name;
  String? image;
  num? quantity;
  String? price;
  String? total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['product_id'] = productId;
    map['name'] = name;
    map['image'] = image;
    map['quantity'] = quantity;
    map['price'] = price;
    map['total'] = total;
    return map;
  }

}

/// id : 48
/// additional_info : "Test Additional Info"
/// preferred_option : {"option":"Manual Payment","option_data":{"Manual_Payment":"123"}}
/// total_products : 1

class RefundInfo {
  RefundInfo({
      this.id, 
      this.additionalInfo, 
      this.preferredOption, 
      this.totalProducts,});

  RefundInfo.fromJson(dynamic json) {
    id = json['id'];
    additionalInfo = json['additional_info'];
    preferredOption = json['preferred_option'] != null ? PreferredOption.fromJson(json['preferred_option']) : null;
    totalProducts = json['total_products'];
  }
  dynamic id;
  String? additionalInfo;
  PreferredOption? preferredOption;
  num? totalProducts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['additional_info'] = additionalInfo;
    if (preferredOption != null) {
      map['preferred_option'] = preferredOption?.toJson();
    }
    map['total_products'] = totalProducts;
    return map;
  }

}

/// option : "Manual Payment"
/// option_data : {"Manual_Payment":"123"}

class PreferredOption {
  PreferredOption({
      this.option, 
      this.optionData,});

  PreferredOption.fromJson(dynamic json) {
    option = json['option'];
    optionData = json['option_data'] != null ? OptionData.fromJson(json['option_data']) : null;
  }
  String? option;
  OptionData? optionData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['option'] = option;
    if (optionData != null) {
      map['option_data'] = optionData?.toJson();
    }
    return map;
  }

}

/// Manual_Payment : "123"

class OptionData {
  OptionData({
      this.manualPayment,});

  OptionData.fromJson(dynamic json) {
    manualPayment = json['Manual_Payment'];
  }
  String? manualPayment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Manual_Payment'] = manualPayment;
    return map;
  }

}

/// id : 19
/// transaction_id : "6JK8iJOCzyGRsfBFZ5ZY"
/// payment_gateway : "Cash On Delivery"
/// status : "complete"
/// total_products : 1
/// items_total : "$500.00"
/// discount_amount : "$0.00"
/// shipping_cost : "$204.00"
/// tax_amount : "$0.00"
/// total_amount : "$704.00"

class OrderDetails {
  OrderDetails({
      this.id, 
      this.transactionId, 
      this.paymentGateway, 
      this.status, 
      this.totalProducts, 
      this.itemsTotal, 
      this.discountAmount, 
      this.shippingCost, 
      this.taxAmount, 
      this.totalAmount,});

  OrderDetails.fromJson(dynamic json) {
    id = json['id'];
    transactionId = json['transaction_id'];
    paymentGateway = json['payment_gateway'];
    status = json['status'];
    totalProducts = json['total_products'];
    itemsTotal = json['items_total'];
    discountAmount = json['discount_amount'];
    shippingCost = json['shipping_cost'];
    taxAmount = json['tax_amount'];
    totalAmount = json['total_amount'];
  }
  dynamic id;
  String? transactionId;
  String? paymentGateway;
  String? status;
  num? totalProducts;
  String? itemsTotal;
  String? discountAmount;
  String? shippingCost;
  String? taxAmount;
  String? totalAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['transaction_id'] = transactionId;
    map['payment_gateway'] = paymentGateway;
    map['status'] = status;
    map['total_products'] = totalProducts;
    map['items_total'] = itemsTotal;
    map['discount_amount'] = discountAmount;
    map['shipping_cost'] = shippingCost;
    map['tax_amount'] = taxAmount;
    map['total_amount'] = totalAmount;
    return map;
  }

}