import 'package:flutter/material.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(forceMaterialTransparency: true,
        title: const Text(
          'Playlist',
          style: TextStyle(fontSize:20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
    );
  }
}
