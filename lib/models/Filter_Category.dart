import 'Brands.dart';
import 'Categories.dart';
import 'ControlVoltage.dart';
import 'CurrentRating.dart';
import 'PowerRating.dart';
import 'VoltageRating.dart';

class FilterCategory {
  FilterCategory({
    this.categories,
    this.currentRating,
    this.voltageRating,
    this.controlVoltage,
    this.powerRating,
    this.brands,
    this.success,
  });

  FilterCategory.fromJson(dynamic json) {
    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        categories?.add(Categories.fromJson(v));
      });
    }
    currentRating = json['current_rating'] != null
        ? CurrentRating.fromJson(json['current_rating'])
        : null;
    if (json['voltage_rating'] != null) {
      voltageRating = [];
      json['voltage_rating'].forEach((v) {
        voltageRating?.add(VoltageRating.fromJson(v));
      });
    }
    if (json['control_voltage'] != null) {
      controlVoltage = [];
      json['control_voltage'].forEach((v) {
        controlVoltage?.add(ControlVoltage.fromJson(v));
      });
    }
    if (json['power_rating'] != null) {
      powerRating = [];
      json['power_rating'].forEach((v) {
        powerRating?.add(PowerRating.fromJson(v));
      });
    }
    if (json['brands'] != null) {
      brands = [];
      json['brands'].forEach((v) {
        brands?.add(Brands.fromJson(v));
      });
    }
    success = json['success'];
  }
  List<Categories>? categories;
  CurrentRating? currentRating;
  List<VoltageRating>? voltageRating;
  List<ControlVoltage>? controlVoltage;
  List<PowerRating>? powerRating;
  List<Brands>? brands;
  bool? success;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (categories != null) {
      map['categories'] = categories?.map((v) => v.toJson()).toList();
    }
    if (currentRating != null) {
      map['current_rating'] = currentRating?.toJson();
    }
    if (voltageRating != null) {
      map['voltage_rating'] = voltageRating?.map((v) => v.toJson()).toList();
    }
    if (controlVoltage != null) {
      map['control_voltage'] = controlVoltage?.map((v) => v.toJson()).toList();
    }
    if (powerRating != null) {
      map['power_rating'] = powerRating?.map((v) => v.toJson()).toList();
    }
    if (brands != null) {
      map['brands'] = brands?.map((v) => v.toJson()).toList();
    }
    map['success'] = success;
    return map;
  }
}
