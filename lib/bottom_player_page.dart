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
    double iconSize = Get.width * 0.06; // Adjust the icon size based on screen width
    double fontSize = Get.width * 0.04; // Adjust the font size based on screen width
    double artworkHeight = Get.height * 0.50; // Artwork height based on screen height
    double artworkWidth = Get.width * 1.0; // Artwork width based on screen width
    double paddingSize = Get.width * 0.02; // Padding size based on screen width
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_vert_rounded))
        ],
        centerTitle: true,
        title:  Text(
          "Now Playing",
          style: TextStyle(fontSize: fontSize * 1.1, fontWeight: FontWeight.bold),
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingSize),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Get.height * 0.05),
                // Song image
                Card(
                 margin: EdgeInsets.symmetric(horizontal: paddingSize),
                  elevation: 5,
                  child: QueryArtworkWidget(
                    id: currentSong.id,
                    type: ArtworkType.AUDIO,
                    artworkHeight: Get.height * 0.48,
                    artworkFit: BoxFit.cover,
                    artworkQuality: FilterQuality.high,
                    artworkBorder: BorderRadius.circular(6),
                    artworkWidth: artworkWidth,
                    quality: 100,
                    nullArtworkWidget: Icon(
                      Icons.music_note_rounded,
                      size: artworkHeight,
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.07),
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                     fontSize: fontSize *0.94,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  subtitle: Text(
                    currentSong.artist ?? 'Unknown Artist',
                    style:  TextStyle(fontSize: fontSize * 0.7),
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
                             TextStyle(color: Colors.grey,fontSize: fontSize * 0.7),
                      ),
                      const SizedBox(width: 310),
                      Text(
                        controller.duration.value,
                        style:
                             TextStyle(color: Colors.grey, fontSize: fontSize * 0.7),
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
                      icon:  Icon(Icons.replay_10_rounded,size: iconSize),
                    ),
                    IconButton(
                      onPressed: () => _playPreviousSong(controller),
                      icon:  Icon(
                        Icons.skip_previous_rounded,
                        size: iconSize,
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
                          size: iconSize * 1.5,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _playNextSong(controller),
                      icon:  Icon(
                        Icons.skip_next_rounded,
                         size: iconSize * 1.4,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.fastForward(10);
                      },
                      icon:  Icon(Icons.forward_10_rounded,size: iconSize),
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
    prevIndex = controller.recentlyPlayedSongs.length - 1;
  }
  controller.playIndex.value = prevIndex; // Update the playIndex value
  controller.playSong(controller.recentlyPlayedSongs[prevIndex].uri, prevIndex);
}

void _playNextSong(PlayerController controller) {
  int nextIndex = controller.playIndex.value + 1;
  if (nextIndex >= controller.recentlyPlayedSongs.length) {
    nextIndex = 0;
  }
  controller.playIndex.value = nextIndex; // Update the playIndex value
  controller.playSong(controller.recentlyPlayedSongs[nextIndex].uri, nextIndex);
}
}
