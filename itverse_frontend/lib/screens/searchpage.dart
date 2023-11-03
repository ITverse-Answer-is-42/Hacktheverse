import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:itverse_frontend/constants/api_path.dart';
import 'package:itverse_frontend/util/helper/auto_complete.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    _controller.addListener(() {
      onChange();
    });
    super.initState();
  }

  final AutoCompleteService _autoComplete = AutoCompleteService();
  List<String> suggestions = [];
  void onChange() async {
    suggestions = await _autoComplete.getSuggestions(_controller.text);
    setState(() {
      if (_controller.text.isEmpty) {
        suggestions = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Search by City/Country",
              prefixIcon: Icon(Icons.search),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return Text(suggestions[index]);
                }),
          )
        ],
      ),
    );
  }
}
