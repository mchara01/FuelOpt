import 'package:flutter/material.dart';
import 'package:fuel_opt/model/filter_enums.dart';

class SearchOptions {
  late String location = 'Imperial College London';
  FilterOptions filterOptions = FilterOptions(
    sort_by: 'Price',
    fuel_type: 'Unleaded',
    distance: 50,
  );
}

class FilterOptions {
  String sort_by;
  String fuel_type;
  double distance;

  FilterOptions({required this.sort_by, required this.fuel_type, required this.distance});
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
  double distancePreference = 50;

  void setDistancePreference(double distancePreference) {
    this.distancePreference = distancePreference;
    notifyListeners();
  }
}
