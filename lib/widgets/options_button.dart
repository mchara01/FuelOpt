import 'package:flutter/material.dart';
import '../utils/appColors.dart' as appColors;
import '../utils/theme.dart' as appTheme;

class OptionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final double width;

  const OptionButton(
      {Key? key, required this.text, required this.icon, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: appColors.PrimaryBlue,
      child: Container(
        width: width,
        child: MaterialButton(
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {},
            child: Row(
              children: [
                Icon(icon, color: appColors.COLOR_White),
                SizedBox(width: 10),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            )),
      ),
    );
  }
}
