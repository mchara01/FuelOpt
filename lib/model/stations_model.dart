class Station {
  final int id;
  final String name;
  final String street;
  final double latitude;
  final double longitude;
  final String postcode;
  final int car_wash;
  final int air_and_water;
  final int car_vacuum;
  final int number_24_7_opening_hours;
  final int toilet;
  final int convenience_store;
  final int atm;
  final int parking_facilities;
  final int disabled_toilet_baby_change;
  final int alcohol;
  final int wi_fi;
  final int hgv_psv_fueling;
  final int fuelservice;
  final int payphone;
  final int restaurant;
  final int electric_car_charging;
  final int repair_garage;
  final int shower_facilities;

  Station({
    required this.id,
    required this.name,
    required this.street,
    required this.latitude,
    required this.longitude,
    required this.postcode,
    required this.car_wash,
    required this.air_and_water,
    required this.car_vacuum,
    required this.number_24_7_opening_hours,
    required this.toilet,
    required this.convenience_store,
    required this.atm,
    required this.parking_facilities,
    required this.disabled_toilet_baby_change,
    required this.alcohol,
    required this.wi_fi,
    required this.hgv_psv_fueling,
    required this.fuelservice,
    required this.payphone,
    required this.restaurant,
    required this.electric_car_charging,
    required this.repair_garage,
    required this.shower_facilities,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'],
      name: json['name'],
      street: json['street'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      postcode: json['postcode'],
      car_wash: int.parse(json['car_wash']),
      air_and_water: int.parse(json['air_and_water']),
      car_vacuum: int.parse(json['car_vacuum']),
      number_24_7_opening_hours: int.parse(json['number_24_7_opening_hours']),
      toilet: int.parse(json['toilet']),
      convenience_store: int.parse(json['convenience_store']),
      atm: int.parse(json['atm']),
      parking_facilities: int.parse(json['parking_facilities']),
      disabled_toilet_baby_change:
          int.parse(json['disabled_toilet_baby_change']),
      alcohol: int.parse(json['alcohol']),
      wi_fi: int.parse(json['wi_fi']),
      hgv_psv_fueling: int.parse(json['hgv_psv_fueling']),
      fuelservice: int.parse(json['fuelservice']),
      payphone: int.parse(json['payphone']),
      restaurant: int.parse(json['restaurant']),
      electric_car_charging: int.parse(json['electric_car_charging']),
      repair_garage: int.parse(json['repair_garage']),
      shower_facilities: int.parse(json['shower_facilities']),
    );
  }
}
