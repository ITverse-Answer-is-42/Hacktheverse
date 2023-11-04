import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:itverse_frontend/constants/app_constants.dart';
import 'package:itverse_frontend/util/services/map_services.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../../model/marker.dart' as model;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(50.09, 20.08),
    zoom: 8,
  );
  late GoogleMapController googleMapController;

  String dropdownvalue = 'AQI';

  // List of items in our dropdown menu
  var items = [
    'AQI',
    'Total GDP',
    'GDP/Capita',
    'GDP Growth Rate',
    'Total Population',
    'Population Growth',
  ];

  Map<String, dynamic> range = {
    "AQI": {
      "min": 0,
      "max": 500,
    },
    "Total GDP": {
      "min": 1,
      "max": 20000,
    },
    "GDP/Capita": {
      "min": 100,
      "max": 1000,
    },
    "GDP Growth Rate": {
      "min": -100,
      "max": 100,
    },
    "Total Population": {
      "min": 1000,
      "max": 1500000,
    },
    "Population Growth": {
      "min": -100,
      "max": 100,
    }
  };
  late SfRangeValues _values;
  @override
  void initState() {
    _values = SfRangeValues(range[dropdownvalue]["min"].toDouble(),
        range[dropdownvalue]["max"].toDouble());
    setState(() {});
    super.initState();
  }

  CameraPosition? _position;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            buildingsEnabled: false,
            onCameraMove: (position) async {
              _position = position;
              _sendBorderCoordinates(
                position.target,
                dropdownvalue,
                _values.start,
                _values.end,
              );
            },
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            markers: Set<Marker>.from(createMarkers(markerList)),
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) async {
              googleMapController = controller;
              _controller.complete(controller);
            },
          ),
          Positioned(
              top: 60,
              left: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton(
                      // Initial Value
                      value: dropdownvalue,
                      elevation: 0,
                      isExpanded: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      style: const TextStyle(color: Colors.black),

                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),

                      // Array list of items
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                          _values = SfRangeValues(
                              range[dropdownvalue]["min"].toDouble(),
                              range[dropdownvalue]["max"].toDouble());
                        });
                      },
                    ),
                    SfRangeSlider(
                      min: range[dropdownvalue]['min'].toDouble(),
                      max: range[dropdownvalue]['max'].toDouble(),
                      values: _values,
                      showTicks: true,
                      enableTooltip: true,
                      onChanged: (SfRangeValues values) {
                        setState(() {
                          _values = values;
                        });
                      },
                    ),
                    vGap10,
                    ElevatedButton(
                      onPressed: () {
                        _sendBorderCoordinates(
                          _position!.target,
                          dropdownvalue,
                          _values.start,
                          _values.end,
                        );
                      },
                      child: const Text("Apply"),
                    ),
                    vGap10
                  ],
                ),
              )),
        ],
      ),
    );
  }

  List<model.Marker> markerList = [];
  Future<void> _sendBorderCoordinates(LatLng position, String query, double min, double max) async {
    markerList = await MapServices.getLatLongs(position,query,min,max);
    setState(() {});
  }

  List<Marker> createMarkers(List<model.Marker> markers) {
    return markers.map((e) {
      return Marker(
        markerId: MarkerId(e.lat.toString()),
        position: LatLng(e.lat, e.long),
        infoWindow: InfoWindow(
          snippet: "gdpGrowthRate: ${e.gdpGrowthRate} tgdp: ${e.tgdp}",
          title: "aqi: ${e.aqi} gdp: ${e.gdp}",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(AQItoColor(e.aqi)),
      );
    }).toList();
  }

  double AQItoColor(int aqi) {
    if (aqi <= 50) {
      return BitmapDescriptor.hueGreen;
    } else if (aqi <= 100) {
      return BitmapDescriptor.hueYellow;
    } else if (aqi <= 150) {
      return BitmapDescriptor.hueOrange;
    } else if (aqi <= 200) {
      return BitmapDescriptor.hueRed;
    } else if (aqi <= 300) {
      return BitmapDescriptor.hueViolet;
    } else {
      return BitmapDescriptor.hueMagenta;
    }
  }
}
