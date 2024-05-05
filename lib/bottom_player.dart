import 'package:deeptune_musicplayer/bottom_player_page.dart';
import 'package:deeptune_musicplayer/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class BottomMusicPlayer extends StatelessWidget {
  const BottomMusicPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();

    return GestureDetector(
      onTap: () {
        Get.to(() => BottomMusicPlayerPage(), transition: Transition.fadeIn);
      },
      child: Obx(() {
        var currentSong = controller.selectedSong.value;
        var isPlaying = controller.isPlaying.value;

        if (currentSong == null) {
          return const Card();
        }

        return Card(
          elevation: 4,
          child: Container(
            height: Get.height * 0.09,
            width: double.infinity,
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                // Song Image
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  elevation: 4,
                  child: QueryArtworkWidget(
                    id: currentSong.id,
                    type: ArtworkType.AUDIO,
                    artworkHeight: Get.height * 0.06,
                    artworkFit: BoxFit.cover,
                    artworkQuality: FilterQuality.high,
                    artworkBorder: BorderRadius.circular(4),
                    artworkWidth: Get.height * 0.06,
                    quality: 100,
                    nullArtworkWidget: const Icon(
                      Icons.music_note_rounded,
                      size: 50,
                    ),
                  ),
                ),
                // Song Info and Controls
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentSong.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        currentSong.artist ?? 'Unknown Artist',
                        style: const TextStyle(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Get.height * 0.01),
                        child: LinearProgressIndicator(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          value: (controller.value.value / controller.max.value)
                              .clamp(0.0, 1.0),
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.deepPurple.shade300),
                        ),
                      ),
                    ],
                  ),
                ),

                // Play/Pause and Next Button
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    if (isPlaying) {
                      controller.pauseSong();
                    } else {
                      controller.resumeSong();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
