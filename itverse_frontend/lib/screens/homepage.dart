import 'package:flutter/material.dart';
import 'package:itverse_frontend/constants/app_constants.dart';

import '../config/routes/routes.dart';
import '../util/helper/auto_complete.dart';
import '../widgets/custom_search.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _cityOne = TextEditingController();
  final TextEditingController _cityTwo = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, rCityListPage,
                          arguments: "worst"),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.red.shade300,
                                  Colors.red.shade400,
                                  Colors.red.shade500,
                                  Colors.red.shade600,
                                  Colors.red.shade700,
                                  Colors.red.shade800,
                                  Colors.red.shade900,
                                ])),
                        child: const Text(
                          "Top 10 Polluted Cities",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  hGap20,
                  Flexible(
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, rCityListPage,
                          arguments: "top"),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.green.shade300,
                                Colors.green.shade400,
                                Colors.green.shade500,
                                Colors.green.shade600,
                                Colors.green.shade700,
                                Colors.green.shade800,
                                Colors.green.shade900,
                              ]),
                        ),
                        child: const Text(
                          "Top 10 Cleanest Cities",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              vGap20,
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade200,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField(
                        controller: _cityOne,
                      ),
                      vGap10,
                      CustomTextField(
                        controller: _cityTwo,
                      ),
                      vGap10,
                      ElevatedButton(
                        onPressed: () {
                          validate();
                        },
                        child: const Text("Compare"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validate() {
    if (_cityOne.text.isNotEmpty && _cityTwo.text.isNotEmpty) {
      Navigator.pushNamed(context, rComparisonPage, arguments: {
        "cityOne": _cityOne.text,
        "cityTwo": _cityTwo.text,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please Enter Both City Name"),
      ));
    }
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  const CustomTextField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 60,
        child: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
              controller: controller,
              decoration: const InputDecoration(
                  labelText: "Enter City Name", border: OutlineInputBorder())),
          suggestionsCallback: (pattern) =>
              AutoCompleteService().getSuggestions(pattern),
          itemBuilder: (context, suggestion) {
            return ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(suggestion),
            );
          },
          onSuggestionSelected: (suggestion) {
            controller.text = suggestion;
          },
        ));
  }
}
