import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String _username = 'user';
  String _password = 'user123';

  bool validateLogin(String username, String password) {
    return username == _username && password == _password;
  }
}
