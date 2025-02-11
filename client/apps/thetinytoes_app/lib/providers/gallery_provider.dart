import 'package:flutter/material.dart';
import 'package:thetinytoes_app/services/network_service.dart';

class GalleryProvider extends ChangeNotifier {
  List<dynamic> _gallery = [];
  NetworkState _networkState = NetworkState.idle;
  int? _lastFetchedAlbumId;

  List<dynamic> get gallery => _gallery;
  NetworkState get networkState => _networkState;

  final NetworkService _networkService = NetworkService();

  // Fetch gallery by albumId
  Future<void> fetchGallery(int albumId) async {
    if (_lastFetchedAlbumId == albumId) {
      return; // Prevent refetching the same album
    }

    _networkState = NetworkState.loading;
    notifyListeners();

    try {
      _gallery = await _networkService.fetchGallery(albumId);
      _lastFetchedAlbumId = albumId;
      _networkState = NetworkState.success;
    } catch (e) {
      _gallery = [];
      _networkState = NetworkState.failure;
    } finally {
      notifyListeners();
    }
  }
}
