import 'package:flutter/material.dart';

import '../../screens/homepage.dart';
import '../../screens/searchpage.dart';
import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> genrateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case rHomePage :
        return MaterialPageRoute(builder: (context) =>  HomePage(
          address: args as String?,
        ));
      case rSearchPage :
        return MaterialPageRoute(builder: (context) => const SearchScreen());
      default:
        return MaterialPageRoute(builder: (context) => const HomePage());
    }
  }
}