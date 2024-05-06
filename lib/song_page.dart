import 'dart:math';
import 'package:deeptune_musicplayer/ad_controller.dart';
import 'package:deeptune_musicplayer/equalizer_page.dart';
import 'package:deeptune_musicplayer/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongPage extends StatelessWidget {
  final List<SongModel> data;
  
  const SongPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();
    
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != 0) {
          if (details.primaryVelocity! > 0) {
            // Swipe from left to right (right direction)
            _playPreviousSong(controller);
          } else {
            // Swipe from right to left (left direction)
            _playNextSong(controller);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {   AdManager.showInterstitialAd();    }, icon: const Icon(Icons.more_vert_rounded))
          ],
          title: const Text(
            "Now Playing",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        bottomNavigationBar:SizedBox(height: Get.height *0.06,child: const Placeholder(),),
        body: SafeArea(
          child: Obx(
            () => SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: double.infinity, height: Get.height * 0.05),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    elevation: 5,
                    child: QueryArtworkWidget(
                      id: data[controller.playIndex.value].id,
                      type: ArtworkType.AUDIO,
                      artworkHeight: Get.height * 0.48,
                      artworkFit: BoxFit.cover,
                      artworkQuality: FilterQuality.high,
                      artworkBorder: BorderRadius.circular(6),
                      artworkWidth: double.infinity,
                      quality: 100,
                      nullArtworkWidget: const Icon(
                        Icons.music_note_rounded,
                        size: 405,
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.04),
                  ListTile(
                    leading: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.playlist_add,
                          size: 25,
                        )),
                    title: Text(
                      data[controller.playIndex.value].displayNameWOExt,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                    subtitle: Text(
                      data[controller.playIndex.value].artist ??
                          'Unknown Artist',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          // Toggle favorite status
                        },
                        icon: const Icon(Icons.favorite_outline_rounded)),
                  ),Obx(
  () => Slider(
    min: 0,
    max: controller.max.value.toDouble(),
    value: min(max(0, controller.value.value.toDouble()), controller.max.value.toDouble()),
    onChanged: (newValue) {
      controller.changeDurationToSeconds(newValue.toInt());
    },
  ),
),
                  // Obx(
                  //   () => Slider(
                  //     min: 0,
                  //     max: controller.max.value.toDouble(),
                  //     value: controller.value.value.toDouble(),
                  //     onChanged: (newValue) {
                  //       controller.changeDurationToSeconds(newValue.toInt());
                  //     },
                  //   ),
                  // ),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          controller.position.value,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(width: 310),
                        Text(
                          controller.duration.value,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                              Icons.shuffle_rounded)), // Reapeat, Loop, Shuffle
                      IconButton(
                          onPressed: () {
                            controller.rewind(10); // Rewind button
                          },
                          icon: const Icon(Icons.replay_10_rounded)),
                      IconButton(
                        onPressed: () {
                          int prevIndex = controller.playIndex.value - 1;
                          if (prevIndex < 0) {
                            prevIndex = data.length - 1;
                          }
                          controller.playSong(data[prevIndex].uri, prevIndex);
                        },
                        icon: const Icon(
                          Icons.skip_previous_rounded, // Previous Button
                          size: 25,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (controller.isPlaying.value) {
                            //Play/Pause Button
                            controller.audioPlayer.pause();
                            controller.isPlaying(false);
                          } else {
                            controller.audioPlayer.play();
                            controller.isPlaying(true);
                          }
                        },
                        icon: Obx(
                          () => Icon(
                            controller.isPlaying.value
                                ? Icons.pause
                                : Icons.play_arrow_rounded, //Play/Pause Button
                            size: 40,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          int nextIndex = controller.playIndex.value + 1;
                          if (nextIndex >= data.length) {
                            nextIndex = 0;
                          }
                          controller.playSong(data[nextIndex].uri, nextIndex);
                        },
                        icon: const Icon(
                          Icons.skip_next_rounded, //Next Buttons
                          size: 28,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            controller.fastForward(10); //Forward Button
                          },
                          icon: const Icon(Icons.forward_10_rounded)),
                      IconButton(
                        //Equalizer Button

                        onPressed: () {
                          Get.to(() => const EqualizerPage(),
                              transition: Transition.fadeIn);
                        },
                        icon: const Icon(Icons.equalizer_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _playPreviousSong(PlayerController controller) {
    int prevIndex = controller.playIndex.value - 1;
    if (prevIndex < 0) {
      prevIndex = data.length - 1;
    }
    controller.playSong(data[prevIndex].uri, prevIndex);
  }

  void _playNextSong(PlayerController controller) {
    int nextIndex = controller.playIndex.value + 1;
    if (nextIndex >= data.length) {
      nextIndex = 0;
    }
    controller.playSong(data[nextIndex].uri, nextIndex);
  }
}
