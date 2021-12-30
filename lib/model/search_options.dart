import 'package:flutter/material.dart';
import 'package:fuel_opt/model/filter_enums.dart';
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
  double distancePreference = 30;

  void setDistancePreference(double distancePreference) {
    this.distancePreference = distancePreference;
    notifyListeners();
  }
}

class SearchResultModel extends ChangeNotifier {
  List<Station> stations = [];

  void setSearchResult(List<Station> stations) {
    this.stations = stations;
    notifyListeners();
  }
}
