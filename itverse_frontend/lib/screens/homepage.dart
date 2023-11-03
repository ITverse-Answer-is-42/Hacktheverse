import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:itverse_frontend/config/routes/routes.dart';
import 'package:itverse_frontend/constants/app_constants.dart';
import 'package:itverse_frontend/core/aqi_service.dart';
import 'package:itverse_frontend/model/aq_object.dart';
import 'package:itverse_frontend/util/services/location_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _address = "";
  final AQIServiceRenderer _service = AQIServiceRenderer();
  @override
  void initState() {
    getData();
    super.initState();
  }

  double aqi = 40.0;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(_address),
        actions: [
          IconButton(
            onPressed: getData,
            icon: const Icon(Icons.location_on),
          )
        ],
      ),
      backgroundColor:
          _isLoading ? Colors.white : _service.getAQIColor(aqiObject!.aqi),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Your AQI level is: ${aqiObject!.aqi}',
                    ),
                    Text(
                      "${_service.getAQILevel(aqiObject!.aqi)}",
                    ),
                    Text(
                      "${_service.getAQILevelMap(aqiObject!.aqi)}",
                    ),
                    Text(
                      "${_service.getAQIAdvice(aqiObject!.aqi)}",
                    ),
                    Text(
                      "${_service.getAQIHealthEffects(aqiObject!.aqi)}",
                    )
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.pushNamed(context, rSearchPage);
      }),
    );
  }

  AirQualityObject? aqiObject;
  Future getData() async {
    final position = await LocationService.determinePosition();
    aqiObject = await AQIServiceRenderer.getAirQualityObject(position);

    _address = await LocationService.getAddress(position);
    setState(() {
      _isLoading = false;
    });
  }
}
