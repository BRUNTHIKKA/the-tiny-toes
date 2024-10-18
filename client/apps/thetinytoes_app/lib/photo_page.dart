import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thetinytoes_app/gallery_page.dart';
import 'package:thetinytoes_app/gallery_provider.dart';
import 'package:thetinytoes_app/login_page.dart';
import 'package:thetinytoes_app/storage_service.dart';

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
                          builder: (context) => GalleryPage(
                            userId: widget.userId,
                            userName: widget.userName,
                            albumId: widget.albumId,
                            albumName: widget.albumName,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
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
                    icon: const Icon(
                      Icons.person_2_outlined,
                      size: 20,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),

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
