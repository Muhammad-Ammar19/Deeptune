import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deeptune_musicplayer/player_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class RecentlyPlayed extends StatelessWidget {
  const RecentlyPlayed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();

    return SizedBox(
      height: Get.height * 0.11,
      width: double.infinity,
      child: Obx(
        () {
          if (controller.recentlyPlayedSongs.isEmpty) {
            // If no recently played songs, show music note icon
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.music_note_rounded,
                size: 50,
              ),
            );
          } else {
            // Show recently played songs
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.recentlyPlayedSongs.length,
              itemBuilder: (context, index) {
                var song = controller.recentlyPlayedSongs[index];
                return GestureDetector(
                  onTap: () {
                    // Play the tapped song
                    
                    controller.playSong(song.uri, index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          elevation: 4,
                          child: QueryArtworkWidget(
                            id: song.id,
                            type: ArtworkType.AUDIO,
                            artworkHeight: Get.height * 0.08,
                            artworkFit: BoxFit.cover,
                            artworkQuality: FilterQuality.high,
                            artworkBorder: BorderRadius.circular(4),
                            artworkWidth: Get.width * 0.17,
                            quality: 100,
                            nullArtworkWidget: const Icon(
                              Icons.music_note_rounded,
                              size: 59,
                            ),
                          ),
                        ),
                        Text(
                          song.artist ?? 'Unknown Artist',maxLines: 1,overflow: TextOverflow.clip,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
