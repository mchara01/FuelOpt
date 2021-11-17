class SearchOptions {
  late String location = 'Imperial College London';
  FilterOptions filterOptions = FilterOptions(
    sort_by: 'Price',
    fuel_type: 'Unleaded',
    distance: 50,
  );
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
