class Marker {
  final double lat;
  final double long;
  final int aqi;
  final double tgdp;
  final double gdp;
  final double gdpGrowthRate;
  final int population;
  final double populationGrowth;
  Marker({
    required this.lat,
    required this.long,
    required this.aqi,
    required this.tgdp,
    required this.gdp,
    required this.gdpGrowthRate,
    required this.population,
    required this.populationGrowth,
  });

  factory Marker.fromJson(Map<String, dynamic> json) {
    return Marker(
      tgdp: json['tgdp'],
      gdp: json['gdp'],
      gdpGrowthRate: json['gdpGrowthRate'],
      population: json['population'],
      populationGrowth: json['populationGrowth'],
      lat: json['lat'],
      long: json['long'],
      aqi: json['aqi'],
    );
  }
}
