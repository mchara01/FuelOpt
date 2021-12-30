// ignore_for_file: prefer_const_constructors

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuel_opt/model/search_result.dart';
import 'package:fuel_opt/screens/stations_detail.dart';
import 'package:provider/provider.dart';
import 'package:fuel_opt/model/search_options.dart';
import '../model/stations_model.dart';
import '../utils/appColors.dart' as appColors;
import 'package:fuel_opt/api/api.dart';
import 'upload_receipt.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ReviewScreen extends StatefulWidget {
  final int stationId;
  final String token;
  final String name;
  const ReviewScreen(this.stationId, this.token, this.name);

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
  bool isOpen = false;

  double? unleadedPrice;
  double? dieselPrice;
  double? superUnleadedPrice;
  double? premiumDieselPrice;

  String updateTitle = "Update Prices for ";

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
          if (isClosed) {
            isOpen = false;
          }
        });
      },
    );

    final isItOpenButton = Checkbox(
      value: isOpen,
      onChanged: (value) {
        setState(() {
          bool test = value ?? false;
          isOpen = test;
          if (isOpen) {
            isClosed = false;
          }
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
        child: Consumer<SearchResultModel>(
            builder: (context, searchResultModel, childWidget) {
          return MaterialButton(
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () async {
              var info = HashMap<String, String>();
              if (unleadedNotAvailable) {
                info["unleaded"] = '0';
              } else if (double.tryParse(unleadedController.text) != null) {
                info["unleaded"] = double.tryParse(unleadedController.text)!.toStringAsFixed(2).toString();
              } else {
                info["unleaded"] = '';
              }

              if (dieselNotAvailable) {
                info["diesel"] = '0';
              } else if (double.tryParse(dieselController.text) != null) {
                info["diesel"] = double.tryParse(dieselController.text)!.toStringAsFixed(2).toString();
              } else {
                info["diesel"] = '';
              }

              if (superUnleadedNotAvailable) {
                info["superUnleaded"] = '0';
              } else if (double.tryParse(superUnleadedController.text) != null) {
                info["superUnleaded"] = double.tryParse(superUnleadedController.text)!.toStringAsFixed(2).toString();
              } else {
                info["superUnleaded"] = '';
              }

              if (premiumDieselNotAvailable) {
                info["premiumDiesel"] = '0';
              } else if (double.tryParse(premiumDieselController.text) != null) {
                info["premiumDiesel"] = double.tryParse(premiumDieselController.text)!.toStringAsFixed(2).toString();
              } else {
                info["premiumDiesel"] = '';
              }

              if (int.tryParse(congestionController.text) != null) {
                info["congestion"] = congestionController.text.toString();
              } else {
                info["congestion"] = '';
              }

              if (isClosed) {
                info["open"] = '0';
              } else if (isOpen) {
                info["open"] = '1';
              } else {
                info["open"] = '';
              }

              bool infoNoValues = true;

              info.forEach((key, value) {
                if (value != "") {
                  infoNoValues = false;
                }
              });
              if (infoNoValues) {
                debugPrint("Sanity Check");
                Fluttertoast.showToast(
                    msg: "Please provide information.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
              print(info);
              FuelStationDataService fuelStationDataService = FuelStationDataService();

              int success = await fuelStationDataService.updateInfo(
                  widget.stationId, info, widget.token);
              if (success == 1) {
                Fluttertoast.showToast(msg: "Update Successful");
                // go back to search results by going back twice
                searchResultModel.updateSearchResult(widget.stationId, info);
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
              } else if (success == 2) {
                Fluttertoast.showToast(
                    msg: "Price is too high/low, please upload receipt to accept price.");
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        UploadReceiptScreen(widget.stationId, info, widget.token)));
              } else {
                Fluttertoast.showToast(msg: "Failed to Update");
              }
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
          );
        }));

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
                    updateTitle + widget.name,
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
                  Row(children: <Widget>[
                    isItOpenButton,
                    Text("Open"),
                    isItClosedButton,
                    Text("Closed")
                  ]),
                  SizedBox(height: 20),
                  submitButton
                ],
              ),
            ),
          )),
        ));
  }

  // login function
  // _submitReview() async {
  //   var info = HashMap<String, String>();
  //   if (unleadedNotAvailable) {
  //     info["unleaded"] = '0';
  //   } else if (double.tryParse(unleadedController.text) != null) {
  //     info["unleaded"] = unleadedController.text.toString();
  //   } else {
  //     info["unleaded"] = '';
  //   }
  //
  //   if (dieselNotAvailable) {
  //     info["diesel"] = '0';
  //   } else if (double.tryParse(dieselController.text) != null) {
  //     info["diesel"] = dieselController.text.toString();
  //   } else {
  //     info["diesel"] = '';
  //   }
  //
  //   if (superUnleadedNotAvailable) {
  //     info["superUnleaded"] = '0';
  //   } else if (double.tryParse(superUnleadedController.text) != null) {
  //     info["superUnleaded"] = superUnleadedController.text.toString();
  //   } else {
  //     info["superUnleaded"] = '';
  //   }
  //
  //   if (premiumDieselNotAvailable) {
  //     info["premiumDiesel"] = '0';
  //   } else if (double.tryParse(premiumDieselController.text) != null) {
  //     info["premiumDiesel"] = premiumDieselController.text.toString();
  //   } else {
  //     info["premiumDiesel"] = '';
  //   }
  //
  //   if (int.tryParse(congestionController.text) != null) {
  //     info["congestion"] = congestionController.text.toString();
  //   } else {
  //     info["congestion"] = '';
  //   }
  //
  //   if (isClosed) {
  //     info["open"] = '0';
  //   } else if (isOpen) {
  //     info["open"] = '1';
  //   } else {
  //     info["open"] = '';
  //   }
  //
  //   bool infoNoValues = true;
  //
  //   info.forEach((key, value) {
  //     if (value != "") {
  //       infoNoValues = false;
  //     }
  //   });
  //   if (infoNoValues) {
  //     debugPrint("Sanity Check");
  //     Fluttertoast.showToast(
  //         msg: "Please provide information.",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  //   print(info);
  //   FuelStationDataService fuelStationDataService = FuelStationDataService();
  //
  //   int success = await fuelStationDataService.updateInfo(
  //       widget.stationId, info, widget.token);
  //   if (success == 1) {
  //     Fluttertoast.showToast(msg: "Update Successful");
  //     // go back to search results by going back twice
  //     searchResultModel.updateSearchResult();
  //     int count = 0;
  //     Navigator.of(context).popUntil((_) => count++ >= 2);
  //   } else if (success == 2) {
  //     Fluttertoast.showToast(
  //         msg: "Price is too high/low, please upload receipt to accept price.");
  //     Navigator.of(context).push(MaterialPageRoute(
  //         builder: (context) =>
  //             UploadReceiptScreen(widget.stationId, info, widget.token)));
  //   } else {
  //     Fluttertoast.showToast(msg: "Failed to Update");
  //   }
  // }
}
