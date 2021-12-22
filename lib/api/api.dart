import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuel_opt/model/fuelprice_model.dart';
import 'package:fuel_opt/model/search_options.dart';
import 'package:fuel_opt/model/search_result.dart';
import 'package:fuel_opt/widgets/search_result_list.dart';
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
    final url = Uri.parse('http://18.170.63.134:8000/apis/v1/?format=json');

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

  Future<Station> getStationDetail(var stationId) async {
    String urlstring =
        'http://18.170.63.134:8000/apis/station/' + stationId.toString();
    final url = Uri.parse(urlstring);

    var request = http.Request('GET', url);
    //request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = json.decode(await response.stream.bytesToString());
      print(data);
      Station station = Station.fromJson(data);
      return station;
    } else {
      print(response.reasonPhrase);
    }
    return Future.value(null);
  }

  Future<List<Station>?> getStations(LatLngBounds latLngBounds) async {
    String maxLat = latLngBounds.northeast.latitude.toString();
    String maxLng = latLngBounds.northeast.longitude.toString();
    String minLat = latLngBounds.southwest.latitude.toString();
    String minLng = latLngBounds.southwest.longitude.toString();

    String urlstring = 'http://18.170.63.134:8000/apis/home/?' +
        'lat_max=' +
        maxLat +
        '&lat_min=' +
        minLat +
        '&lng_max=' +
        maxLng +
        '&lng_min=' +
        minLng;
    final url = Uri.parse(urlstring);

    // Code to add api key to the header. Removed for now
    /*
    var headers = {
      'Authorization': 'Token c14ad1f7ee64ce87510454c2025480bd202b4e25'
    };
    */
    var request = http.Request('GET', url);
    //request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = json.decode(await response.stream.bytesToString()) as List;
      List<Station> stations =
          data.map<Station>((json) => Station.fromJson(json)).toList();
      return stations;
    } else {
      print(response.reasonPhrase);
    }

    return Future.value(null);
  }

  Future<List<StationResult>> getSearchResults(
      String address,
      String sortByPreference,
      String fuelTypePreference,
      String distancePreference) async {
    String urlstring = 'http://18.170.63.134:8000/apis/search/?' +
        'user_preference=' +
        sortByPreference +
        '&location=' +
        address +
        '&fuel_type=' +
        fuelTypePreference +
        '&distance=' +
        distancePreference.toString() +
        '&amenities=';

    final url = Uri.parse(urlstring);
    print(url);

    final response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      List<StationResult> stations = data
          .map<StationResult>((json) => StationResult.fromJson(json))
          .toList();
      print(stations);
      return stations;
    } else {
      return [];
      // throw Exception('Failed to load data');
    }
  }

  Future<bool> updateInfo(
    int staionId,
    HashMap info,
    String token,
  ) async {
    String urlstring = 'http://18.170.63.134:8000/apis/review/?' +
        'station=' +
        staionId.toString() +
        '&close=' +
        info['closed'] +
        '&congestion=' +
        info['congestion'] +
        '&unleaded_price=' +
        info['unleaded'] +
        '&diesel_price=' +
        info['diesel'] +
        '&super_unleaded_price=' +
        info['superUnleaded'] +
        '&premium_diesel_price=' +
        info['premiumDiesel'];

    final url = Uri.parse(urlstring);
    print(url);
    final response = await http.post(
      url,
      headers: {"Authorization": token},
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateImage(
    int staionId,
    File image,
    String token,
  ) async {
    String urlstring = 'http://18.170.63.134:8000/apis/review/?' +
        'station=' +
        staionId.toString();

    final url = Uri.parse(urlstring);
    print(url);
    var request = http.MultipartRequest(
      'POST',
      url,
    );
    var headers = {'Token': token};
    var pic = await http.MultipartFile.fromPath("file_field", image.path);
    request.files.add(pic);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

class AccountFunctionality {
  static final AccountFunctionality _singleton =
      AccountFunctionality._internal();
  static String accessToken = "None";

  factory AccountFunctionality() {
    return _singleton;
  }
  AccountFunctionality._internal();

  Future<bool> login(String username, String password) async {
    String urlstring = 'http://18.170.63.134:8000/rest-auth/login/';
    final url = Uri.parse(urlstring);

    var headers = {
      'Cookie':
          'csrftoken=K1owRiTNo7RrFq0rzhTnjVBfSTKFU75UcDhfQ5DNvivj9VdVTMAt7tf43yuV9l1z; sessionid=an1iavdzd2nkg5xknbiz2of47mazdged'
    };
    var request = http.MultipartRequest('POST', url);
    request.fields.addAll({'username': username, 'password': password});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = json.decode(await response.stream.bytesToString());
      accessToken = data['key'];
      return true;
    } else {
      print(response.reasonPhrase);
      return false;
    }
  }

  Future<bool> register(
      String username, String password1, String password2) async {
    String urlstring = 'http://18.170.63.134:8000/rest-auth/registration/';
    final url = Uri.parse(urlstring);
    var headers = {
      'Cookie':
          'csrftoken=GKN1Aw84tj6UqOqPysdO5mHToLWX27PPUAjIKMS90BAeOdZdlChPkILPGATG1QNs; messages=.eJylzDEKwzAMheGrCM9ucEpD10KP0DEEIxzHVbEkiJyht29K125Z3-P7x9HF-DKVyNkMS3Y--HPw7q6y0MrYSAXyiZEqWJYGTUFwJl7xySh9uJXv1yXlzk3-b27w7rGltC_LVusbjIrkGUgA7RfrwwF8GY7g646nD3m5WW0:1mkteS:kkLoOlsjUpjwORevvqOf8JLR7BEjqIWW7eyHVnl_QXw; sessionid=vorq1y4aw5973hp9ezplb7yqz12himfq'
    };
    var request = http.MultipartRequest('POST', url);
    request.fields.addAll(
        {'username': username, 'password1': password1, 'password2': password1});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      var data = json.decode(await response.stream.bytesToString());
      accessToken = data['key'];
      return true;
    } else {
      print(response.reasonPhrase);
      return false;
    }
  }

  String getAccessToken() {
    return accessToken;
  }
}
