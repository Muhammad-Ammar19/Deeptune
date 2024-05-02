import 'package:deeptune_musicplayer/song_list_view.dart';
import 'package:flutter/material.dart';

class AllSongsPage extends StatelessWidget {
  const AllSongsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Songs',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: const SongListView(),
    );
  }
}
