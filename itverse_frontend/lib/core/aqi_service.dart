import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:itverse_frontend/constants/api_path.dart';

import '../model/aq_object.dart';

enum AQIlevels {
  good,
  moderate,
  unhealthyForSensitiveGroups,
  unhealthy,
  veryUnhealthy,
  hazardous
}

class AQIServiceRenderer {
  Map<AQIlevels, Color> colors = {
    AQIlevels.good: const Color.fromARGB(255, 75, 255, 75),
    AQIlevels.moderate: const Color(0xffFFDF00),
    AQIlevels.unhealthyForSensitiveGroups: const Color(0xffFF7E00),
    AQIlevels.unhealthy: const Color(0xffFF0000),
    AQIlevels.veryUnhealthy: const Color(0xff8F3F97),
    AQIlevels.hazardous: const Color(0xff7E0023),
  };

  Map<AQIlevels, String> levels = {
    AQIlevels.good: "Good",
    AQIlevels.moderate: "Moderate",
    AQIlevels.unhealthyForSensitiveGroups: "Unhealthy for Sensitive Groups",
    AQIlevels.unhealthy: "Unhealthy",
    AQIlevels.veryUnhealthy: "Very Unhealthy",
    AQIlevels.hazardous: "Hazardous",
  };

  Map<AQIlevels, String> levelsMap = {
    AQIlevels.good: "0 - 50",
    AQIlevels.moderate: "51 - 100",
    AQIlevels.unhealthyForSensitiveGroups: "101 - 150",
    AQIlevels.unhealthy: "151 - 200",
    AQIlevels.veryUnhealthy: "201 - 300",
    AQIlevels.hazardous: "301 - 500",
  };

  Map<AQIlevels, String> advices = {
    AQIlevels.good:
        "The air quality is excellent, and there are no major health concerns. Enjoy outdoor activities and open windows to let in fresh air.",
    AQIlevels.moderate:
        "Air quality is acceptable, but people with respiratory conditions should limit prolonged outdoor exertion. Consider reducing outdoor activities if you are sensitive to pollution.",
    AQIlevels.unhealthyForSensitiveGroups:
        "People with respiratory or heart conditions, children, and the elderly should reduce outdoor activities. Others may continue as usual.",
    AQIlevels.unhealthy:
        "Everyone should reduce outdoor activities. Sensitive groups should avoid outdoor exertion. Consider using air purifiers indoors.",
    AQIlevels.veryUnhealthy:
        "Stay indoors, especially for sensitive groups. Avoid outdoor activities and ensure good indoor air quality. Use air purifiers and keep windows closed.",
    AQIlevels.hazardous:
        "Stay indoors, and avoid outdoor activity at all costs. Use air purifiers with HEPA filters, seal windows and doors, and take necessary precautions.",
  };

  Map<AQIlevels, String> healthEffects = {
    AQIlevels.good:
        "Minimal or no risk to health. Ideal for outdoor activities and overall well-being.",
    AQIlevels.moderate:
        "Minor health concern for individuals with respiratory or heart conditions. Most people can enjoy outdoor activities.",
    AQIlevels.unhealthyForSensitiveGroups:
        "Increased risk for sensitive individuals. Reduced outdoor activities for vulnerable groups is recommended.",
    AQIlevels.unhealthy:
        "Health alert. Increased likelihood of health effects for everyone, especially sensitive groups.",
    AQIlevels.veryUnhealthy:
        "Serious health alert. Everyone may experience more serious health effects.",
    AQIlevels.hazardous:
        "Health warning of emergency conditions. The entire population is more likely to be affected.",
  };

  Color? getAQIColor(int aqi) {
    return colors[getAQIlevel(aqi)];
  }

  String? getAQILevel(int aqi) {
    return levels[getAQIlevel(aqi)];
  }

  String? getAQILevelMap(int aqi) {
    return levelsMap[getAQIlevel(aqi)];
  }

  String? getAQIAdvice(int aqi) {
    return advices[getAQIlevel(aqi)];
  }

  String? getAQIHealthEffects(int aqi) {
    return healthEffects[getAQIlevel(aqi)];
  }

  static AQIlevels getAQIlevel(int aqi) {
    if (aqi <= 50) {
      return AQIlevels.good;
    } else if (aqi <= 100) {
      return AQIlevels.moderate;
    } else if (aqi <= 150) {
      return AQIlevels.unhealthyForSensitiveGroups;
    } else if (aqi <= 200) {
      return AQIlevels.unhealthy;
    } else if (aqi <= 300) {
      return AQIlevels.veryUnhealthy;
    } else {
      return AQIlevels.hazardous;
    }
  }

  static getAirQualityObject(Position position) async {
    Map<String, dynamic> data = {};
    try {
      final response = await http.get(
          Uri.parse(
              "$kHereUrl?lat=${position.latitude}&lon=${position.longitude}"),
          headers: {"Content-Type": "application/json,"});

      data = jsonDecode(response.body);
      debugPrint(data['cities'].toString());
    } catch (e) {
      debugPrint(e.toString());
    }
    final a = AirQualityObject.fromJson(data['cities'][0]);

    debugPrint(a.aqi.toString());
    return a;
  }
}
