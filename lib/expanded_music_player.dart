import 'package:deeptune_musicplayer/equalizer_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:deeptune_musicplayer/player_controller.dart';

class ExpandedMusicPlayer extends StatelessWidget {
  const ExpandedMusicPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();
    double paddingSize = Get.width * 0.04; // Padding size based on screen width
    double fontSize =
        Get.width * 0.04; // Adjust the font size based on screen width
    double iconSize = Get.width * 0.060;
    double iconSizep =
        Get.width * 0.1; // Adjust the icon size based on screen width
    return Padding(
      padding: EdgeInsets.all(paddingSize),
      child: Obx(() {
        var currentSong = controller.selectedSong.value;
        var isPlaying = controller.isPlaying.value;

        if (currentSong == null) {
          return const Center(child: Text('No song selected'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              elevation: 4,
              child: QueryArtworkWidget(
                id: currentSong.id,
                type: ArtworkType.AUDIO,
                artworkHeight: Get.height * 0.25,
                artworkWidth: Get.height * 0.25,
                artworkBorder: BorderRadius.circular(10),
                nullArtworkWidget: const Icon(
                  Icons.music_note_rounded,
                  size: 150,
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.01),
            Text(
              currentSong.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              currentSong.artist ?? 'Unknown Artist',
              style: TextStyle(color: Colors.grey, fontSize: fontSize),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: Get.height * 0.01),
            Slider(
              min: 0.0,
              max: controller.max.value,
              value: controller.value.value,
              onChanged: (value) {
                controller.changeDurationToSeconds(value.toInt());
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(controller.position.value),
                Text(controller.duration.value),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    if (!controller.isLooping.value &&
                        !controller.isShuffling.value &&
                        !controller.isRepeating.value) {
                      controller.toggleLoop();
                    } else if (controller.isLooping.value) {
                      controller.toggleShuffle();
                    } else if (controller.isShuffling.value) {
                      controller.toggleRepeat();
                    } else {
                      controller.toggleLoop();
                    }
                  },
                  icon: Obx(() {
                    if (controller.isLooping.value) {
                      return Icon(Icons.loop_rounded, size: iconSize);
                    } else if (controller.isShuffling.value) {
                      return Icon(Icons.shuffle_rounded, size: iconSize);
                    } else if (controller.isRepeating.value) {
                      return Icon(Icons.repeat_rounded, size: iconSize);
                    } else {
                      return Icon(Icons.loop_rounded,
                          size: iconSize); // Default to loop icon
                    }
                  }),
                ),
                IconButton(
                  icon: Icon(
                    Icons.replay_10_rounded,
                    size: iconSize,
                  ),
                  onPressed: () => controller.rewind(10),
                ),
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: iconSizep,
                  ),
                  onPressed: () {
                    if (isPlaying) {
                      controller.pauseSong();
                    } else {
                      controller.resumeSong();
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.forward_10_rounded,
                    size: iconSize,
                  ),
                  onPressed: () => controller.fastForward(10),
                ),
                IconButton(
                  onPressed: () {
                    Get.to(() => const EqualizerPage(),
                        transition: Transition.fadeIn);
                  },
                  icon: Icon(Icons.equalizer_rounded, size: iconSize),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
