import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:itverse_frontend/config/routes/routes.dart';
import 'package:itverse_frontend/constants/app_constants.dart';
import 'package:itverse_frontend/core/aqi_service.dart';
import 'package:itverse_frontend/model/aq_object.dart';
import 'package:itverse_frontend/util/services/location_services.dart';

class HomePage extends StatefulWidget {
  final String? address;
  const HomePage({super.key, this.address});

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
          : SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        _service.getAQIIcon(aqiObject!.aqi)!,
                      ),
                      Text(
                        'Your AQI level is: ${aqiObject!.aqi}',
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
                              text: "${_service.getAQILevel(aqiObject!.aqi)}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _service.getAQIColor(aqiObject!.aqi),
                              ),
                            ),
                            TextSpan(
                                text:
                                    " ( ${_service.getAQILevelMap(aqiObject!.aqi)} )",
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
                              "${_service.getAQIAdvice(aqiObject!.aqi)}",
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
                              "${_service.getAQIHealthEffects(aqiObject!.aqi)}",
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
                                    text: "${aqiObject!.pm25}",
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
                                    text: "${aqiObject!.pm10}",
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
                                    text: "${aqiObject!.o3}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  )
                                ]),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: (widget.address != null)
          ? null
          : BottomAppBar(
              height: 55,
              elevation: 10,
              shadowColor: Colors.black,
              shape: const CircularNotchedRectangle(),
              color: Colors.white,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, rHomePage);
                      },
                      icon: const Icon(
                        Icons.home,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, rSearchPage);
                      },
                      icon: const Icon(
                        Icons.search,
                      ),
                    ),
                  ])),
    );
  }

  AirQualityObject? aqiObject;
  Future getData() async {
    Position position;
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

    aqiObject = await AQIServiceRenderer.getAirQualityObject(position);

    setState(() {
      _isLoading = false;
    });
  }
}
