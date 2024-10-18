import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thetinytoes_app/components/navbar.dart';
import 'package:thetinytoes_app/pages/gallery_page.dart';
import 'package:thetinytoes_app/providers/gallery_provider.dart';
import 'package:thetinytoes_app/services/storage_service.dart';

class PhotoPage extends StatefulWidget {
  final int albumId;
  final String albumName;
  final String photoName;
  final String? photoUrl;
  final int userId;
  final String userName;

  PhotoPage({
    required this.albumId,
    required this.albumName,
    required this.userId,
    required this.userName,
    required this.photoName,
    required this.photoUrl,
  });

  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<PhotoPage> {
  String? loggedUsername;

  @override
  void initState() {
    super.initState();
    // Fetch gallery for the selected albumId
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final galleryProvider =
          Provider.of<GalleryProvider>(context, listen: false);
      galleryProvider.fetchGallery(widget.userId);
      fetchUsername();
    });
  }

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
          Navbar(
              title: "Gallery",
              username: loggedUsername,
              goBack: () {
                // Navigate to GalleryPage on back button click
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GalleryPage(
                      userId: widget.userId,
                      userName: widget.userName,
                      albumId: widget.albumId,
                      albumName: widget.albumName,
                    ),
                  ),
                );
              }),

          // Display selected Gallery Name
          SizedBox(height: 10),
          Text(
            widget.photoName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Column(
            children: [
              Image.asset(
                widget.photoUrl ?? '../images/img.png',
                fit: BoxFit.fill,
                height: 400,
                width: 400,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 60),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          '  Artist ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          widget.userName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Album ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          widget.albumName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
