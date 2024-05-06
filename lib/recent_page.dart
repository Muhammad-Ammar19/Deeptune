import 'package:deeptune_musicplayer/search_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deeptune_musicplayer/player_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:deeptune_musicplayer/song_page.dart';

class RecentPage extends StatelessWidget {
  const RecentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerController>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
              onTap: () {
                Get.to(() => SearchList(), transition: Transition.fadeIn);
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 18),
                child: Icon(
                  Icons.search,
                  size: 25,
                ),
              ))
        ],
        title: const Text(
          'Recent',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.recentlyPlayedSongs.isEmpty
            ? const Center(child: Text("No Songs were found"))
            : Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.recentlyPlayedSongs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final song = controller.recentlyPlayedSongs[index];
                    return ListTile(
                      leading: Card(
                        elevation: 4,
                        child: QueryArtworkWidget(
                          id: song.id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Icon(
                            Icons.music_note_rounded,
                            size: 50,
                          ),
                          artworkFit: BoxFit.cover,
                          artworkBorder: BorderRadius.circular(4),
                        ),
                      ),
                      title: Text(
                        song.displayNameWOExt,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        song.artist ?? 'Unknown Artist',
                        style: const TextStyle(fontSize: 11),
                      ),
                      onTap: () {
                        // Play the tapped song
                        controller.playSong(song.uri, index);
                        // Navigate to the song page
                        Get.to(
                            () =>
                                SongPage(data: controller.recentlyPlayedSongs),
                            transition: Transition.fadeIn);
                      },
                    );
                  },
                ),
              ),
      ),
    );
  }
}
