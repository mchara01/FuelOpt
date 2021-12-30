import 'package:flutter/material.dart';
import 'package:fuel_opt/model/search_result.dart';
import 'package:fuel_opt/screens/login_screen.dart';
import 'package:fuel_opt/screens/registration_screen.dart';
import 'package:fuel_opt/screens/review_screen.dart';
import 'package:fuel_opt/widgets/border_box.dart';
import 'package:fuel_opt/widgets/options_button.dart';
import '../utils/appColors.dart' as appColors;
import '../utils/theme.dart' as appTheme;
import 'package:fuel_opt/api/api.dart';
import 'package:fuel_opt/model/stations_data_model.dart';

class StationsDetail extends StatelessWidget {
  StationResult station;

  StationsDetail(this.station) {
    station = station;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double padding = 25;
    final EdgeInsets horizontalPadding =
        EdgeInsets.symmetric(horizontal: padding);

    return Scaffold(
      body: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Padding(
                    padding: horizontalPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BorderBox(
                            padding: EdgeInsets.all(0),
                            width: 50,
                            height: 50,
                            child: IconButton(
                              icon: Icon(Icons.keyboard_backspace),
                              color: appColors.COLOR_BLACK,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )),
                        OptionButton(
                            icon: Icons.directions,
                            text: "Directions",
                            width: size.width * 0.4),
                      ],
                    ),
                  ),
                  // SizedBox(height: padding),
                  // Padding(
                  //     padding: horizontalPadding,
                  //     child: Text(
                  //       "Test",
                  //       style: appTheme.TEXT_THEME_DEFAULT.bodyText2,
                  //     )),
                  SizedBox(height: 10),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: Text(
                        station.name,
                        style: appTheme.TEXT_THEME_DEFAULT.headline1,
                      )),
                  Padding(
                      padding: horizontalPadding,
                      child: Divider(
                        height: padding,
                        color: appColors.COLOR_GREY,
                      )),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        if (station.car_wash == 1) "Car Wash",
                        if (station.air_and_water == 1) "Air and Water",
                        if (station.car_vacuum == 1) "Car Vacuum",
                        if (station.number_24_7_opening_hours == 1) "24/7",
                        if (station.toilet == 1) "Toilet",
                        if (station.convenience_store == 1)
                          "Cconvenience Store",
                        if (station.atm == 1) "ATM",
                        if (station.parking_facilities == 1) "Parking",
                        if (station.disabled_toilet_baby_change == 1)
                          "Disabled Toilet",
                        if (station.alcohol == 1) "Alcohol",
                        if (station.wi_fi == 1) "WIFI",
                        if (station.hgv_psv_fueling == 1) "Hgv Psv",
                        if (station.fuelservice == 1) "Fuel Service",
                        if (station.payphone == 1) "Pay by Phone",
                        if (station.restaurant == 1) "Restaurant",
                        if (station.electric_car_charging == 1)
                          "Electric Car Charging",
                        if (station.repair_garage == 1) "Repair Garage",
                        if (station.shower_facilities == 1) "Shower",
                      ].map((filter) => ChoiceOption(text: filter)).toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          BorderBox(
                            padding: EdgeInsets.all(0),
                            width: size.width * 0.4,
                            height: 50,
                            child: station.price.dieselPrice.toString() !=
                                    'null'
                                ? Text(
                                    station.price.dieselPrice.toString() + 'p',
                                    style:
                                        appTheme.TEXT_THEME_DEFAULT.subtitle1,
                                  )
                                : Text(
                                    '--',
                                    style:
                                        appTheme.TEXT_THEME_DEFAULT.subtitle1,
                                  ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Diesel",
                            style: appTheme.TEXT_THEME_DEFAULT.headline6,
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: [
                          BorderBox(
                            padding: EdgeInsets.all(0),
                            width: size.width * 0.4,
                            height: 50,
                            child: station.price.superUnleadedPrice
                                        .toString() !=
                                    'null'
                                ? Text(
                                    station.price.superUnleadedPrice
                                            .toString() +
                                        'p',
                                    style:
                                        appTheme.TEXT_THEME_DEFAULT.subtitle1,
                                  )
                                : Text(
                                    '--',
                                    style:
                                        appTheme.TEXT_THEME_DEFAULT.subtitle1,
                                  ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Super Unleaded",
                            style: appTheme.TEXT_THEME_DEFAULT.headline6,
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Fuel Types
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          BorderBox(
                            padding: EdgeInsets.all(0),
                            width: size.width * 0.4,
                            height: 50,
                            child: station.price.premiumDieselPrice
                                        .toString() !=
                                    'null'
                                ? Text(
                                    station.price.premiumDieselPrice
                                            .toString() +
                                        'p',
                                    style:
                                        appTheme.TEXT_THEME_DEFAULT.subtitle1,
                                  )
                                : Text(
                                    '--',
                                    style:
                                        appTheme.TEXT_THEME_DEFAULT.subtitle1,
                                  ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Premium Diesel",
                            style: appTheme.TEXT_THEME_DEFAULT.headline6,
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: [
                          BorderBox(
                            padding: EdgeInsets.all(0),
                            width: size.width * 0.4,
                            height: 50,
                            child: station.price.unleadedPrice.toString() !=
                                    'null'
                                ? Text(
                                    station.price.unleadedPrice.toString() +
                                        'p',
                                    style:
                                        appTheme.TEXT_THEME_DEFAULT.subtitle1,
                                  )
                                : Text(
                                    '--',
                                    style:
                                        appTheme.TEXT_THEME_DEFAULT.subtitle1,
                                  ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Unleaded",
                            style: appTheme.TEXT_THEME_DEFAULT.headline6,
                          )
                        ],
                      ),
                      SizedBox(width: 10),
                    ],
                  )
                ],
              ),
              Positioned(
                bottom: 20,
                width: size.width,
                child: Center(
                  child: TextButton.icon(
                    onPressed: () async {
                      AccountFunctionality accountFunctionality =
                          AccountFunctionality();
                      String token =
                          await accountFunctionality.getAccessToken();
                      // token = 'Token 50ccba64d862962d71639294c5bb1f83808e6cd1';

                      if (token == 'None') {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ReviewScreen(station.station_id, token)));
                      }
                    },
                    icon: Icon(
                      Icons.map_rounded,
                      color: appColors.PrimaryBlue,
                    ),
                    label: Text(
                      'Review Stations',
                      style: TextStyle(
                          color: appColors.PrimaryBlue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class ChoiceOption extends StatelessWidget {
  final String text;
  const ChoiceOption({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: appColors.COLOR_GREY.withAlpha(25)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      margin: const EdgeInsets.only(left: 10),
      child: Text(text, style: appTheme.TEXT_THEME_DEFAULT.headline5),
    );
  }
}
