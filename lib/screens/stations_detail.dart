import 'package:flutter/material.dart';
import 'package:fuel_opt/widgets/border_box.dart';
import 'package:fuel_opt/widgets/options_button.dart';
import '../utils/appColors.dart' as appColors;
import '../utils/theme.dart' as appTheme;
import 'package:fuel_opt/api/api.dart';
import 'package:fuel_opt/model/stations_model.dart';

class StationsDetail extends StatelessWidget {
  int stationId;

/**
 * 
 * late String station_address;
  late String station_name;
  late String station_price_diesel;
  late String station_price_super_unleaded;
  late String station_price_premium_unleaded;
  late String station_unleaded;
 */

  StationsDetail(this.stationId) {
    stationId = stationId;
    //fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double padding = 25;
    final EdgeInsets horizontalPadding =
        EdgeInsets.symmetric(horizontal: padding);
    final dynamic itemData;

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
                            child: Icon(
                              Icons.keyboard_backspace,
                              color: appColors.COLOR_BLACK,
                            )),
                        OptionButton(
                            icon: Icons.directions,
                            text: "Directions",
                            width: size.width * 0.4),
                      ],
                    ),
                  ),
                  SizedBox(height: padding),
                  Padding(
                      padding: horizontalPadding,
                      child: Text(
                        "Test",
                        style: appTheme.TEXT_THEME_DEFAULT.bodyText2,
                      )),
                  SizedBox(height: 10),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: Text(
                        "Station Name Here",
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
                        "Groceries",
                        "Car Wash",
                        "24/7",
                        "Toilet",
                        "Parking"
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
                            child: Text(
                              "£0.99",
                              style: appTheme.TEXT_THEME_DEFAULT.subtitle1,
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
                            child: Text(
                              "£0.99",
                              style: appTheme.TEXT_THEME_DEFAULT.subtitle1,
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
                            child: Text(
                              "£0.99",
                              style: appTheme.TEXT_THEME_DEFAULT.subtitle1,
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
                            child: Text(
                              "£0.99",
                              style: appTheme.TEXT_THEME_DEFAULT.subtitle1,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Unleaded",
                            style: appTheme.TEXT_THEME_DEFAULT.headline6,
                          ),
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
                    child: OptionButton(
                        icon: Icons.map_rounded,
                        text: "Review Stations",
                        width: size.width * 0.5),
                  ))
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
