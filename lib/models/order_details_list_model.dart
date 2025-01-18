import 'dart:convert';

OrderListModel orderDetailsModelFromJson(String str) =>
    OrderListModel.fromJson(json.decode(str));

class OrderListModel {
  OrderListModel({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  dynamic currentPage;
  List<Datum> data;
  dynamic firstPageUrl;
  dynamic from;
  dynamic lastPage;
  dynamic lastPageUrl;
  dynamic links;
  dynamic nextPageUrl;
  dynamic path;
  dynamic perPage;
  dynamic prevPageUrl;
  dynamic to;
  dynamic total;

  factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );
}

class Datum {
  Datum({
    required this.id,
    required this.coupon,
    required this.couponAmount,
    required this.paymentTrack,
    required this.paymentGateway,
    required this.transactionId,
    required this.orderStatus,
    required this.paymentStatus,
    required this.invoiceNumber,
    this.orderTrack,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.paymentMeta,
  });

  dynamic id;
  dynamic coupon;
  dynamic couponAmount;
  dynamic paymentTrack;
  dynamic paymentGateway;
  dynamic transactionId;
  dynamic orderStatus;
  dynamic paymentStatus;
  dynamic invoiceNumber;
  dynamic orderTrack;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic userId;
  PaymentMeta? paymentMeta;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        coupon: json["coupon"],
        couponAmount: json["coupon_amount"],
        paymentTrack: json["payment_track"],
        paymentGateway: json["payment_gateway"],
        transactionId: json["transaction_id"],
        orderStatus: json["order_status"],
        paymentStatus: json["payment_status"],
        invoiceNumber: json["invoice_number"],
        orderTrack: json["order_track"] is! List && json["order_track"].isEmpty
            ? "pending"
            : json["order_track"][0]["name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        userId: json["user_id"],
        paymentMeta: json["payment_meta"] == null
            ? null
            : PaymentMeta.fromJson(json["payment_meta"]),
      );
}

class PaymentMeta {
  PaymentMeta({
    required this.id,
    required this.orderId,
    required this.subTotal,
    required this.couponAmount,
    required this.shippingCost,
    required this.taxAmount,
    required this.totalAmount,
  });

  dynamic id;
  dynamic orderId;
  dynamic subTotal;
  dynamic couponAmount;
  dynamic shippingCost;
  dynamic taxAmount;
  double totalAmount;

  factory PaymentMeta.fromJson(Map<String, dynamic> json) => PaymentMeta(
        id: json["id"],
        orderId: json["order_id"],
        subTotal: json["sub_total"],
        couponAmount: json["coupon_amount"],
        shippingCost: json["shipping_cost"],
        taxAmount: json["tax_amount"],
        totalAmount: json["total_amount"] is String
            ? double.parse(json["total_amount"])
            : json["total_amount"].toDouble(),
      );
}
