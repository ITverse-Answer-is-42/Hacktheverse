import 'package:flutter/material.dart';
import 'package:itverse_frontend/screens/comparison_page.dart';

import '../../screens/city_list.dart';
import '../../screens/contentpage.dart';
import '../../screens/homepage.dart';
import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> genrateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case rContentPage:
        return MaterialPageRoute(
            builder: (context) => ContentPage(
                  address: args as String?,
                ));
      case rHome:
        return MaterialPageRoute(builder: (context) => const HomePage());
      case rCityListPage:
        return MaterialPageRoute(
            builder: (context) => CityListScreen(
                  view: args as String,
                ));
      case rComparisonPage:
      final map = args as Map<String, String>;
        return MaterialPageRoute(
          
            builder: (context) => ComparisonPage(
              cityOne: map["cityOne"]!,
              cityTwo: map["cityTwo"]!,

            ));
      default:
        return MaterialPageRoute(builder: (context) => const ContentPage());
    }
  }
}
