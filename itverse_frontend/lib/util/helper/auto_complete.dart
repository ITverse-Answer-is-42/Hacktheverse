import 'dart:convert';

import '../../constants/api_path.dart';
import 'package:http/http.dart' as http;

class AutoCompleteService {
  Future<List<String>> getSuggestions(String query) async {
    String url =
        "$kAutoCompleteUrl?input=$query&key=$kGoogleMapsApi&type=locality";
    final response = await http.get(Uri.parse(url));

    final result = jsonDecode(response.body);

    List<String> suggestions = result['predictions']
        .map<String>((e) => e['description'] as String)
        .toList();

    return suggestions;
  }
}
