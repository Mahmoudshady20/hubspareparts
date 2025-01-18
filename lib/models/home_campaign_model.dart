import 'dart:convert';

HomeCampaignsModel? homeCampaignsModelFromJson(String str) =>
    HomeCampaignsModel.fromJson(json.decode(str));

String homeCampaignsModelToJson(HomeCampaignsModel? data) =>
    json.encode(data!.toJson());

class HomeCampaignsModel {
  HomeCampaignsModel({
    this.data,
  });

  List<Datum?>? data;

  factory HomeCampaignsModel.fromJson(Map<String, dynamic> json) =>
      HomeCampaignsModel(
        data: json["data"] == null
            ? []
            : List<Datum?>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x!.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.title,
    this.subtitle,
    this.image,
    this.startDate,
    this.endDate,
  });

  dynamic id;
  String? title;
  String? subtitle;
  String? image;
  dynamic startDate;
  DateTime? endDate;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        image: json["image"],
        startDate: json["start_date"],
        endDate: DateTime.parse(json["end_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "image": image,
        "start_date": startDate,
        "end_date": endDate?.toIso8601String(),
      };
}
