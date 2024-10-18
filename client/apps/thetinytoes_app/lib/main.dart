import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thetinytoes_app/gallery_provider.dart';
import 'album_provider.dart';
import 'auth_provider.dart';
import 'storage_service.dart';
import 'user_provider.dart';
import 'login_page.dart';
import 'users_page.dart';

void main() {
  Provider.debugCheckInvalidValueType = null; 

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StorageService()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AlbumProvider()),
        ChangeNotifierProvider(create: (_) => GalleryProvider()),

      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Tiny Toes',
      home: LoginPage(),
      routes: {
        '/users': (context) => UsersPage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
