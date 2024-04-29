import 'package:deeptune_musicplayer/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class BottomMusicPlayer extends StatelessWidget {
  
    const BottomMusicPlayer({super.key});
  

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();                               // Access PlayerController
  
    return Obx(() {
      var currentSong = controller.selectedSong.value;
      var isPlaying = controller.isPlaying.value;

      if (currentSong == null) {
        return const Card();                                                     // Placeholder widget when no song is selected
      }

      return GestureDetector( onTap: () {
    
      },
        child: Card(elevation: 4,
          child: Container(
            height: Get.height *0.1,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [ 
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
        ),
      );
    });
  }
}





































