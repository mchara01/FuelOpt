enum SortByPreference { NONE, PRICE, TIME_TO_ARRIVAL }

extension SortByPreferenceExtension on SortByPreference {
  String get string {
    return ['none', 'price', 'duration'][index];
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
      'unleaded_price',
      'super_unleaded_price',
      'diesel_price',
      'premium_diesel_price'
    ][index];
  }

  String get displayString {
    return [
      'None',
      'Unleaded',
      'Super Unleaded',
      'Diesel Price',
      'Premium Diesel'
    ][index];
  }
}
