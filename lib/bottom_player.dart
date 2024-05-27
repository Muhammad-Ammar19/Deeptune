import 'package:deeptune_musicplayer/expanded_music_player.dart';
import 'package:deeptune_musicplayer/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class BottomMusicPlayer extends StatelessWidget {
  const BottomMusicPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();
    double paddingSize = Get.width * 0.02; // Padding size based on screen width
    double fontSize =
        Get.width * 0.035; // Adjust the font size based on screen width
    return GestureDetector(
      onTap: () {
        // Get.to(() => BottomMusicPlayerPage(), transition: Transition.fadeIn);
        showModalBottomSheet(
          elevation: 4,
          context: context,
          isScrollControlled: true,sheetAnimationStyle:AnimationStyle(curve: Curves.bounceInOut),
          builder: (context) => DraggableScrollableSheet(
            expand: false,
            builder: (context, scrollController) => SingleChildScrollView(
              controller: scrollController,
              child: const ExpandedMusicPlayer(),
            ),
          ),
        );
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
            padding: EdgeInsets.only(right: paddingSize),
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: fontSize),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        currentSong.artist ?? 'Unknown Artist',
                        style:
                            TextStyle(color: Colors.grey, fontSize: fontSize),
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
                              Colors.deepPurple.shade200),
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
