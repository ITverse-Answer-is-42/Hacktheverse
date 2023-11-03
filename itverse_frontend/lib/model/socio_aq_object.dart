import 'package:itverse_frontend/model/aq_metric_object.dart';

class SocioAIQobject {
  final AirQualityMetricObject aiqObject;

  final List<Map<int, double>> tgdp;
  final List<Map<int, double>> gdpCapita;
  final List<Map<int, double>> gdpGrowthRate;
  final List<Map<int, double>> tpopulation;
  final List<Map<int, double>> populationGrowth;

  SocioAIQobject({
    required this.aiqObject,
    required this.tgdp,
    required this.gdpCapita,
    required this.gdpGrowthRate,
    required this.tpopulation,
    required this.populationGrowth,
  });

  factory SocioAIQobject.fromJson(Map<String, dynamic> json) {
    return SocioAIQobject(
      aiqObject: AirQualityMetricObject.fromJson(json['cities'][0]),
      tgdp: List<Map<int, double>>.from(
        json['tgdp'].map(
          (i) {
            Map<int, double> map = {
              i['year']: i['value'].toDouble(),
            };
            return map;
          },
        ),
      ),
      gdpCapita: List<Map<int, double>>.from(
        json['gdpCapita'].map(
          (i) {
            Map<int, double> map = {
              i['year']: i['value'] as double,
            };
            return map;
          },
        ),
      ),
      gdpGrowthRate: List<Map<int, double>>.from(
        json['gdpGrowthRate'].map(
          (i) {
            Map<int, double> map = {
              i['year']: i['value'].toDouble(),
            };
            return map;
          },
        ),
      ),
      tpopulation: List<Map<int, double>>.from(
        json['tpopulation'].map(
          (i) {
            Map<int, double> map = {
              i['year']: i['value'].toDouble(),
            };
            return map;
          },
        ),
      ),
      populationGrowth: List<Map<int, double>>.from(
        json['populationGrowth'].map(
          (i) {
            Map<int, double> map = {
              i['year']: i['value'].toDouble(),
            };
            return map;
          },
        ),
      ),
    );
  }
}
