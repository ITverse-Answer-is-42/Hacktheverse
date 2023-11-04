class AirQualityMetricObject {
  final int aqi;
  final int pm25;
  final int pm10;
  final int o3;

  AirQualityMetricObject(
      {required this.aqi,
      required this.pm25,
      required this.pm10,
      required this.o3});

  factory AirQualityMetricObject.fromJson(Map<String, dynamic> json) {
    return AirQualityMetricObject(
        aqi: json['aqi'],
        pm25: json['forecast']['pm25'],
        pm10: json['forecast']['pm10'],
        o3: json['forecast']['o3']);
  }
}
