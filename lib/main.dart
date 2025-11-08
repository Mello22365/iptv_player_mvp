import 'package:flutter/material.dart';
import 'package:iptv_player_mvp/screens/login_screen.dart';
import 'package:iptv_player_mvp/screens/playlist_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IPTV Player MVP',
      theme: ThemeData(
        colorSchemeSeed: Colors.red,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const LoginScreen(),
        '/playlist': (_) => const PlaylistScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
