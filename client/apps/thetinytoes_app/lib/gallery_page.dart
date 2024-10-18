import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thetinytoes_app/album_page.dart';
import 'package:thetinytoes_app/gallery_provider.dart';
import 'package:thetinytoes_app/login_page.dart';
import 'package:thetinytoes_app/network_service.dart';
import 'package:thetinytoes_app/photo_page.dart';
import 'package:thetinytoes_app/storage_service.dart';

class GalleryPage extends StatefulWidget {
  final int albumId;
  final String albumName;
  final int userId;
  final String userName;

  GalleryPage({
    required this.albumId,
    required this.albumName,
    required this.userId,
    required this.userName,
  });

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  String? loggedUsername;

  @override
  void initState() {
    super.initState();
    // Fetch gallery for the selected albumId
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final galleryProvider =
          Provider.of<GalleryProvider>(context, listen: false);
      galleryProvider.fetchGallery(widget.albumId);
      fetchUsername();
    });
  }

  // Method to fetch the username
  void fetchUsername() async {
    final storageService = Provider.of<StorageService>(context, listen: false);
    String? username = await storageService.getUsername();
    setState(() {
      loggedUsername = username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Navbar
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
                      // Navigate to AlbumPage on back button click
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AlbumPage(
                                  userId: widget.userId,
                                  userName: widget.userName,
                                )),
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
                  "Gallery",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  loggedUsername ?? 'Loading...',
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
          // Display selected Album Name
          Text(
            widget.albumName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: Consumer<GalleryProvider>(
              builder: (context, galleryProvider, child) {
                switch (galleryProvider.networkState) {
                  case NetworkState.loading:
                    return Center(child: CircularProgressIndicator());

                  case NetworkState.failure:
                    return const Center(
                      child: Text(
                        'Failed to load gallery. Please try again later.',
                        style: TextStyle(color: Colors.red, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    );

                  case NetworkState.success:
                    return galleryProvider.gallery.isNotEmpty
                        ? GridView.builder(
                            padding: const EdgeInsets.all(5),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                            itemCount: galleryProvider.gallery.length,
                            itemBuilder: (context, index) {
                              var galleryItem = galleryProvider.gallery[index];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PhotoPage(
                                        albumId: widget.albumId,
                                        albumName: widget.albumName,
                                        userId: widget.userId,
                                        userName: widget.userName,
                                        photoName: galleryItem['title'],
                                        photoUrl: galleryItem['url'],
                                      ),
                                    ),
                                  );
                                },
                                child: MouseRegion(
                                  cursor: SystemMouseCursors
                                      .click,
                                  child: Column(
                                    children: [
                                      // Thumbnail Image
                                      Image.asset(
                                        galleryItem['thumbnailUrl'] ??
                                            '../images/img.png',
                                        fit: BoxFit.fill,
                                        height: 100,
                                        width: 100,
                                      ),

                                      const SizedBox(height: 5),

                                      // Image name displayed under the thumbnail
                                      Text(
                                        galleryItem['title'] != null &&
                                                galleryItem['title'].length > 25
                                            ? '${galleryItem['title']!.substring(0, 25)}...'
                                            : galleryItem['title'] ?? 'Unknown',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              'No gallery items found.',
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
