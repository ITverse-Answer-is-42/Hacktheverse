import 'package:flutter/material.dart';

import '../config/routes/routes.dart';
import '../util/helper/auto_complete.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<String> suggestions = [];
  final AutoCompleteService _autoComplete = AutoCompleteService();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    getData(query);
    for (var item in suggestions) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }

    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result),
            onTap: () {
              Navigator.pushNamed(context, rHomePage, arguments: result);
            },
          );
        });
  }

  Future getData(String input) async {
    suggestions = await _autoComplete.getSuggestions(input);
    if (query.isEmpty) {
      suggestions = [];
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    getData(query);
    for (var item in suggestions) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }

    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result),
            onTap: () {
              Navigator.pushNamed(context, rHomePage, arguments: result);
            },
          );
        });
  }
}
