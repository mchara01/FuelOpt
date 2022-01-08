import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:fuel_opt/model/search_result.dart';
import 'package:fuel_opt/model/stations_data_model.dart';
import 'package:fuel_opt/model/top_3_station_result.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

/*
Test
*/

class FuelStationDataService {
  List<Station> _stations = [];

  List<Station> get stations {
    return [..._stations];
  }

  Future<List> address2Coordinates(String location) async {
    String urlstring =
        "https://eu1.locationiq.com/v1/search.php?key=pk.bd315221041f3e0a99e6464f9de0157a" +
            "&q=" +
            location.replaceAll(' ', '%20') +
            "&format=json";
    final url = Uri.parse(urlstring);
    var request = http.Request('GET', url);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = json.decode(await response.stream.bytesToString());
      final validMap =
          json.decode(json.encode(data[0])) as Map<String, dynamic>;
      if (validMap.containsKey('lat')) {
        return [validMap['lat'], validMap['lon']];
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  Future<List> postcode2Coordinates(String postcode) async {
    String urlstring =
        "http://api.getthedata.com/postcode/" + postcode.replaceAll(' ', '+');
    final url = Uri.parse(urlstring);
    var request = http.Request('GET', url);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = json.decode(await response.stream.bytesToString());
      if (data.containsKey('data')) {
        if (data['data'].containsKey('latitude')) {
          return [data['data']['latitude'], data['data']['longitude']];
        } else {
          return [];
        }
      } else {
        return [];
      }
    } else {
      return [];
    }
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
      List<StationResult> stations = data
          .map<StationResult>((json) => StationResult.fromJson(json))
          .toList();
      return stations;
    } else {
      print(response.reasonPhrase);
    }

    return Future.value([]);
  }

  Future<List<Station>> getSearchResults(
      String address,
      String sortByPreference,
      String fuelTypePreference,
      String distancePreference,
      String facilitiesPreference,
      String lat,
      String lng) async {
    String urlstring = 'http://18.170.63.134:8000/apis/search/?' +
        'user_preference=' +
        sortByPreference +
        '&location=' +
        address +
        '&fuel_type=' +
        fuelTypePreference +
        '&distance=' +
        distancePreference.toString() +
        '&amenities=' +
        facilitiesPreference
            .replaceAll('{', "")
            .replaceAll("}", "")
            .replaceAll(" ", "") +
        '&lat=' +
        lat.toString() +
        '&lng=' +
        lng.toString();

    final url = Uri.parse(urlstring);
    print(url);

    final response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      List<Station> stations = [];
      if (data.isNotEmpty) {
        var firstElement = data[0] as Map;
        if (firstElement.containsKey('fuel_type')) {
          stations = data
              .map<Top3StationResult>(
                  (json) => Top3StationResult.fromJson(json))
              .toList();
        } else {
          stations = data
              .map<StationResult>((json) => StationResult.fromJson(json))
              .toList();
        }
      }
      return stations;
    } else {
      return [];
    }
  }

  Future<int> updateInfo(
    int stationId,
    HashMap info,
    String token,
  ) async {
    String urlstring = 'http://18.170.63.134:8000/apis/review/?';

    final url = Uri.parse(urlstring);

    var request = http.MultipartRequest('POST', url);
    request.fields.addAll({
      "station": stationId.toString(),
      'open': info['open'],
      'congestion': info['congestion'],
      'unleaded_price': info['unleaded'],
      'diesel_price': info['diesel'],
      'super_unleaded_price': info['superUnleaded'],
      'premium_diesel_price': info['premiumDiesel'],
    });
    var headers = {
      "Authorization": 'Token ' + token,
    };
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    print(response.statusCode);

    // if the receipt got accepted
    if (response.statusCode == 200) {
      return 1;
    } else if (response.statusCode == 555) {
      // anomalous price
      return 2;
    } else {
      return 0;
    }
  }

  Future<bool> updateImage(
    int stationId,
    File image,
    String token,
  ) async {
    String urlstring = 'http://18.170.63.134:8000/apis/review/?' +
        'station=' +
        stationId.toString();

    final url = Uri.parse(urlstring);
    print(url);
    var request = http.MultipartRequest(
      'POST',
      url,
    )..fields["station"] = stationId.toString();
    var headers = {"Authorization": 'Token ' + token};
    var pic = await http.MultipartFile.fromPath("receipt", image.path);
    request.files.add(pic);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    print(response.statusCode);
    // if the receipt was accepted
    if (response.statusCode == 200) {
      return true;
      // if the receipt was not accepted or errored out
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

  Future<bool> logout() async {
    String urlstring = 'http://18.170.63.134:8000/rest-auth/logout/';
    final url = Uri.parse(urlstring);
    var request = http.MultipartRequest('POST', url);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      accessToken = "None";
      return true;
    } else {
      return false;
    }
  }

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
