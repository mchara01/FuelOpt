import 'dart:collection';

import 'package:fuel_opt/model/search_result.dart';
import 'package:flutter/material.dart';
import 'package:fuel_opt/model/filter_enums.dart';
import 'package:fuel_opt/model/fuelprice_model.dart';

class SearchQueryModel extends ChangeNotifier {
  String searchQuery = '';

  void setSearchQuery(String searchQuery) {
    this.searchQuery = searchQuery;

    notifyListeners();
  }
}

class SortByPreferenceModel extends ChangeNotifier {
  SortByPreference sortByPreference = SortByPreference.NONE;

  void setSortByPreference(SortByPreference sortByPreference) {
    this.sortByPreference = sortByPreference;
    notifyListeners();
  }
}

class FuelTypePreferenceModel extends ChangeNotifier {
  FuelTypePreference fuelTypePreference = FuelTypePreference.NONE;

  void setFuelTypePreference(FuelTypePreference fuelTypePreference) {
    this.fuelTypePreference = fuelTypePreference;
    notifyListeners();
  }
}

class DistancePreferenceModel extends ChangeNotifier {
  double distancePreference = 30;

  void setDistancePreference(double distancePreference) {
    this.distancePreference = distancePreference;
    notifyListeners();
  }
}

class FacilitiesPreferenceModel extends ChangeNotifier {
  Set<String> facilitiesPreference = {};

  void setFacilitiesPreference(Set<String> facilitiesPreference) {
    this.facilitiesPreference = facilitiesPreference;
    notifyListeners();
  }

  void addFacilitiesPreference(String facility) {
    facilitiesPreference.add(facility);
    notifyListeners();
  }

  void removeFacilitiesPreference(String facility) {
    facilitiesPreference.remove(facility);
    notifyListeners();
  }
}

class SearchResultModel extends ChangeNotifier {
  List<StationResult> stations = [];

  void setSearchResult(List<StationResult> stations) {
    this.stations = stations;
    notifyListeners();
  }

  void updateSearchResult(int stationId, HashMap<String, String> info) {
    for (var i = 0; i < stations.length; i++) {
      if (stations[i].station_id == stationId) {
        if (info['unleaded'] != "") {
          if (info['unleaded'] == "0") {
            stations[i].price.unleadedPrice = null;
          } else {
            stations[i].price.unleadedPrice = info['unleaded'];
          }
        }
        if (info['diesel'] != "") {
          if (info['diesel'] == "0") {
            stations[i].price.dieselPrice = null;
          } else {
            stations[i].price.dieselPrice = info['diesel'];
          }
        }
        if (info['superUnleaded'] != "") {
          if (info['superUnleaded'] == "0") {
            stations[i].price.superUnleadedPrice = null;
          } else {
            stations[i].price.superUnleadedPrice = info['superUnleaded'];
          }
        }
        if (info['premiumDiesel'] != "") {
          if (info['premiumDiesel'] == "0") {
            stations[i].price.premiumDieselPrice = null;
          } else {
            stations[i].price.premiumDieselPrice = info['premiumDiesel'];
          }
        }
        notifyListeners();
      }
    }
  }
}
