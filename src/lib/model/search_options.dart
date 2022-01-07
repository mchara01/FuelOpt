import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:fuel_opt/model/filter_enums.dart';
import 'package:fuel_opt/model/search_result.dart';
import 'package:fuel_opt/model/stations_data_model.dart';

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
  double distancePreference = 5;

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
  List<Station> stations = [];

  void setSearchResult(List<Station> stations) {
    this.stations = stations;
    notifyListeners();
  }

  void updateSearchResult(int stationId, HashMap<String, String> info) {
    List<StationResult> stationResultList = stations.cast<StationResult>();
    for (var i = 0; i < stationResultList.length; i++) {
      if (stationResultList[i].station_id == stationId) {
        if (info['unleaded'] != "") {
          if (info['unleaded'] == "0") {
            stationResultList[i].price.unleadedPrice = null;
          } else {
            stationResultList[i].price.unleadedPrice = info['unleaded'];
          }
        }
        if (info['diesel'] != "") {
          if (info['diesel'] == "0") {
            stationResultList[i].price.dieselPrice = null;
          } else {
            stationResultList[i].price.dieselPrice = info['diesel'];
          }
        }
        if (info['superUnleaded'] != "") {
          if (info['superUnleaded'] == "0") {
            stationResultList[i].price.superUnleadedPrice = null;
          } else {
            stationResultList[i].price.superUnleadedPrice = info['superUnleaded'];
          }
        }
        if (info['premiumDiesel'] != "") {
          if (info['premiumDiesel'] == "0") {
            stationResultList[i].price.premiumDieselPrice = null;
          } else {
            stationResultList[i].price.premiumDieselPrice = info['premiumDiesel'];
          }
        }
        notifyListeners();
      }
    }
  }
}
