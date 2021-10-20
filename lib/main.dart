import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fuel_opt/screens/home_screen.dart';
import '../utils/appColors.dart' as appColors;

Future<void> main() async {
  // create Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuelOpt',
      theme: ThemeData(
        primaryColor: appColors.PrimaryAssentColor,
      ),
      home: HomeScreen(),
    );
  }
}
