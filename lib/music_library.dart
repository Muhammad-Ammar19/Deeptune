import 'package:deeptune_musicplayer/ad_controller.dart';
import 'package:deeptune_musicplayer/all_songs_page.dart';
import 'package:deeptune_musicplayer/favourites.dart';
import 'package:deeptune_musicplayer/player_controller.dart';
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
    final PlayerController playerController = Get.find<PlayerController>(); // Get the PlayerController instance
    final bannerAdWidget = AdManager.getBannerAdWidget();

    double iconSize = Get.width * 0.1; // Adjust the icon size based on screen width
    double fontSize = Get.width * 0.04; // Adjust the font size based on screen width

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Music Library",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize * 1.2),
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
                        Get.to(() => const PlaylistScreen(), transition: Transition.fadeIn);
                      },
                      icon: Icon(
                        Icons.playlist_add_check_rounded, // Playlist Icon
                        size: iconSize,
                      ),
                    ),
                    Text(
                      'Playlists',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.to(() => const RecentPage(), transition: Transition.fadeIn);
                      },
                      icon: Icon(
                        Icons.music_video_rounded,
                        size: iconSize,
                      ),
                    ),
                    Text(
                      'Recent',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
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
                      icon: Icon(
                        Icons.headphones_rounded,
                        size: iconSize,
                      ),
                    ),
                    Text(
                      'Most Played',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize * 0.9),
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
                        Get.to(() => const AllSongsPage(), transition: Transition.fadeIn);
                      },
                      icon: Icon(
                        Icons.music_note_rounded,
                        size: iconSize,
                      ),
                    ),
                    Text(
                      'All Songs',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
                    ),
                    FutureBuilder<int>(
                      future: getTotalSongs(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Text(
                            '${snapshot.data} Tracks',
                            style: TextStyle(fontSize: fontSize * 0.7),
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
                        Get.to(() => const FavouritesPage(), transition: Transition.fadeIn);
                      },
                      icon: Icon(
                        Icons.favorite,
                        size: iconSize,
                      ),
                    ),
                    Text(
                      'Favourites',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
                    ),
                    Obx(() {
                      final favoriteCount = playerController.favoriteSongs.length;
                      return Text(
                        '$favoriteCount Favorites',
                        style: TextStyle(fontSize: fontSize * 0.7),
                      );
                    }),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.to(() => RecentDownloaded(), transition: Transition.fadeIn);
                      },
                      icon: Icon(
                        Icons.download_done_rounded,
                        size: iconSize * 1.05,
                      ),
                    ),
                    Text(
                      "Recent ",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize * 0.9),
                    ),
                    Text(
                      'Downloads',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize * 0.9),
                    ),
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
