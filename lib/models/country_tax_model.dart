import 'dart:convert';

CountryTaxModel countryTaxModelFromJson(String str) =>
    CountryTaxModel.fromJson(json.decode(str));

String countryTaxModelToJson(CountryTaxModel data) =>
    json.encode(data.toJson());

class CountryTaxModel {
  CountryTaxModel({
    required this.success,
    required this.states,
    required this.taxAmount,
  });

  dynamic success;
  List<State> states;
  dynamic taxAmount;

  factory CountryTaxModel.fromJson(Map<String, dynamic> json) =>
      CountryTaxModel(
        success: json["success"],
        states: List<State>.from(json["states"].map((x) => State.fromJson(x))),
        taxAmount: json["tax_amount"] is String
            ? double.parse(json["tax_amount"])
            : json["tax_amount"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "states": List<dynamic>.from(states.map((x) => x.toJson())),
        "tax_amount": taxAmount,
      };
}

class State {
  State({
    required this.id,
    required this.name,
  });

  dynamic id;
  String name;

  factory State.fromJson(Map<String, dynamic> json) => State(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
