/// min : 0
/// max : 1600

class CurrentRating {
  CurrentRating({
    this.min,
    this.max,
  });

  CurrentRating.fromJson(dynamic json) {
    min = json['min'];
    max = json['max'];
  }
  num? min;
  num? max;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['min'] = min;
    map['max'] = max;
    return map;
  }
}
