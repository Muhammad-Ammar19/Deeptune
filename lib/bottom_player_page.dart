import 'package:deeptune_musicplayer/equalizer_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deeptune_musicplayer/player_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class BottomMusicPlayerPage extends StatelessWidget {
  final PlayerController controller = Get.find<PlayerController>();

  BottomMusicPlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentSong = controller.selectedSong.value;
    // var isPlaying = controller.isPlaying.value;

    if (currentSong == null) {
      return const Scaffold(
          body: Center(child: Text('No song is currently playing')));
    }

    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: Get.height * 0.05,
        child: const Placeholder(),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_vert_rounded))
        ],
        centerTitle: true,
        title: const Text(
          "Now Playing",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != 0) {
            if (details.primaryVelocity! > 0) {
              _playPreviousSong(controller);
            } else {
              _playNextSong(controller);
            }
          }
        },
        child: SingleChildScrollView(
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Get.height * 0.05),
                // Song image
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  elevation: 5,
                  child: QueryArtworkWidget(
                    id: currentSong.id,
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
                    ),
                  ),
                  title: Text(
                    currentSong.displayNameWOExt,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  subtitle: Text(
                    currentSong.artist ?? 'Unknown Artist',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      // Toggle favorite status
                    },
                    icon: const Icon(Icons.favorite_outline_rounded),
                  ),
                ),
                Obx(
                  () => Slider(
                    min: 0,
                    max: controller.max.value.toDouble(),
                    value: controller.value.value.toDouble(),
                    onChanged: (newValue) {
                      controller.changeDurationToSeconds(newValue.toInt());
                    },
                  ),
                ),
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
                      icon: const Icon(Icons.shuffle_rounded),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.rewind(10);
                      },
                      icon: const Icon(Icons.replay_10_rounded),
                    ),
                    IconButton(
                      onPressed: () => _playPreviousSong(controller),
                      icon: const Icon(
                        Icons.skip_previous_rounded,
                        size: 25,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (controller.isPlaying.value) {
                          controller.pauseSong();
                        } else {
                          controller.resumeSong();
                        }
                      },
                      icon: Obx(
                        () => Icon(
                          controller.isPlaying.value
                              ? Icons.pause
                              : Icons.play_arrow_rounded,
                          size: 40,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _playNextSong(controller),
                      icon: const Icon(
                        Icons.skip_next_rounded,
                        size: 28,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.fastForward(10);
                      },
                      icon: const Icon(Icons.forward_10_rounded),
                    ),
                    IconButton(
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
    );
  }

  void _playPreviousSong(PlayerController controller) {
    int prevIndex = controller.playIndex.value - 1;
    if (prevIndex < 0) {
      prevIndex = controller.searchResults.length - 1;
    }
    controller.playSong(controller.searchResults[prevIndex].uri, prevIndex);
  }

  void _playNextSong(PlayerController controller) {
    int nextIndex = controller.playIndex.value + 1;
    if (nextIndex >= controller.searchResults.length) {
      nextIndex = 0;
    }
    controller.playSong(controller.searchResults[nextIndex].uri, nextIndex);
  }
}
