import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends ChangeNotifier {
  Future<void> saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  
  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
  Future<void> clearStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<String?> getAlbumName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('albumName');
  }
}
