import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_path.dart';
import '../model/city_object.dart';

class AQIcityService {
  static Future<List<CityObject>> getTopCityList(String view) async {
    final response =
        await http.get(Uri.parse("$kTopCityListUrl?view=$view"), headers: {
      'Content-Type': 'application/json',
    });

    final decodedData = jsonDecode(response.body);

    final List<CityObject> cities = [];
    for (var city in decodedData['cities']) {
      cities.add(CityObject.fromJson(city));
      if (cities.length > 9) {
        break;
      }
    }

    return cities;
  }
}
