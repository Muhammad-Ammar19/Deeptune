import 'package:flutter/material.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(forceMaterialTransparency: true,
        title: const Text(
          'Playlists',
          style: TextStyle(fontSize:21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
    );
  }
}
