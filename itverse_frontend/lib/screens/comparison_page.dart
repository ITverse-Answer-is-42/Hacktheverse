import 'package:flutter/material.dart';
import 'package:itverse_frontend/constants/app_constants.dart';
import 'package:itverse_frontend/model/aq_metric_object.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:geolocator/geolocator.dart' as geo;
import '../core/aqi_city_service.dart';
import '../core/aqi_service.dart';
import '../model/chart_data.dart';
import '../util/services/location_services.dart';

class ComparisonPage extends StatefulWidget {
  final String cityOne;
  final String cityTwo;
  const ComparisonPage(
      {super.key, required this.cityOne, required this.cityTwo});

  @override
  State<ComparisonPage> createState() => _ComparisonPageState();
}

class _ComparisonPageState extends State<ComparisonPage> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comparison Chart"),
      ),
      body: (_isLoading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                vGap20,
                SfCartesianChart(
                  legend: const Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                    overflowMode: LegendItemOverflowMode.wrap,
                  ),
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis:
                      NumericAxis(minimum: 0, maximum: 300, interval: 10),
                  series: <ChartSeries<ComparisonData, String>>[
                    ColumnSeries<ComparisonData, String>(
                      dataSource: [
                        ComparisonData('AQI', [objectOne!.aqi, objectTwo!.aqi]),
                        ComparisonData(
                            'PM 10', [objectOne!.pm10, objectTwo!.pm10]),
                        ComparisonData(
                            'PM 2.5', [objectOne!.pm25, objectTwo!.pm25]),
                        ComparisonData('Ozone', [objectOne!.o3, objectTwo!.o3]),
                      ],
                      xValueMapper: (ComparisonData data, _) => data.x,
                      yValueMapper: (ComparisonData data, _) => data.values[0],
                      name: widget.cityOne,
                      color: const Color.fromRGBO(8, 142, 255, 1),
                    ),
                    ColumnSeries<ComparisonData, String>(
                      dataSource: [
                        ComparisonData('AQI', [objectOne!.aqi, objectTwo!.aqi]),
                        ComparisonData(
                            'PM 10', [objectOne!.pm10, objectTwo!.pm10]),
                        ComparisonData(
                            'PM 2.5', [objectOne!.pm25, objectTwo!.pm25]),
                        ComparisonData('Ozone', [objectOne!.o3, objectTwo!.o3]),
                      ],
                      xValueMapper: (ComparisonData data, _) => data.x,
                      yValueMapper: (ComparisonData data, _) => data.values[1],
                      name: widget.cityTwo,
                      color: const Color.fromRGBO(255, 0, 0, 1),
                    ),
                  ],
                ),
              ]),
            ),
    );
  }

  AirQualityMetricObject? objectOne;
  AirQualityMetricObject? objectTwo;
  Future getData() async {
    geo.Position positionOne =
        await LocationService.getLocation(widget.cityOne);
    geo.Position positionTwo =
        await LocationService.getLocation(widget.cityTwo);

    objectOne =
        await AQIServiceRenderer.getAirQualityObject(position: positionOne);
    objectTwo =
        await AQIServiceRenderer.getAirQualityObject(position: positionTwo);
    setState(() {
      _isLoading = false;
    });
  }
}
