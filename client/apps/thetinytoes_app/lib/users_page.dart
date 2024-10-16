import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thetinytoes_app/auth_provider.dart';
import 'package:thetinytoes_app/login_page.dart';
import 'package:thetinytoes_app/storage_service.dart';
import 'package:thetinytoes_app/user_provider.dart';


class UsersPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final storageService = Provider.of<StorageService>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Material(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () async {
                      await storageService.clearStorage();
                      authProvider.validateLogout(); 

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
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
                
        ],
      ),
          ),
        ],
      ),
    );
  }
}
