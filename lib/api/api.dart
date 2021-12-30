import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fuel_opt/model/search_result.dart';
import 'package:fuel_opt/model/top_3_station_result.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/stations_data_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

/*
Test
*/

class FuelStationDataService {
  List<Station> _stations = [];

  List<Station> get stations {
    return [..._stations];
  }

  Future<List<StationResult>> getStationsLocal() async {
    var jsonText = await rootBundle.loadString('assets/test.json');
    List data = jsonDecode(jsonText) as List;
    List<StationResult> stationData = data.map((stationJson) => StationResult.fromJson(stationJson)).toList();
    return stationData;
  }

  Future<StationResult> getStationDetail(var stationId) async {
    String urlstring =
        'http://18.170.63.134:8000/apis/station/' + stationId.toString();
    final url = Uri.parse(urlstring);

    var request = http.Request('GET', url);
    //request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = json.decode(await response.stream.bytesToString());
      print(data);
      StationResult station = StationResult.fromJson(data);
      return station;
    } else {
      print(response.reasonPhrase);
    }
    return Future.value(null);
  }

  Future<List<StationResult>> getStations(LatLngBounds latLngBounds) async {
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
      List<StationResult> stations =
          data.map<StationResult>((json) => StationResult.fromJson(json)).toList();
      return stations;
    } else {
      print(response.reasonPhrase);
    }

    return Future.value([]);
  }

  Future<List<Top3StationResult>> getTopThreeStationsLocal() async {
    var jsonText = await rootBundle.loadString('assets/test_top3.json');
    var jsonData = json.decode(jsonText) as List;
    List<Top3StationResult> top3StationResults = jsonData.map<Top3StationResult>((top3StationResultJson) => Top3StationResult.fromJson(top3StationResultJson)).toList();
    return top3StationResults;
  }

  Future<List<Station>> getSearchResults(
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
      List<Station> stations = [];
      if(data.isNotEmpty) {
        var firstElement = data[0] as Map;
        if(firstElement.containsKey('fuel_type')) {
          stations = data.map<Top3StationResult>((json) => Top3StationResult.fromJson(json)).toList();
        }
        else{
          stations = data.map<StationResult>((json) => StationResult.fromJson(json)).toList();
        }
      }
      return stations;
    } else {
      return [];
    }
  }

  Future<int> updateInfo(
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
    print(token);
    final response = await http.post(
      url,
      headers: {"Authorization": 'Token ' + token},
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return 1;
    } else if (response.statusCode == 500) {
      // anomalous price
      return 2;
    } else {
      return 0;
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
