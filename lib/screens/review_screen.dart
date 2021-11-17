// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuel_opt/screens/home_screen.dart';
import 'package:fuel_opt/screens/registration_screen.dart';
import '../utils/appColors.dart' as appColors;
import 'package:fuel_opt/api/api.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  // Form key
  final _formKey = GlobalKey<FormState>();
  final TextEditingController unleadedController = new TextEditingController();
  final TextEditingController dieselController = new TextEditingController();
  final TextEditingController superUnleadedController = new TextEditingController();
  final TextEditingController premiumDieselController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // unleaded field
    final unleadedField = TextFormField(
      autofocus: false,
      controller: unleadedController,
      keyboardType: TextInputType.number,
      onSaved: (value) {
        unleadedController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.local_gas_station),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "123.4",
          labelText: 'Insert Unleaded Price',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final dieselField = TextFormField(
      autofocus: false,
      controller: dieselController,
      keyboardType: TextInputType.number,
      onSaved: (value) {
        dieselController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.local_gas_station_rounded),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "123.4",
          labelText: 'Insert Diesel Price',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final superUnleadedfield= TextFormField(
      autofocus: false,
      controller: superUnleadedController,
      keyboardType: TextInputType.number,
      onSaved: (value) {
        superUnleadedController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.local_gas_station_rounded),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "123.4",
          labelText: 'Insert Super Unleaded Price',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final premiumDieselField = TextFormField(
      autofocus: false,
      controller: premiumDieselController,
      keyboardType: TextInputType.number,
      onSaved: (value) {
        premiumDieselController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.local_gas_station_rounded),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "123.4",
          labelText: 'Insert Premium Diesel Price',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final submitButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: appColors.PrimaryBlue,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            debugPrint(dieselController.text+"hello");
            debugPrint(unleadedController.text+"goodbye");
            // print(dieselController.text+"hello");
            // submitReview(double.parse(unleadedController.text), double.parse(dieselController.text), double.parse(superUnleadedController.text), double.parse(premiumDieselController.text) );
          },
          child: Text(
            "Submit",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
              child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(36.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox.fromSize(
                                    size: Size.fromRadius(30),
                                    child: FittedBox(
                                      child: Icon(Icons.local_gas_station),
                                    )),
                                Text(
                                  "Update Fuel Prices",
                                  style: TextStyle(
                                      color: appColors.PrimaryBlue,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 30),
                                ),
                              ]),
                          SizedBox(height: 20),
                          unleadedField,
                          SizedBox(height: 20),
                          dieselField,
                          SizedBox(height: 20),
                          superUnleadedfield,
                          SizedBox(height: 20),
                          premiumDieselField,
                          SizedBox(height: 20),
                          submitButton,
                          SizedBox(height: 20)
                        ],
                      ),
                    ),
                  ))),
        ));
  }

  // login function
  void submitReview(double unleadedPrice, double dieselPrice, double superUnleadedPrice, double premiumDieselPrice) async {
    Fluttertoast.showToast(msg: '$unleadedPrice + $dieselPrice + $superUnleadedPrice + $premiumDieselPrice');
  }
}