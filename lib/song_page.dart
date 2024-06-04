import 'dart:math';
import 'package:deeptune_musicplayer/ad_controller.dart';
import 'package:deeptune_musicplayer/equalizer_page.dart';
import 'package:deeptune_musicplayer/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
    
    double iconSize = Get.width * 0.06; // Adjust the icon size based on screen width
    double fontSize = Get.width * 0.04; // Adjust the font size based on screen width
    double artworkHeight = Get.height * 0.52; // Artwork height based on screen height
    double artworkWidth = Get.width * 1.0; // Artwork width based on screen width
    double paddingSize = Get.width * 0.02; // Padding size based on screen width
    
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
        appBar: AppBar(forceMaterialTransparency: true,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () { AdManager.showInterstitialAd(); },
                icon: Icon(Icons.more_vert_rounded, size: iconSize)
            )
          ],
          title: Text(
            "Now Playing",
            style: TextStyle(fontSize: fontSize * 1.1, fontWeight: FontWeight.bold),
          ),
        ),
        bottomNavigationBar: AdManager.isSecondaryBannerAdLoaded()
            ? SizedBox(
                height: 60, 
                child: AdWidget(ad: AdManager.secondaryBannerAd!),
              )
            : null, 
        body: SafeArea(
          child: Obx(
            () => SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: paddingSize),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: double.infinity, height: Get.height * 0.038),
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: paddingSize),
                      elevation: 5,
                      child: QueryArtworkWidget(
                        id: data[controller.playIndex.value].id,
                        type: ArtworkType.AUDIO,
                        artworkHeight: artworkHeight,
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
                    SizedBox(height: Get.height * 0.0039),
                    ListTile(
                      leading: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.playlist_add, size: iconSize)
                      ),
                      title: Text(
                        data[controller.playIndex.value].displayNameWOExt,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize *0.94,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                      subtitle: Text(
                        data[controller.playIndex.value].artist ?? 'Unknown Artist',
                        style: TextStyle(fontSize: fontSize * 0.7),
                      ),
                      trailing: Obx(() => IconButton(
                          onPressed: () {
                            controller.toggleFavorite(data[controller.playIndex.value]);
                          },
                          icon: Icon(
                            controller.isFavorite(data[controller.playIndex.value])
                                ? Icons.favorite
                                : Icons.favorite_outline_rounded,
                            size: iconSize,
                          )
                      )),
                    ),
                    Obx(
                      () => Slider(
                        min: 0,
                        max: controller.max.value.toDouble(),
                        value: min(max(0, controller.value.value.toDouble()), controller.max.value.toDouble()),
                        onChanged: (newValue) {
                          controller.changeDurationToSeconds(newValue.toInt());
                        },
                      ),
                    ),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.position.value,
                            style: TextStyle(color: Colors.grey, fontSize: fontSize * 0.7),
                          ),
                       
                          Text(
                            controller.duration.value,
                            style: TextStyle(color: Colors.grey, fontSize: fontSize * 0.7),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (!controller.isLooping.value && !controller.isShuffling.value && !controller.isRepeating.value) {
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
                              return Icon(Icons.loop_rounded, size: iconSize); // Default to loop icon
                            }
                          }),
                        ),
                        IconButton(
                            onPressed: () {
                              controller.rewind(10); // Rewind button
                            },
                            icon: Icon(Icons.replay_10_rounded, size: iconSize)
                        ),
                        IconButton(
                          onPressed: () {
                            int prevIndex = controller.playIndex.value - 1;
                            if (prevIndex < 0) {
                              prevIndex = data.length - 1;
                            }
                            controller.playSong(data[prevIndex].uri, prevIndex);
                          },
                          icon: Icon(
                            Icons.skip_previous_rounded, // Previous Button
                            size: iconSize * 1.25,
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
                              size: iconSize * 1.30,
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
                          icon: Icon(
                            Icons.skip_next_rounded, //Next Buttons
                            size: iconSize * 1.4,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              controller.fastForward(10); //Forward Button
                            },
                            icon: Icon(Icons.forward_10_rounded, size: iconSize)
                        ),
                        IconButton(
                          onPressed: () {
                            Get.to(() => const EqualizerPage(), transition: Transition.fadeIn);
                          },
                          icon: Icon(Icons.equalizer_rounded, size: iconSize),
                        ),
                      ],
                    ),
                  ],
                ),
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

