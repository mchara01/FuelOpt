class Station {
  final int id;
  final String name;
  final String location;
  final double lat;
  final double lng;
  final String postcode;

  Station({required this.id, required this.name, required this.location, required this.lat, required this.lng, required this.postcode,});

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      lat: json['lat'],
      lng: json['lng'],
      postcode: json['postcode']
    );
  }
}
