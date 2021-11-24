import 'package:flutter/material.dart';
import 'package:fuel_opt/model/search_options.dart';
import 'package:fuel_opt/model/search_result.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart' as appColors;

class SearchInfo extends StatefulWidget {
  final StationResult? station;
  const SearchInfo({Key? key, required this.station}) : super(key: key);

  @override
  _SearchInfoState createState() => _SearchInfoState();
}

class _SearchInfoState extends State<SearchInfo> {
  Widget build(BuildContext context) {
    final state = Provider.of<SearchOptions>(context);

    List<String> facilities = [
      "car_wash",
      "air_and_water",
      "car_vacuum",
      "number_24_7_opening_hours",
      "toilet",
      "convenience_store",
      "atm",
      "parking_facilities",
      "disabled_toilet_baby_change",
      "alcohol",
      "wi_fi",
      "hgv_psv_fueling",
      "fuelservice",
      "payphone",
      "restaurant",
      "electric_car_charging",
      "repair_garage",
      "shower_facilities",
    ];

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: appColors.PrimaryBlue,
                size: 15,
              ),
              Column(
                children: [
                  Text(
                    widget.station!.name,
                    style: TextStyle(color: appColors.PrimaryBlue),
                  ),
                  Text(
                    widget.station!.street,
                  ),
                  Text(
                    widget.station!.postcode,
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Icon(
                Icons.attach_money,
                color: appColors.PrimaryBlue,
                size: 15,
              ),
              Text('Petrol Price'),
              Column(children: [
                Row(
                  children: [
                    Text('Unleaded'),
                    Text(widget.station!.price.unleadedPrice.toString())
                  ],
                ),
                Row(
                  children: [
                    Text('Super Unleaded'),
                    Text(widget.station!.price.superUnleadedPrice.toString())
                  ],
                ),
                Row(
                  children: [
                    Text('Diesel'),
                    Text(widget.station!.price.dieselPrice.toString())
                  ],
                ),
                Row(
                  children: [
                    Text('Premium Disel'),
                    Text(widget.station!.price.dieselPrice.toString())
                  ],
                ),
              ])
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Icon(
                Icons.miscellaneous_services,
                color: appColors.PrimaryBlue,
                size: 15,
              ),
              Text('Facilities'),
              Wrap(),
            ],
          ),
          // for (var facility in facilities) {
          //   if widget.station.
          // }
        ],
      ),
    );
  }
}
