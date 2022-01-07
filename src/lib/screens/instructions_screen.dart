import 'package:flutter/material.dart';
import 'package:fuel_opt/widgets/border_box.dart';
import '../utils/appColors.dart' as appColors;
import 'package:fuel_opt/widgets/options_button.dart';
import '../utils/theme.dart' as appTheme;

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({Key? key}) : super(key: key);

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
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: Text(
                    "Instructions",
                    style: appTheme.TEXT_THEME_DEFAULT.headline1,
                  )),
              Padding(
                  padding: horizontalPadding,
                  child: Divider(
                    height: padding,
                    color: appColors.COLOR_GREY,
                  )),
              SizedBox(height: 10),
              Padding(
                padding: horizontalPadding,
                child: Column(
                  children: [
                    Text(
                      "FuelOpt is an app to help optimise your fuel-filling needs.",
                      style: appTheme.TEXT_THEME_DEFAULT.headline4,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "To use this app, you can search any address you would like on the search bar. You can apply several filters, such as filtering by distance, fuel type, and the type of facilities available at the petrol station.",
                      style: appTheme.TEXT_THEME_DEFAULT.bodyText1,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "You can sort your search via cost, time of arrival, or eco-friendliness with the help of our smart optimisation algorithms.",
                      style: appTheme.TEXT_THEME_DEFAULT.bodyText1,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "If you select a petrol station, you can use get directions to the location quickly. You can also update the rest of the community if there are differences between the apps data and real life data.",
                      style: appTheme.TEXT_THEME_DEFAULT.bodyText1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
