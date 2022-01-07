import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuel_opt/api/api.dart';
import 'package:fuel_opt/screens/login_screen.dart';
import 'package:fuel_opt/screens/trend_screen.dart';
import 'package:fuel_opt/screens/instructions_screen.dart';
import 'package:provider/provider.dart';
import '../model/user_model.dart';
import '../utils/app_colors.dart' as appColors;

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    return Drawer(
        child: Material(
            color: appColors.PrimaryBlue,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
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
                user.name.isEmpty
                    ? buildMenuItem(
                        text: 'Log In',
                        icon: Icons.person,
                        onClicked: () => selectedItem(context, 3))
                    : buildMenuItem(
                        text: 'Sign Out',
                        icon: Icons.person,
                        onClicked: () async {
                          AccountFunctionality accountFunctionality =
                              AccountFunctionality();

                          bool output = await accountFunctionality.logout();
                          if (output) {
                            user.setUser('', '');
                            Fluttertoast.showToast(msg: "Logout Successful");
                          } else {
                            Fluttertoast.showToast(msg: "Logout Unsuccessful");
                          }
                        }
                        // onClicked: () => selectedItem(context, 2)
                        ),
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
        break;
      case 3:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));
        break;
    }
  }
}
