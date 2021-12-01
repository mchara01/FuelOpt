import 'package:flutter/material.dart';
import 'package:fuel_opt/widgets/border_box.dart';
import '../utils/appColors.dart' as appColors;
import 'package:fuel_opt/widgets/options_button.dart';
import '../utils/theme.dart' as appTheme;

class TrendScreen extends StatelessWidget {
  const TrendScreen({Key? key}) : super(key: key);

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
                    "Trends",
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
                child: Text("Trends",
                    style: appTheme.TEXT_THEME_DEFAULT.subtitle1),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
