import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thetinytoes_app/components/navbar.dart';
import 'package:thetinytoes_app/pages/album_page.dart';
import 'package:thetinytoes_app/services/network_service.dart';
import '../providers/user_provider.dart';
import '../services/storage_service.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String? loggedUsername;

  @override
  void initState() {
    super.initState();

    // Fetch users after the first frame is rendered to avoid calling fetch during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchUsers();
      fetchUsername();
    });
  }

  // Method to fetch the username
  void fetchUsername() async {
    final storageService = Provider.of<StorageService>(context, listen: false);
    String? username = await storageService.getUsername(); // Fetch username
    setState(() {
      loggedUsername = username; // Update state with the fetched username
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Material(
      child: Column(
        children: [
          // Navbar
          Navbar(title: "Users", username: loggedUsername, goBack: null),
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
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          builder: (context) => AlbumPage(
                                userId: user['id'],
                                userName: user['name'],
                              )),
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
