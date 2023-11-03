class CityObject {
  final int rank;
  final int aqi;
  final String address;

  final String flagUrl;

  CityObject({
    required this.rank,
    required this.aqi,
    required this.address,
    required this.flagUrl,
  });

  factory CityObject.fromJson(Map<String, dynamic> json) {
    return CityObject(
      rank: json['rank'],
      aqi: json['aqi'],
      address: "${json['city']}, ${json['country']}",
      flagUrl: json['flagURL'],
    );
  }
}
