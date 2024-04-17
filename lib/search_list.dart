import 'package:deeptune_musicplayer/bottom_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:deeptune_musicplayer/player_controller.dart';
import 'package:deeptune_musicplayer/song_page.dart';

class SearchList extends StatelessWidget {
  final PlayerController controller = Get.find<PlayerController>();

  SearchList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Search Songs',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
    
   
      ),
      bottomNavigationBar: const BottomMusicPlayer(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                onChanged: (query) async {
                  // Trigger search when text changes
                  List<SongModel> filteredSongs =
                      await controller.searchSongs(query);
                  // Update UI with filtered songs
                  controller.updateSearchResults(filteredSongs);
                },
                decoration: const InputDecoration(
                  hintText: 'Search your library....',
                ),
              ),
            ),
            Obx(() {
              List<SongModel> searchResults = controller.searchResults;

              if (searchResults.isEmpty) {
                return const Expanded(
                  child: Center(
                    child: Text("No Songs found"),
                  ),
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      SongModel song = searchResults[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 3, top: 3),
                        child: ListTile(
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
                              artworkQuality: FilterQuality.high,
                            ),
                          ),
                          trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.more_vert_rounded)),
                          title: Text(
                            song.displayNameWOExt,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                          subtitle: Text(
                            song.artist ?? 'Unknown Artist',
                            style: const TextStyle(fontSize: 11),
                          ),
                          onTap: () {
                            // Play the selected song
                            controller.playSong(song.uri, index);
                            // Update selected song in the controller
                            controller.updateSelectedSong(song);
                            // Navigate to SongPage
                            Get.to(() => SongPage(data: searchResults),
                                transition: Transition.fadeIn);
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
