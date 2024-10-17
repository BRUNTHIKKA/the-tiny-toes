import 'package:flutter/material.dart';
import 'network_service.dart';

class AlbumProvider extends ChangeNotifier {
  List<dynamic> _albums = [];
  NetworkState _networkState = NetworkState.idle;
  int? _lastFetchedUserId;

  List<dynamic> get albums => _albums;
  NetworkState get networkState => _networkState;

  final NetworkService _networkService = NetworkService();

  // Fetch albums by userId
  Future<void> fetchAlbums(int userId) async {
    if (_lastFetchedUserId == userId) {
      return; // Prevent refetching for the same userId
    }

    _networkState = NetworkState.loading;
    notifyListeners();

    try {
      _albums = await _networkService.fetchAlbums(userId);
      _lastFetchedUserId = userId;
      _networkState = NetworkState.success;
    } catch (e) {
      _albums = [];
      _networkState = NetworkState.failure;
    } finally {
      notifyListeners();
    }
  }
}
