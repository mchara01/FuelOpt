import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuel_opt/api/api.dart';
import 'package:fuel_opt/screens/login_screen.dart';
import 'package:fuel_opt/screens/trend_screen.dart';
import 'package:fuel_opt/screens/instructions_screen.dart';
import 'package:provider/provider.dart';

import '../model/search_options.dart';
import '../utils/app_colors.dart' as appColors;

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Material(
            color: appColors.PrimaryBlue,
            child: ListView(
              padding: padding,
              children: <Widget>[
                const SizedBox(height: 48),
                buildMenuItem(
                    text: 'Trends',
                    icon: Icons.trending_up_sharp,
                    onClicked: () => selectedItem(context, 0)),
                buildMenuItem(
                    text: 'Instructions',
                    icon: Icons.help,
                    onClicked: () => selectedItem(context, 1)),
                Divider(
                  color: Colors.white,
                ),
                buildMenuItem(
                    text: 'Sign Out',
                    icon: Icons.help,
                    onClicked: () => selectedItem(context, 2)),
              ],
            )));
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;

    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: TextStyle(color: color),
      ),
      onTap: onClicked,
    );
  }

  selectedItem(BuildContext context, int index) async {
    switch (index) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TrendScreen()));
        break;
      case 1:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => InstructionsScreen()));
        break;
      case 2:
        AccountFunctionality accountFunctionality = AccountFunctionality();

        bool output = await accountFunctionality.logout();
        if (output) {
          Fluttertoast.showToast(msg: "Logout Successful");
        }
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));
        break;
    }
  }
}
