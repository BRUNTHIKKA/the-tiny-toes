import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thetinytoes_app/pages/login_page.dart';
import 'package:thetinytoes_app/services/storage_service.dart';

class Navbar extends StatefulWidget {
  final String title;
  final VoidCallback? goBack;

  const Navbar({
    Key? key,
    required this.title,
    this.goBack,
  }) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  String? loggedUsername;

  @override
  void initState() {
    super.initState();
    fetchUsername(); // Fetch the username when the widget is initialized
  }

  // Fetch the username from the storage service.
  Future<void> fetchUsername() async {
    final storageService = Provider.of<StorageService>(context, listen: false);
    String? username = await storageService.getUsername();
    setState(() {
      loggedUsername = username; // Update the state with the fetched username
    });
  }

  // Handle user logout.
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
          // Conditionally show the back button
          if (widget.goBack != null)
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
                onPressed: widget.goBack,
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: Colors.blue,
                ),
              ),
            ),
          if (widget.goBack != null) const SizedBox(width: 10),

          // Logout button
          Container(
            height: 30,
            width: 100,
            child: ElevatedButton(
              onPressed: () => logout(context),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                side: MaterialStateProperty.all<BorderSide>(
                  const BorderSide(color: Colors.red),
                ),
                textStyle: MaterialStateProperty.all<TextStyle>(
                  const TextStyle(fontSize: 14),
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
          const SizedBox(width: 20),
          // Title text
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          // Display the username or loading indicator
          Text(
            loggedUsername ?? 'Loading...',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(width: 10),

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
