import 'package:fuel_opt/model/search_result.dart';

class SearchOptions {
  late String location = 'Imperial College London';
  FilterOptions filterOptions = FilterOptions(
    sort_by: 'duration',
    fuel_type: 'unleaded',
    distance: 50,
  );
  List<StationResult?> result = [];
}

class FilterOptions {
  late String sort_by;
  late String fuel_type;
  late double distance;

  FilterOptions({
    required this.sort_by,
    required this.fuel_type,
    required this.distance,
  });
}
