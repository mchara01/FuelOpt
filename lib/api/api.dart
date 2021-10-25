import 'dart:convert';
import 'package:flutter/material.dart';
import '../model/stations_model.dart';
import 'package:http/http.dart' as http;

/*
Test
*/
class StationsProvider with ChangeNotifier {
  StationsProvider() {
    this.fetchTasks();
  }

  List<Station> _stations = [];

  List<Station> get stations {
    return [..._stations];
  }

  fetchTasks() async {
    // Android Emulator
    //final url = Uri.parse('http://10.0.2.2:8000/apis/v1/?format=json');

    // Chrome Emulator
    final url = Uri.parse('http://localhost:8000/apis/v1/?format=json');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      _stations = data.map<Station>((json) => Station.fromJson(json)).toList();
      notifyListeners();
    }
  }
}
