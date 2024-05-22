import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:deeptune_musicplayer/player_controller.dart';
import 'package:deeptune_musicplayer/song_page.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();

    return Scaffold(
      appBar: AppBar(forceMaterialTransparency: true,
        title: const Text(
          'Favourites',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.favoriteSongs.isEmpty) {
          return const Center(
            child: Text("No favorite songs"),
          );
        } else {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: controller.favoriteSongs.length,
            itemBuilder: (BuildContext context, int index) {
              var song = controller.favoriteSongs[index];
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
                      fontWeight: FontWeight.w500, fontSize: 14),
                ),
                subtitle: Text(
                  song.artist ?? 'Unknown Artist',
                  style: const TextStyle(fontSize: 11),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {
                    controller.toggleFavorite(song);
                  },
                ),
                onTap: () {
                  controller.playSong(song.uri, index);
                  Get.to(() => SongPage(data: controller.favoriteSongs),
                      transition: Transition.fadeIn);
                },
              );
            },
          );
        }
      }),
    );
  }
}
