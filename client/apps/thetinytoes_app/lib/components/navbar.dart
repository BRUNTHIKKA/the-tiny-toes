import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thetinytoes_app/pages/login_page.dart';
import 'package:thetinytoes_app/services/storage_service.dart';

class Navbar extends StatelessWidget {
  final String title;
  final String? username;
  final VoidCallback? goBack; // Nullable to indicate optional back button

  Navbar({
    required this.title,
    required this.username,
    this.goBack, // Allow null for goBack
  });

  void logout(BuildContext context) async {
    final storageService = Provider.of<StorageService>(context, listen: false);
    await storageService.clearStorage();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        children: [
          // Conditionally show the back button only if goBack is provided
          if (goBack != null)
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
                onPressed: goBack,
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: Colors.blue,
                ),
              ),
            ),
          if (goBack != null)
            SizedBox(width: 20), // Add space if back button is present

          Container(
            height: 30,
            width: 100,
            child: ElevatedButton(
              onPressed: () => logout(context),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
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
          Text(
            title,
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
              icon: const Icon(
                Icons.person_2_outlined,
                size: 20,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
