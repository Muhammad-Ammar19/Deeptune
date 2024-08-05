import 'dart:math';

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

    double fontSize = 18;
    double iconSize = 25;
    double iconSizep = 35;
    double nullIcon = 200;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Obx(() {
        SongModel? currentSong = controller.selectedSong.value;
        bool isPlaying = controller.isPlaying.value;

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
                artworkWidth: Get.width * 0.5,
                artworkBorder: BorderRadius.circular(10),
                nullArtworkWidget: Icon(
                  Icons.music_note_rounded,
                  size: nullIcon,
                ),
              ),
            ),
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
         
            Slider(
              min: 0,
              max: controller.max.value.toDouble(),
              value: min(max(0, controller.value.value.toDouble()),
                  controller.max.value.toDouble()),
              onChanged: (newValue) {
                controller.changeDurationToSeconds(newValue.toInt());
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(controller.position.value),
                Text(controller.duration.value),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // Space between icons
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
                        return Icon(Icons.double_arrow_rounded, size: iconSize);
                      } else if (controller.isShuffling.value) {
                        return Icon(Icons.shuffle_rounded, size: iconSize);
                      } else if (controller.isRepeating.value) {
                        return Icon(Icons.repeat_rounded, size: iconSize);
                      } else {
                        return Icon(Icons.loop_rounded, size: iconSize);
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
                      Icons.skip_previous_rounded,
                      size: iconSize,
                    ),
                    onPressed: () => controller.playPreviousSong(),
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
                      Icons.skip_next_rounded,
                      size: iconSize,
                    ),
                    onPressed: () => controller.playNextSong(),
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
            ),
          ],
        );
      }),
    );
  }
}
