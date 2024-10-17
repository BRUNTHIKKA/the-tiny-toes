import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thetinytoes_app/login_page.dart';
import 'package:thetinytoes_app/network_service.dart';
import 'package:thetinytoes_app/storage_service.dart';
import 'package:thetinytoes_app/users_page.dart';
import 'album_provider.dart';

class AlbumPage extends StatefulWidget {
  final int userId;
  final String username;

  AlbumPage({required this.userId, required this.username});

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  String? username;

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
    String? userName = await storageService.getUsername(); // Fetch username
    setState(() {
      username = userName; // Update state with the fetched username
    });
  }

  @override
  Widget build(BuildContext context) {
    final albumProvider = Provider.of<AlbumProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blue,
                      width: 1.0,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UsersPage()),
                      );
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  height: 30,
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () async {
                      final storageService =
                          Provider.of<StorageService>(context, listen: false);
                      await storageService.clearStorage();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(color: Colors.red),
                      ),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontSize: 16),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    child: const Text('Logout'),
                  ),
                ),
                const SizedBox(width: 100),
                const Text(
                  "Album",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  username ?? 'Loading...',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blue,
                      width: 1.0,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.person_2_outlined,
                      size: 20,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          // Display selected Username
          Text(
            widget.username,
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
                                    horizontal: 10, vertical: 5),
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
                                      Navigator.pushNamed(
                                        context,
                                        '/gallery',
                                        arguments: album['id'],
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
