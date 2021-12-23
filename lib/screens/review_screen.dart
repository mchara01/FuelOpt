// ignore_for_file: prefer_const_constructors

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utils/appColors.dart' as appColors;
import 'package:fuel_opt/api/api.dart';
import 'upload_receipt.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ReviewScreen extends StatefulWidget {
  final int stationId;
  final String token;
  const ReviewScreen(this.stationId, this.token);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool unleadedNotAvailable = false;
  bool dieselNotAvailable = false;
  bool superUnleadedNotAvailable = false;
  bool premiumDieselNotAvailable = false;
  bool submitAvailable = false;

  bool isClosed = false;

  double? unleadedPrice;
  double? dieselPrice;
  double? superUnleadedPrice;
  double? premiumDieselPrice;

  String updateTitle = "Update Prices for " + "<Station>";

  // Form key
  final _formKey = GlobalKey<FormState>();
  final TextEditingController unleadedController = new TextEditingController();
  final TextEditingController dieselController = new TextEditingController();
  final TextEditingController superUnleadedController =
      new TextEditingController();
  final TextEditingController premiumDieselController =
      new TextEditingController();
  final TextEditingController congestionController =
      new TextEditingController();

  /// Variables
  File? imageFile;

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
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'(^\d{1,3}(\.\d?)?)'))
      ],
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
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'(^\d{1,3}(\.\d?)?)'))
      ],
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
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'(^\d{1,3}(\.\d?)?)'))
      ],
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
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'(^\d{1,3}(\.\d?)?)'))
      ],
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

    final isItClosedButton = Checkbox(
      value: isClosed,
      onChanged: (value) {
        setState(() {
          bool test = value ?? false;
          isClosed = test;
        });
      },
    );

    final congestionField = TextFormField(
      autofocus: false,
      controller: congestionController,
      keyboardType: TextInputType.number,
      onSaved: (value) {
        congestionController.text = value!;
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'(^\d{1,3})'))
      ],
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.more_time),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "minutes",
          labelText: 'Time Congested',
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
            _submitReview();
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) =>
            //           UploadReceiptScreen(widget.stationId, widget.token)),
            // );
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: appColors.PrimaryBlue),
            onPressed: () {
              // passing this to our root
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    updateTitle,
                    style: TextStyle(
                        color: appColors.PrimaryBlue,
                        fontWeight: FontWeight.w800,
                        fontSize: 30),
                  ),
                  SizedBox(height: 20),
                  Row(children: <Widget>[
                    Expanded(child: unleadedField),
                    unleadedButton,
                    Text("Unavailable")
                  ]),
                  SizedBox(height: 20),
                  Row(children: <Widget>[
                    Expanded(child: dieselField),
                    dieselButton,
                    Text("Unavailable")
                  ]),
                  SizedBox(height: 20),
                  Row(children: <Widget>[
                    Expanded(child: superUnleadedfield),
                    superUnleadedButton,
                    Text("Unavailable")
                  ]),
                  SizedBox(height: 20),
                  Row(children: <Widget>[
                    Expanded(child: premiumDieselField),
                    premiumDieselButton,
                    Text("Unavailable")
                  ]),
                  SizedBox(height: 20),
                  Row(children: <Widget>[
                    Expanded(child: congestionField),
                    Text("")
                  ]),
                  SizedBox(height: 20),
                  Row(children: <Widget>[isItClosedButton, Text("Closed")]),
                  SizedBox(height: 20),
                  submitButton
                ],
              ),
            ),
          )),
        ));
  }

  // login function
  _submitReview() async {
    var toSubmit = HashMap<String, String>();
    if (unleadedNotAvailable) {
      toSubmit["unleaded"] = '0';
    } else if (double.tryParse(unleadedController.text) != null) {
      toSubmit["unleaded"] = unleadedController.text.toString();
    } else {
      toSubmit["unleaded"] = '';
    }

    if (dieselNotAvailable) {
      toSubmit["diesel"] = '0';
    } else if (double.tryParse(dieselController.text) != null) {
      toSubmit["diesel"] = dieselController.text.toString();
    } else {
      toSubmit["diesel"] = '';
    }

    if (superUnleadedNotAvailable) {
      toSubmit["superUnleaded"] = '0';
    } else if (double.tryParse(superUnleadedController.text) != null) {
      toSubmit["superUnleaded"] = superUnleadedController.text.toString();
    } else {
      toSubmit["superUnleaded"] = '';
    }

    if (premiumDieselNotAvailable) {
      toSubmit["premiumDiesel"] = '0';
    } else if (double.tryParse(premiumDieselController.text) != null) {
      toSubmit["premiumDiesel"] = premiumDieselController.text.toString();
    } else {
      toSubmit["premiumDiesel"] = '';
    }

    if (int.tryParse(congestionController.text) != null) {
      toSubmit["congestion"] = congestionController.text.toString();
    } else {
      toSubmit["congestion"] = '';
    }

    if (isClosed) {
      toSubmit["closed"] = '1';
    } else {
      toSubmit["closed"] = '0';
    }

    if (toSubmit.isNotEmpty) {
      print(toSubmit);
      FuelStationDataService fuelStationDataService = FuelStationDataService();

      int succuess = await fuelStationDataService.updateInfo(
          widget.stationId, toSubmit, widget.token);
      if (succuess == 1) {
        Fluttertoast.showToast(msg: "Update Successful");
      } else if (succuess == 2) {
        Fluttertoast.showToast(
            msg: "Price is too high/low, please check your input");
      } else {
        Fluttertoast.showToast(msg: "Failed to Update");
      }
      debugPrint('submit prices not implemented');
    } else {
      debugPrint("Sanity Check");
      Fluttertoast.showToast(
          msg: "This is Center Short Toast",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
