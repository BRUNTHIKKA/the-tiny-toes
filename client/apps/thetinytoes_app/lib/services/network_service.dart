import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkService {
  // Fetch Users
  Future<List<dynamic>> fetchUsers() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Fetch Albums
  Future<List> fetchAlbums(int userId) async {
    final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users/$userId/albums'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load albums');
    }
  }

  // Fetch Gallery
  Future<List> fetchGallery(int albumId) async {
    final response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/albums/$albumId/photos'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load gallery');
    }
  }
}

// Manage different network states
enum NetworkState { idle, loading, success, failure }
