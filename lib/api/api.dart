import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
    final url = Uri.parse('http://10.0.2.2:8000/apis/v1/?format=json');

    // Chrome Emulator
    //final url = Uri.parse('http://localhost:8000/apis/v1/?format=json');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      _stations = data.map<Station>((json) => Station.fromJson(json)).toList();
      notifyListeners();
    }
  }
}

class FuelStationDataService {
  List<Station> _stations = [];

  List<Station> get stations {
    return [..._stations];
  }

  Future<List<Station>?> getStations(LatLngBounds latLngBounds) async {
    String maxLat = latLngBounds.northeast.latitude.toString();
    String maxLng = latLngBounds.northeast.longitude.toString();
    String minLat = latLngBounds.southwest.latitude.toString();
    String minLng = latLngBounds.southwest.longitude.toString();

    String urlstring = 'http://127.0.0.1:8000/apis/home/?' +
        'lat_max=' +
        maxLat +
        '&lat_min=' +
        minLat +
        '&lng_max=' +
        maxLng +
        '&lng_min=' +
        minLng;
    final url = Uri.parse(urlstring);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      List<Station> stations =
          data.map<Station>((json) => Station.fromJson(json)).toList();
      return stations;
    }

    return Future.value(null);
  }
}
