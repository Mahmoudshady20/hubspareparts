import 'dart:convert';

SliderModel sliderModelFromJson(String str) =>
    SliderModel.fromJson(json.decode(str));

String sliderModelToJson(SliderModel data) => json.encode(data.toJson());

class SliderModel {
  SliderModel({
    required this.data,
  });

  List<Datum> data;

  factory SliderModel.fromJson(Map<String, dynamic> json) => SliderModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.title,
    required this.description,
    required this.image,
    this.buttonUrl,
    required this.buttonText,
    this.campaign,
    this.category,
  });

  String title;
  String description;
  String image;
  dynamic buttonUrl;
  String buttonText;
  dynamic campaign;
  dynamic category;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        title: json["title"],
        description: json["description"],
        image: json["image"],
        buttonUrl: json["button_url"],
        buttonText: json["button_text"],
        campaign: json["campaign"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "image": image,
        "button_url": buttonUrl,
        "button_text": buttonText,
        "campaign": campaign,
        "category": category,
      };
}
