import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thetinytoes_app/providers/auth_provider.dart';
import 'package:thetinytoes_app/services/storage_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late AuthProvider authProvider;
  late StorageService storageService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    authProvider =
        Provider.of<AuthProvider>(context, listen: false); // Get auth provider
    storageService = Provider.of<StorageService>(context,
        listen: false); // Get storage service

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 120),
        child: Column(
          children: [
            const Text(
              "The Tiny Toes",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 120, width: 10),
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                hintText: 'Username',
                hintStyle: const TextStyle(color: Colors.black87),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                hintText: 'Password',
                hintStyle: const TextStyle(color: Colors.black87),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              height: 40,
              width: 150,
              child: ElevatedButton(
                onPressed: () async {
                  var isValidLogin = authProvider.validateLogin(
                    usernameController.text,
                    passwordController.text,
                  );

                  if (isValidLogin) {
                    // Store username after successful login
                    await storageService.saveUsername(usernameController.text);

                    // Redirect based on login status
                    bool isLoggedIn =
                        await storageService.getUsername() != null;
                    if (isLoggedIn) {
                      Navigator.pushReplacementNamed(context, '/users');
                    } else {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  } else {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid username or password')),
                    );
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    const TextStyle(fontSize: 16),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Checks login status
  // If the user already logged in go to users page
  // Else stay at login page
  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await storageService.getUsername() != null;
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/users');
    }
  }
}
