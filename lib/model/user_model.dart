import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier{
  String name = '';
  String password = '';

  void setUser(String name, String psw) {
    this.name = name;
    this.password = psw;

    notifyListeners();
  }
}