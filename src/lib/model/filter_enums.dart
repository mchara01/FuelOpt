enum SortByPreference { NONE, PRICE, TIME_TO_ARRIVAL, CARBON_EMISSION }

extension SortByPreferenceExtension on SortByPreference {
  String get string {
    return ['', 'price', 'time', 'eco'][index];
  }
}

enum FuelTypePreference {
  NONE,
  UNLEADED,
  SUPER_UNLEADED,
  DIESEL,
  PREMIUM_DIESEL
}

extension FuelTypePreferenceExtension on FuelTypePreference {
  String get string {
    return [
      '',
      'unleaded',
      'super_unleaded',
      'diesel',
      'premium_diesel'
    ][index];
  }

  String get displayString {
    return [
      '',
      'Unleaded',
      'Super Unleaded',
      'Diesel Price',
      'Premium Diesel'
    ][index];
  }
}