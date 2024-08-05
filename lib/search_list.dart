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
    return Scaffold(bottomNavigationBar: const BottomMusicPlayer(),
      appBar: AppBar(forceMaterialTransparency: true,
        centerTitle: true,
        title: const Text(
          'Search Songs',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                onChanged: (query) async {
                  
                  List<SongModel> filteredSongs =
                      await controller.searchSongs(query);
                 
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
                          trailing: PopupMenuButton<String>(
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('Edit'),
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('Delete'),
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'addToFav',
                                child: ListTile(
                                  leading: Icon(Icons.favorite),
                                  title: Text('Add to Favorites'),
                                ),
                              ),
                            ],
                            onSelected: (String value) {
                             
                              switch (value) {
                                case 'edit':
                                  
                                  break;
                                case 'delete':
                                  controller
                                      .deleteSong(song); 
                                  break;
                                case 'addToFav':
                                  
                                  break;
                                default:
                                 
                                  break;
                              }
                            },
                          ),
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
                            
                            controller.playSong(song.uri, index);
                           
                            controller.updateSelectedSong(song);
                           
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
