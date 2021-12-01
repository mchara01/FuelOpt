import 'package:flutter/material.dart';
import 'package:fuel_opt/screens/login_screen.dart';
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
                    onClicked: () => selectedItem(context, 0)),
                Divider(
                  color: Colors.white,
                ),
                buildMenuItem(
                    text: 'My Profile',
                    icon: Icons.people,
                    onClicked: () => selectedItem(context, 0)),
                buildMenuItem(
                    text: 'Sign Out',
                    icon: Icons.logout,
                    onClicked: () => selectedItem(context, 0)),
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

  selectedItem(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));
        break;
    }
  }
}
