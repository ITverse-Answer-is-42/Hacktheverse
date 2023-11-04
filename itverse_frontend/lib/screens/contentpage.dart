import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:itverse_frontend/config/routes/routes.dart';
import 'package:itverse_frontend/constants/app_constants.dart';
import 'package:itverse_frontend/core/aqi_service.dart';
import 'package:itverse_frontend/model/aq_metric_object.dart';
import 'package:itverse_frontend/model/socio_aq_object.dart';
import 'package:itverse_frontend/util/services/location_services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../model/chart_data.dart';

class ContentPage extends StatefulWidget {
  final String? address;
  const ContentPage({super.key, this.address});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  String _address = "";
  final AQIServiceRenderer _service = AQIServiceRenderer();
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
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(
          _address,
        ),
      ),
      backgroundColor: _isLoading
          ? Colors.white
          : _service.getAQIColor(aqiObject!.aiqObject.aqi),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        _service.getAQIIcon(aqiObject!.aiqObject.aqi)!,
                      ),
                      Text(
                        'Your AQI level is: ${aqiObject!.aiqObject.aqi}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      vGap10,
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                              text:
                                  "${_service.getAQILevel(aqiObject!.aiqObject.aqi)}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _service
                                    .getAQIColor(aqiObject!.aiqObject.aqi),
                              ),
                            ),
                            TextSpan(
                                text:
                                    " ( ${_service.getAQILevelMap(aqiObject!.aiqObject.aqi)} )",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ))
                          ]),
                        ),
                      ),
                      vGap10,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Advice",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Text(
                              "${_service.getAQIAdvice(aqiObject!.aiqObject.aqi)}",
                            ),
                          ),
                          vGap10,
                          const Text(
                            "Health Effects",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Text(
                              "${_service.getAQIHealthEffects(aqiObject!.aiqObject.aqi)}",
                            ),
                          ),
                        ],
                      ),
                      vGap20,
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: "PM 2.5: ",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                TextSpan(
                                  text: "${aqiObject!.aiqObject.pm25}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                )
                              ]),
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: "PM 10: ",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                TextSpan(
                                  text: "${aqiObject!.aiqObject.pm10}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                )
                              ]),
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: "Ozone: ",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                TextSpan(
                                  text: "${aqiObject!.aiqObject.o3}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                )
                              ]),
                            ),
                          ],
                        ),
                      ),
                      vGap20,
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Total GDP",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      //create a syncfusion Fast line chart
                      LineChart(list: aqiObject!.tgdp),
                      vGap20,
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "GDP per Capita",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      LineChart(list: aqiObject!.gdpCapita),
                      vGap20,
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "GDP Growth",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      LineChart(list: aqiObject!.gdpGrowthRate),
                      vGap20,
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Total Population",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      LineChart(list: aqiObject!.tpopulation),
                      vGap20,
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Population Growth",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      LineChart(list: aqiObject!.populationGrowth),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  SocioAIQobject? aqiObject;
  Future getData() async {
    geo.Position position;
    if (widget.address == null) {
      position = await LocationService.determinePosition();
      _address = await LocationService.getAddress(position);
      debugPrint("curr lat: ${position.latitude}, long: ${position.longitude}");
    } else {
      position = await LocationService.getLocation(widget.address!);
      _address = widget.address!;
      debugPrint(
          "search lat: ${position.latitude}, long: ${position.longitude}");
    }

    aqiObject = await AQIServiceRenderer.getAirQualityObject(
        position: position, countryName: _address);

    setState(() {
      _isLoading = false;
    });
  }
}

class LineChart extends StatelessWidget {
  const LineChart({
    super.key,
    required this.list,
  });

  final List<Map<int, double>> list;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: DateTimeAxis(interval: 10),
        backgroundColor: Colors.white,
        primaryYAxis: NumericAxis(
            title: AxisTitle(
          text: "in Thousand",
        )),

        // legend: Legend(,

        //   isVisible: true,
        //   position: LegendPosition.bottom,
        //   overflowMode: LegendItemOverflowMode.wrap,
        // ),
        series: <ChartSeries>[
          // Renders line chart

          LineSeries<ChartData, DateTime>(
            dataSource: List<ChartData>.from(list.map((e) {
              return ChartData(e.keys.first, (e.values.first * 1.0) / 1000);
            })),
            xValueMapper: (ChartData data, _) => DateTime(data.x),
            yValueMapper: (ChartData data, _) => data.y,
          ),
        ]);
  }
}
