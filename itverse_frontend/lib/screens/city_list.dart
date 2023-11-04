import 'package:flutter/material.dart';
import 'package:itverse_frontend/constants/app_constants.dart';
import 'package:itverse_frontend/core/aqi_city_service.dart';
import 'package:itverse_frontend/core/aqi_service.dart';
import 'package:itverse_frontend/model/city_object.dart';

import '../config/routes/routes.dart';

class CityListScreen extends StatefulWidget {
  final String view;
  const CityListScreen({super.key, required this.view});

  @override
  State<CityListScreen> createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  AQIServiceRenderer _service = AQIServiceRenderer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Top ${widget.view == "top" ? "Cleanest" : "Polluted"} Cities"),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          itemCount: _cities.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InkWell(
                onTap: () => Navigator.pushNamed(
                  context,
                  rContentPage,
                  arguments: _cities[index].address,
                ),
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _service.getAQIColor(_cities[index].aqi),
                    ),
                    child: Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          _cities[index].flagUrl,
                          fit: BoxFit.cover,
                          width: 50,
                          height: 40,
                        ),
                      ),
                      hGap10,
                      SizedBox(width: 160, child: Text(_cities[index].address)),
                      Spacer(),
                      CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text("${_cities[index].aqi}")),
                      hGap10,
                    ])),
              ),
            );
          }),
    );
  }

  List<CityObject> _cities = [];
  Future getData() async {
    _cities = await AQIcityService.getTopCityList(widget.view);
    setState(() {});
  }
}
