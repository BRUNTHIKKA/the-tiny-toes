import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thetinytoes_app/components/navbar.dart';
import 'package:thetinytoes_app/pages/gallery_page.dart';
import 'package:thetinytoes_app/services/network_service.dart';
import 'package:thetinytoes_app/services/storage_service.dart';
import 'package:thetinytoes_app/pages/users_page.dart';
import '../providers/album_provider.dart';

class AlbumPage extends StatefulWidget {
  final int userId;
  final String userName;

  AlbumPage({required this.userId, required this.userName});

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  String? loggedUsername;

  @override
  void initState() {
    super.initState();
    // Fetch albums for the current userId
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final albumProvider = Provider.of<AlbumProvider>(context, listen: false);
      albumProvider.fetchAlbums(widget.userId);
      fetchUsername();
    });
  }

  // Method to fetch the username
  void fetchUsername() async {
    final storageService = Provider.of<StorageService>(context, listen: false);
    String? username = await storageService.getUsername(); // Fetch username
    setState(() {
      loggedUsername = username; // Update state with the fetched username
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Navbar
          Navbar(
              title: "Album",
              username: loggedUsername,
              goBack: () {
                // Navigate to GalleryPage on back button click
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsersPage(),
                  ),
                );
              }),

          const SizedBox(height: 20),
          // Display selected Username
          Text(
            widget.userName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Displaying Albums for the selected user
          Expanded(
            child: Consumer<AlbumProvider>(
              builder: (context, albumProvider, child) {
                switch (albumProvider.networkState) {
                  case NetworkState.loading:
                    return Center(child: CircularProgressIndicator());

                  case NetworkState.failure:
                    return const Center(
                      child: Text(
                        'Failed to load albums. Please try again later.',
                        style: TextStyle(color: Colors.red, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    );

                  case NetworkState.success:
                    return albumProvider.albums.isNotEmpty
                        ? ListView.builder(
                            itemCount: albumProvider.albums.length,
                            itemBuilder: (context, index) {
                              var album = albumProvider.albums[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.grey[500],
                                      child: Text(
                                        album['title'][0].toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(album['title']),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => GalleryPage(
                                            albumId: album['id'],
                                            albumName: album['title'],
                                            userId: widget.userId,
                                            userName: widget.userName,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              'No albums found.',
                              style: TextStyle(fontSize: 18),
                            ),
                          );

                  default:
                    return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
