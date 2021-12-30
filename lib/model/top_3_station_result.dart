import 'package:fuel_opt/model/filter_enums.dart';
import 'package:fuel_opt/model/search_result.dart';
import 'package:fuel_opt/model/stations_data_model.dart';

class Top3StationResult extends Station {
  final FuelTypePreference fuelTypePreference;
  final List<StationResult> top3Stations;

  Top3StationResult({
    required this.fuelTypePreference,
    required this.top3Stations
});

  factory Top3StationResult.fromJson(Map<String, dynamic> json) {
    print((json['Top 3 Stations'] as List).map((stationResult) => StationResult.fromJson(stationResult)).toList());
    return Top3StationResult(
      fuelTypePreference: FuelTypePreference.values.firstWhere((e) => e.string == json['fuel_type'] as String),
      top3Stations: (json['Top 3 Stations'] as List).map((stationResult) => StationResult.fromJson(stationResult)).toList()
    );
  }
}