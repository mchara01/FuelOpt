import 'package:flutter/material.dart';
import 'package:fuel_opt/api/api.dart';
// import 'package:fuel_opt/screens/home_screen.dart';
import 'package:fuel_opt/screens/login_screen.dart';
import 'package:fuel_opt/screens/review_screen.dart';
import 'package:fuel_opt/screens/home_screen.dart';
import 'package:fuel_opt/screens/login_screen.dart';
import 'package:fuel_opt/screens/trend_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'model/search_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var androidInitialize =
      new AndroidInitializationSettings('@mipmap-hdpi/ic_launcher.png');
  var iOSInitialize = new IOSInitializationSettings();

  var initializationSettings = new InitializationSettings(
      android: androidInitialize, iOS: iOSInitialize);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
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
          create: (context) => StationsProvider(),
        )
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

  Future showNotification(details) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    var iosDetails = new IOSNotificationDetails();

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, 'FuelOpt', details, platformChannelSpecifics,
        payload: 'item x');
  }
}
