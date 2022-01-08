import 'package:flutter/material.dart';
import 'package:fuel_opt/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'model/current_location_model.dart';
import 'model/search_options.dart';
import 'model/user_model.dart';

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
        ChangeNotifierProvider(
          create: (context) => SearchQueryModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchResultModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CurrentLocationModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SortByPreferenceModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => FuelTypePreferenceModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => DistancePreferenceModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => FacilitiesPreferenceModel(),
        ),
      ],
      child: MaterialApp(
        title: 'FuelOpt',
        theme: ThemeData(
          primaryColor: const Color(0xFF002060),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
