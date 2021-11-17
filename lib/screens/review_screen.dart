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
  bool unleadedNotAvailable = false;
  bool dieselNotAvailable = false;
  bool superUnleadedNotAvailable = false;
  bool premiumDieselNotAvailable = false;
  // Form key
  final _formKey = GlobalKey<FormState>();
  final TextEditingController unleadedController = new TextEditingController();
  final TextEditingController dieselController = new TextEditingController();
  final TextEditingController superUnleadedController =
      new TextEditingController();
  final TextEditingController premiumDieselController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // unleaded field
    final unleadedField = TextFormField(
      autofocus: false,
      enabled: !unleadedNotAvailable,
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
    final unleadedButton = Checkbox(
      value: unleadedNotAvailable,
      onChanged: (value) {
        setState(() {
          bool test = value ?? false;
          unleadedNotAvailable = test;
        });
      },
    );
    final dieselField = TextFormField(
      autofocus: false,
      enabled: !dieselNotAvailable,
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
    final dieselButton = Checkbox(
      value: dieselNotAvailable,
      onChanged: (value) {
        setState(() {
          bool test = value ?? false;
          dieselNotAvailable = test;
        });
      },
    );
    final superUnleadedfield = TextFormField(
      autofocus: false,
      enabled: !superUnleadedNotAvailable,
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
    final superUnleadedButton = Checkbox(
      value: superUnleadedNotAvailable,
      onChanged: (value) {
        setState(() {
          bool test = value ?? false;
          superUnleadedNotAvailable = test;
        });
      },
    );
    final premiumDieselField = TextFormField(
      autofocus: false,
      enabled: !premiumDieselNotAvailable,
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
    final premiumDieselButton = Checkbox(
      value: premiumDieselNotAvailable,
      onChanged: (value) {
        setState(() {
          bool test = value ?? false;
          premiumDieselNotAvailable = test;
        });
      },
    );
    final submitButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: appColors.PrimaryBlue,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            submitReview(
                double.tryParse(unleadedController.text),
                double.tryParse(dieselController.text),
                double.tryParse(superUnleadedController.text),
                double.tryParse(premiumDieselController.text));
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
              child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Form(
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
                  Row(children: <Widget>[
                    Expanded(child:unleadedField),
                    unleadedButton,
                    Text("N/A")
                  ]),
                  SizedBox(height: 20),
                  Row(children: <Widget>[
                    Expanded(child:dieselField),
                    dieselButton,
                    Text("N/A")
                  ]),
                  SizedBox(height: 20),
                  Row(children: <Widget>[
                    Expanded(child:superUnleadedfield),
                    superUnleadedButton,
                    Text("N/A")
                  ]),
                  SizedBox(height: 20),
                  Row(children: <Widget>[
                    Expanded(child:premiumDieselField),
                    premiumDieselButton,
                    Text("N/A")
                  ]),
                  SizedBox(height: 20),
                  submitButton,
                  SizedBox(height: 20)
                ],
              ),
            ),
          )),
        ));
  }

  // login function
  void submitReview(double? unleadedPrice, double? dieselPrice,
      double? superUnleadedPrice, double? premiumDieselPrice) async {
    Fluttertoast.showToast(
        msg:
            '$unleadedPrice + $dieselPrice + $superUnleadedPrice + $premiumDieselPrice');
  }
}
