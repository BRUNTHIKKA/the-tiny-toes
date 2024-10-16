import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String _username = 'admin';
  String _password = 'admin';

  bool validateLogin(String username, String password) {
    return username == _username && password == _password;
  }
}
