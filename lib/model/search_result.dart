import 'package:fuel_opt/model/fuelprice_model.dart';
import 'package:fuel_opt/model/stations_model.dart';

class StationResult extends Station {
  final String duration;
  final FuelPrice price;
  final String distance;

  StationResult({
    required int id,
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
    required this.duration,
    required this.price,
    required this.distance,
  }) : super(
          id: id,
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
        duration: json['duration'],
        price: FuelPrice.fromJson(json['prices']),
        distance: json['distance']);
  }
}
