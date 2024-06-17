import 'package:deeptune_musicplayer/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';



class MostPlayedPage extends StatelessWidget {
  const MostPlayedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerController>();

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,

        title: const Text(
          'Most Played',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () {
          if (controller.playCounts.isEmpty) {
            return const Center(child: Text("No Songs were found"));
          } else {
            final mostPlayedSongs = controller.playCounts.entries
                .map((entry) {
                  final song = controller.searchResults.firstWhereOrNull((song) => song.id == entry.key);
                  if (song != null) {
                    return MapEntry(song, entry.value);
                  } else {
                    return null;
                  }
                })
                .where((entry) => entry != null)
                .toList()
                ..sort((a, b) => b!.value.compareTo(a!.value));

            if (mostPlayedSongs.isEmpty) {
              return const Center(child: Text("No Songs were found"));
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: mostPlayedSongs.length,
              itemBuilder: (BuildContext context, int index) {
                final song = mostPlayedSongs[index]!.key;
                final playCount = mostPlayedSongs[index]!.value;

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
                    '${song.artist ?? 'Unknown Artist'}\nPlay Count: $playCount',
                    style: const TextStyle(fontSize: 11),
                  ),
                  onTap: () {
                    controller.playSong(song.uri, controller.searchResults.indexOf(song));
                    controller.updateSelectedSong(song);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}