import 'package:flutter/material.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Playlists')),
      body: const Center(
        child: Text('Lista de playlists aparecerá aqui'),
      ),
    );
  }
}
