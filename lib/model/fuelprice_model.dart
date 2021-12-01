class FuelPrice {
  final int stationId;
  final String? unleadedPrice;
  final String? dieselPrice;
  final String? superUnleadedPrice;
  final String? premiumDieselPrice;
  final String? unleadedDate;
  final String? dieselDate;
  final String? superUnleadedDate;
  final String? premiumDieselDate;

  FuelPrice(
      {required this.stationId,
      required this.unleadedPrice,
      required this.dieselPrice,
      required this.superUnleadedPrice,
      required this.premiumDieselPrice,
      required this.unleadedDate,
      required this.dieselDate,
      required this.superUnleadedDate,
      required this.premiumDieselDate});

  factory FuelPrice.fromJson(Map<String, dynamic> json) {
    return FuelPrice(
        stationId: json['station'],
        unleadedPrice: json['unleaded_price'],
        dieselPrice: json['diesel_price'],
        superUnleadedPrice: json['super_unleaded_price'],
        premiumDieselPrice: json['premium_diesel_price'],
        unleadedDate: json['unleaded_date'],
        dieselDate: json['diesel_date'],
        superUnleadedDate: json['super_unleaded_date'],
        premiumDieselDate: json['premium_diesel_date']);
  }
}
