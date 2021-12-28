import 'package:fuel_opt/model/search_result.dart';
import 'package:flutter/material.dart';
import 'package:fuel_opt/model/filter_enums.dart';

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

  void addFacilitiesPreference(String facility){
    facilitiesPreference.add(facility);
    notifyListeners();
  }

  void removeFacilitiesPreference(String facility){
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
}
