import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thetinytoes_app/network_service.dart';
import 'album_provider.dart';

class AlbumPage extends StatelessWidget {
  final int userId;

  AlbumPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    final albumProvider = Provider.of<AlbumProvider>(context);

    // Fetch albums for the current userId
    // Call fetchAlbums when this page is built
    albumProvider.fetchAlbums(userId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Albums'),
      ),
      body: Consumer<AlbumProvider>(
        builder: (context, albumProvider, child) {
          if (albumProvider.networkState == NetworkState.loading) {
            return Center(child: CircularProgressIndicator());
          }

          if (albumProvider.networkState == NetworkState.failure) {
            return Center(child: Text('Failed to load albums.'));
          }

          if (albumProvider.albums.isEmpty) {
            return Center(child: Text('No albums found.'));
          }

          return ListView.builder(
            itemCount: albumProvider.albums.length,
            itemBuilder: (context, index) {
              var album = albumProvider.albums[index];
              return ListTile(
                title: Text(album['title']),
              );
            },
          );
        },
      ),
    );
  }
}
