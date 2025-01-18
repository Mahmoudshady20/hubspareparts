import 'dart:convert';

CityDropdownModel cityDropdownModelFromJson(String str) =>
    CityDropdownModel.fromJson(json.decode(str));

String cityDropdownModelToJson(CityDropdownModel data) =>
    json.encode(data.toJson());

class CityDropdownModel {
  List<City>? cities;
  String? nextPage;

  CityDropdownModel({
    this.cities,
    this.nextPage,
  });

  factory CityDropdownModel.fromJson(Map json) => CityDropdownModel(
        cities: json["state"] == null
            ? []
            : json["state"]["data"] == null
                ? []
                : List<City>.from(
                    json["state"]["data"]!.map((x) => City.fromJson(x))),
        nextPage: json["next_page_url"],
      );

  Map<String, dynamic> toJson() => {
        "state": cities == null
            ? []
            : List<dynamic>.from(cities!.map((x) => x.toJson())),
      };
}

class City {
  dynamic id;
  String? name;
  dynamic stateId;

  City({
    this.id,
    this.name,
    this.stateId,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
        stateId: json["state_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "state_id": stateId,
      };
}
