import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:itverse_frontend/constants/api_path.dart';

class LocationService {
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  static Future<String> getAddress(Position position) async {
    List<Placemark> placemarks;
    try {
      placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
    } catch (e) {
      return "error";
    }

    if (placemarks.isEmpty) {
      return "";
    } else {
      return "${placemarks.first.locality}, ${placemarks.first.country}";
    }
  }

  static Future<Position> getLocation(String address) async {
    String queryUrl = "$kGeoCodingUrl?address=$address&key=$kGoogleMapsApi";

    final response = await http.get(Uri.parse(queryUrl), headers: {
      'Content-Type': 'application/json',
    });

    final result = jsonDecode(response.body);

    final Position position = Position(
        latitude: result['results'][0]['geometry']['location']['lat'],
        longitude: result['results'][0]['geometry']['location']['lng'],
        accuracy: 0,
        timestamp: DateTime.now(),
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0);

    return position;
  }
}
