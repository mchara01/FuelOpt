import 'fuelprice_model.dart';

class Station {
  final int station_id;
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
  late final FuelPrice price;


  Station({
    required this.station_id,
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
    required this.price,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      station_id: json['station_id'],
      name: json['name'],
      street: json['street'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      postcode: json['postcode'],
      car_wash: json['car_wash'],
      air_and_water: json['air_and_water'],
      car_vacuum: json['car_vacuum'],
      number_24_7_opening_hours: json['number_24_7_opening_hours'],
      toilet: json['toilet'],
      convenience_store: json['convenience_store'],
      atm: json['atm'],
      parking_facilities: json['parking_facilities'],
      disabled_toilet_baby_change:
          json['disabled_toilet_baby_change'],
      alcohol: json['alcohol'],
      wi_fi: json['wi_fi'],
      hgv_psv_fueling: json['hgv_psv_fueling'],
      fuelservice: json['fuelservice'],
      payphone: json['payphone'],
      restaurant: json['restaurant'],
      electric_car_charging: json['electric_car_charging'],
      repair_garage: json['repair_garage'],
      shower_facilities: json['shower_facilities'],
      price: FuelPrice.fromJson(json['prices']),
    );
  }
}
