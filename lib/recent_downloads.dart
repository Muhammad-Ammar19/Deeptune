import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:deeptune_musicplayer/player_controller.dart';
import 'package:deeptune_musicplayer/song_page.dart';


class RecentDownloaded extends StatelessWidget {
  const RecentDownloaded({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerController controller = Get.put(PlayerController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Recently Downloaded",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: _getRecentDownloads(controller),
        builder: (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No songs were found."),
            );
          } else {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final SongModel song = snapshot.data![index];
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
                      artworkBorder: const BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                  title: Text(
                    song.title,
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
                  trailing: controller.playIndex.value == index && controller.isPlaying.value
                      ? const Icon(Icons.play_arrow_rounded)
                      : null,
                  onTap: () {
                    controller.playSong(song.uri, index);
                    controller.updateSelectedSong(song);
                    Get.to(() => SongPage(data: snapshot.data!),
                      transition: Transition.fadeIn,
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<SongModel>> _getRecentDownloads(PlayerController controller) async {
    List<SongModel> songs = await controller.audioquery.querySongs(
      ignoreCase: true,
      orderType: null,
      sortType: SongSortType.DATE_ADDED,
      uriType: UriType.EXTERNAL,
    );
    songs = songs.reversed.toList(); // Reverse the list to show most recent downloads first
    return songs;
  }
}

