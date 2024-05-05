import 'package:deeptune_musicplayer/ad_controller.dart';
import 'package:deeptune_musicplayer/all_songs_page.dart';
import 'package:deeptune_musicplayer/favourites.dart';
import 'package:deeptune_musicplayer/playlist_screen.dart';
import 'package:deeptune_musicplayer/recent_downloads.dart';
import 'package:deeptune_musicplayer/recent_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class GridViewPage extends StatelessWidget {
  const GridViewPage({super.key});

  Future<int> getTotalSongs() async {
    final OnAudioQuery onAudioQuery = OnAudioQuery();
    final songs = await onAudioQuery.querySongs();
    return songs.length;
  }

  @override
  Widget build(BuildContext context) {
    final bannerAdWidget = AdManager.getBannerAdWidget();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Music Library",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      bottomNavigationBar: bannerAdWidget != Container()
          ? SizedBox(
              height: Get.height * 0.06,
              child: bannerAdWidget,
            )
          : null,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.to(() => const PlaylistScreen(),
                            transition: Transition.fadeIn);
                      },
                      icon: const Icon(
                        Icons.playlist_add_check_rounded, // Playlist Icon
                        size: 40,
                      ),
                    ),
                    const Text(
                      'Playlists',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.to(() => const RecentPage(),
                            transition: Transition.fadeIn);
                      },
                      icon: const Icon(
                        Icons.music_video_rounded,
                        size: 40,
                      ),
                    ),
                    const Text(
                      'Recent',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ), // Recent Icon
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Get.to(() =>  MostPlayedPage(),
                        //     transition: Transition.fadeIn);
                      },
                      icon: const Icon(
                        Icons.headphones_rounded,
                        size: 40,
                      ),
                    ),
                    const Text(
                      'Most Played',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.to(() => const AllSongsPage(),
                            transition: Transition.fadeIn);
                      },
                      icon: const Icon(
                        Icons.music_note_rounded,
                        size: 40,
                      ),
                    ),
                    const Text(
                      'All Songs',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    FutureBuilder<int>(
                      future: getTotalSongs(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Text(
                            '${snapshot.data} Songs',
                            style: const TextStyle(fontSize: 11),
                          );
                        }
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.to(() => const FavouritesPage(),
                            transition: Transition.fadeIn);
                      },
                      icon: const Icon(
                        Icons.favorite,
                        size: 40,
                      ),
                    ),
                    const Text(
                      'Favourites',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {Get.to((const RecentDownloaded()),transition: Transition.fadeIn);},
                      icon: const Icon(
                        Icons.download_done_rounded,
                        size: 42,
                      ),
                    ),
                    const Text(
                      "Recent ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Downloads',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
