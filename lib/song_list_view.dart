import 'package:deeptune_musicplayer/player_controller.dart';
import 'package:deeptune_musicplayer/song_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongListView extends StatelessWidget {
  const SongListView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());

    return FutureBuilder<List<SongModel>>(
      future: controller.audioquery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          uriType: UriType.EXTERNAL),
      builder: (BuildContext context, snapshot) {
        if (snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text("Snap,No Songs were found"),
          );
        } else {
          return Expanded(
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Card(
                      elevation: 4,
                      child: QueryArtworkWidget(
                        id: snapshot.data![index].id,
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
                      snapshot.data![index].displayNameWOExt,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    subtitle: Text(
                      "${snapshot.data![index].artist}",
                      style: const TextStyle(fontSize: 11),
                    ),
                    trailing: controller.playIndex.value == index &&
                            controller.isPlaying.value
                        ? const Icon(Icons.play_arrow_rounded)
                        : null,
                    onTap: () {
                      controller.playSong(snapshot.data![index].uri, index);

                      Get.find<PlayerController>()
                          .updateSelectedSong(snapshot.data![index]);
                      Get.to(() => SongPage(data: snapshot.data!),
                          transition: Transition.fadeIn);
                    },
                  );
                }),
          );
        }
      },
    );
  }
}
