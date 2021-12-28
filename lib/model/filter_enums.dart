enum SortByPreference { NONE, PRICE, TIME_TO_ARRIVAL }

extension SortByPreferenceExtension on SortByPreference {
  String get string {
    return ['none', 'price', 'time'][index];
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
      'none',
      'unleaded',
      'super_unleaded',
      'diesel',
      'premium_diesel'
    ][index];
  }
}
