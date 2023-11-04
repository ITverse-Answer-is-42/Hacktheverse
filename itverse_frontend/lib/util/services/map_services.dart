import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../model/marker.dart' as model;
import 'package:http/http.dart' as http;
import '../../constants/api_path.dart';

class MapServices {
  static Future<List<model.Marker>> getLatLongs(LatLng poistion, String query, double min, double max) async {
    String url =
        "$kHereUrl/markers?lat=${poistion.latitude}&long=${poistion.longitude}&min=${min}&max=${max}&query=${query}";

    debugPrint(" jdkcnkadslcjadlskcnlksadn");
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    final decodedData = jsonDecode(response.body);
    
    return List<model.Marker>.from(decodedData.map((e) {
      return model.Marker(
        lat: e['lat'],
        long: e['long'],
        aqi: e['aqi'],
        gdp: e['gdp'],
        gdpGrowthRate: e['gdpGrowthRate'],
        tgdp: e['tgdp'],
        population: e['population'],
        populationGrowth: e['populationGrowth'],
      );
    }));
  }
}
