import 'package:flutter/material.dart';
import 'network_service.dart';
import 'storage_service.dart';

class UserProvider with ChangeNotifier {
  final NetworkService networkService = NetworkService();
  final StorageService storageService = StorageService();

  List<dynamic> users = [];
  NetworkState networkState = NetworkState.idle; // Track network state
  String errorMessage = '';

  Future<void> fetchUsers() async {
    networkState = NetworkState.loading;
    notifyListeners();

    try {
      users = await networkService.fetchUsers();
      networkState = NetworkState.success;
    } catch (e) {
      networkState = NetworkState.failure;
      errorMessage = e.toString();
    }

    notifyListeners();
  }
}
