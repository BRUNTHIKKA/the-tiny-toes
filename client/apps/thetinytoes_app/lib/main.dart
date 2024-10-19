import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thetinytoes_app/providers/gallery_provider.dart';
import 'package:thetinytoes_app/providers/album_provider.dart';
import 'package:thetinytoes_app/providers/auth_provider.dart';
import 'package:thetinytoes_app/services/storage_service.dart';
import 'package:thetinytoes_app/providers/user_provider.dart';
import 'package:thetinytoes_app/pages/login_page.dart';
import 'package:thetinytoes_app/pages/users_page.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StorageService()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AlbumProvider()),
        ChangeNotifierProvider(create: (_) => GalleryProvider())
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
