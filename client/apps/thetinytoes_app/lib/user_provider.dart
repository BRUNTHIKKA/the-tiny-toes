import 'package:flutter/material.dart';
import 'network_service.dart';
import 'storage_service.dart';

class UserProvider with ChangeNotifier {
  final NetworkService networkService = NetworkService();
  final StorageService storageService = StorageService();
}
