import 'package:flutter/material.dart';
import 'package:fuel_opt/api/api.dart';
import 'package:fuel_opt/screens/home_screen.dart';
import 'package:fuel_opt/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:fuel_opt/model/search_options.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => StationsProvider()),
      ],
      child: MaterialApp(
        title: 'FuelOpt',
        theme: ThemeData(
          primaryColor: const Color(0xFF002060),
        ),
        home: const HomeScreen(),
      ),
    );
    // return ChangeNotifierProvider(
    //   create: (context) => StationsProvider(),
    //   child: MaterialApp(
    //     title: 'FuelOpt',
    //     theme: ThemeData(
    //       primaryColor: const Color(0xFF002060),
    //     ),
    //     home: const HomeScreen(),
    //   ),
    // );
  }
}
