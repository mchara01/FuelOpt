// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../utils/appColors.dart' as appColors;

import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UploadReceiptScreen extends StatefulWidget {
  // const UploadReceiptScreen({Key? key}) : super(key: key);
  final int stationId;
  final String token;
  const UploadReceiptScreen(this.stationId, this.token);

  @override
  _UploadReceiptScreenState createState() => _UploadReceiptScreenState();
}

class _UploadReceiptScreenState extends State<UploadReceiptScreen> {
  bool submitAvailable = false;
  String receiptButtonText = "Select Image";
  String uploadReceiptTitle = "Upload Receipt";
  String uploadReceiptText =
      "The price you input is too high or low. Please upload an image of your receipt to verify the change of price.";
  // Form key
  final _formKey = GlobalKey<FormState>();

  /// Variables
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    // unleaded field
    final receiptButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.black,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            debugPrint("inside Press");
            _getFromGallery();
          },
          child: Text(
            receiptButtonText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
    );

    final submitButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: appColors.PrimaryBlue,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            _submitReceipt();
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
                    uploadReceiptTitle,
                    style: TextStyle(
                        color: appColors.PrimaryBlue,
                        fontWeight: FontWeight.w800,
                        fontSize: 30),
                  ),
                  SizedBox(height: 20),
                  Text(
                    uploadReceiptText,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  SizedBox(height: 20),
                  receiptButton,
                  SizedBox(height: 20),
                  Visibility(child: submitButton, visible: submitAvailable),
                ],
              ),
            ),
          )),
        ));
  }

  /// Get from gallery
  _getFromGallery() async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
        receiptButtonText = "Change Receipt";
        submitAvailable = true;
      });
    }
    if (image == null) {
      submitAvailable = false;
      receiptButtonText = "Submit Receipt";
    }
  }

  _submitReceipt() {
    debugPrint("submitting image not implemented");
  }
}
