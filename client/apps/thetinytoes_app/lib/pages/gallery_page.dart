import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thetinytoes_app/components/navbar.dart';
import 'package:thetinytoes_app/pages/album_page.dart';
import 'package:thetinytoes_app/providers/gallery_provider.dart';
import 'package:thetinytoes_app/services/network_service.dart';
import 'package:thetinytoes_app/pages/photo_page.dart';

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

  @override
  void initState() {
    super.initState();
    // Fetch gallery for the selected albumId
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final galleryProvider =
          Provider.of<GalleryProvider>(context, listen: false);
      galleryProvider.fetchGallery(widget.albumId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 40),
        child: Column(
          children: [
            // Navbar
            Navbar(
                title: "Gallery",
                goBack: () {
                  // Navigate to AlbumPage on back button click
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlbumPage(
                        userId: widget.userId,
                        userName: widget.userName,
                      ),
                    ),
                  );
                }),
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
                          'Failed to load gallery.',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      );

                    case NetworkState.success:
                      return galleryProvider.gallery.isNotEmpty
                          ? GridView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 40,
                                childAspectRatio: 1,
                              ),
                              itemCount: galleryProvider.gallery.length,
                              itemBuilder: (context, index) {
                                var galleryItem =
                                    galleryProvider.gallery[index];

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
                                    cursor: SystemMouseCursors.click,
                                    child: Column(
                                      children: [
                                        // Thumbnail Image
                                        Image.asset(
                                          '../images/img.png',
                                          fit: BoxFit.fill,
                                          height: 40,
                                          width: 40,
                                        ),

                                        const SizedBox(height: 10),

                                        // Image name displayed under the thumbnail
                                        Text(
                                          galleryItem['title'] != null &&
                                                  galleryItem['title'].length >
                                                      15
                                              ? '${galleryItem['title']!.substring(0, 15)}...'
                                              : galleryItem['title'] ??
                                                  'Unknown',
                                          style: const TextStyle(
                                            fontSize: 12,
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
      ),
    );
  }
}
