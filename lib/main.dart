import 'package:flutter/material.dart';
import 'package:fuel_opt/api/api.dart';
import 'package:fuel_opt/screens/home_screen.dart';
import 'package:fuel_opt/screens/login_screen.dart';
import 'package:fuel_opt/screens/registration_screen.dart';
import 'package:fuel_opt/screens/stations_screen.dart';
import '../utils/appColors.dart' as appColors;
import 'package:provider/provider.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StationsProvider(),
      child: MaterialApp(
        title: 'FuelOpt',
        theme: ThemeData(
          primaryColor: appColors.PrimaryBlue,
        ),
        home: const StationsScreen(),
      ),
    );
  }
}
