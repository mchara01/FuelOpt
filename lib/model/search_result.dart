import 'package:fuel_opt/model/fuelprice_model.dart';
import 'package:fuel_opt/model/stations_data_model.dart';

class StationResult extends Station {
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
  final String? duration;
  final FuelPrice price;
  final String? distance;
  final String? emission;

  StationResult({
    required int station_id,
    required String name,
    required String street,
    required double latitude,
    required double longitude,
    required String postcode,
    required int car_wash,
    required int air_and_water,
    required int car_vacuum,
    required int number_24_7_opening_hours,
    required int toilet,
    required int convenience_store,
    required int atm,
    required int parking_facilities,
    required int disabled_toilet_baby_change,
    required int alcohol,
    required int wi_fi,
    required int hgv_psv_fueling,
    required int fuelservice,
    required int payphone,
    required int restaurant,
    required int electric_car_charging,
    required int repair_garage,
    required int shower_facilities,
    this.duration,
    required this.price,
    this.distance,
    this.emission
  }) : super(
          station_id: station_id,
          name: name,
          street: street,
          latitude: latitude,
          longitude: longitude,
          postcode: postcode,
          car_wash: car_wash,
          air_and_water: air_and_water,
          car_vacuum: car_vacuum,
          number_24_7_opening_hours: number_24_7_opening_hours,
          toilet: toilet,
          convenience_store: convenience_store,
          atm: atm,
          parking_facilities: parking_facilities,
          disabled_toilet_baby_change: disabled_toilet_baby_change,
          alcohol: alcohol,
          wi_fi: wi_fi,
          hgv_psv_fueling: hgv_psv_fueling,
          fuelservice: fuelservice,
          payphone: payphone,
          restaurant: restaurant,
          electric_car_charging: electric_car_charging,
          repair_garage: repair_garage,
          shower_facilities: shower_facilities,
        );

  factory StationResult.fromJson(Map<String, dynamic> json) {
    return StationResult(
        // Station station = Station.fromJson(json),
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
        disabled_toilet_baby_change: json['disabled_toilet_baby_change'],
        alcohol: json['alcohol'],
        wi_fi: json['wi_fi'],
        hgv_psv_fueling: json['hgv_psv_fueling'],
        fuelservice: json['fuelservice'],
        payphone: json['payphone'],
        restaurant: json['restaurant'],
        electric_car_charging: json['electric_car_charging'],
        repair_garage: json['repair_garage'],
        shower_facilities: json['shower_facilities'],
        duration: json['duration'],
        price: FuelPrice.fromJson(json['prices']),
        distance: json['distance'],
        emission: json['emission']
    );
  }
}
