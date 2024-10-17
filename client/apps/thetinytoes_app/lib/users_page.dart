import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thetinytoes_app/album_page.dart';
import 'package:thetinytoes_app/album_provider.dart';
import 'package:thetinytoes_app/network_service.dart';
import 'user_provider.dart';
import 'auth_provider.dart';
import 'login_page.dart';
import 'storage_service.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();

    // Fetch users after the first frame is rendered to avoid calling fetch during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
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
                  "Users",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 100),
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

          // Add user list or relevant UI based on network state
          Expanded(
            child: _buildBody(userProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(UserProvider userProvider) {
    switch (userProvider.networkState) {
      case NetworkState.loading:
        return Center(child: CircularProgressIndicator());

      case NetworkState.success:
        return ListView.builder(
          itemCount: userProvider.users.length,
          itemBuilder: (context, index) {
            var user = userProvider.users[index];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
                child: ListTile(
                  title: Text(
                    user['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    // Navigate to AlbumPage when the user is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlbumPage(userId: user['id'], username: user['name'],),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );

      case NetworkState.failure:
        return const Center(
          child: Text(
            'Failed to load users',
            style: TextStyle(color: Colors.red, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        );

      default:
        return Container();
    }
  }
}
