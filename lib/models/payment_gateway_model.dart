// To parse this JSON data, do
//
//     final paymentGatewayModel = paymentGatewayModelFromJson(jsonString);

import 'dart:convert';

PaymentGatewayModel paymentGatewayModelFromJson(String str) =>
    PaymentGatewayModel.fromJson(json.decode(str));

String paymentGatewayModelToJson(PaymentGatewayModel data) =>
    json.encode(data.toJson());

class PaymentGatewayModel {
  PaymentGatewayModel({
    required this.data,
  });

  List<Datum> data;

  factory PaymentGatewayModel.fromJson(Map<String, dynamic> json) =>
      PaymentGatewayModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.name,
    required this.image,
    required this.status,
    required this.testMode,
    required this.credentials,
  });

  String name;
  String? image;
  dynamic status;
  dynamic testMode;
  Map<String, String?> credentials;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        name: json["name"],
        image: json["image"],
        status: json["status"],
        testMode: json["test_mode"],
        credentials: Map.from(json["credentials"])
            .map((k, v) => MapEntry<String, String?>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "status": status,
        "test_mode": testMode,
        "credentials": Map.from(credentials)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
