import 'package:flutter/material.dart';
import 'package:fuel_opt/screens/home_screen.dart';
import '../utils/appColors.dart' as appColors;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Email and Password Login',
      theme: ThemeData(
        primaryColor: appColors.PrimaryBlue,
      ),
      home: HomeScreen(),
    );
  }
}
