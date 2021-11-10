class Station {
  final int id;
  final String name;
  final String street;
  final double latitude;
  final double longitude;
  final String postcode;

  Station({
    required this.id,
    required this.name,
    required this.street,
    required this.latitude,
    required this.longitude,
    required this.postcode,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
        id: json['station_id'],
        name: json['name'],
        street: json['street'],
        latitude: double.parse(json['latitude']),
        longitude: double.parse(json['longitude']),
        postcode: json['postcode']);
  }
}
