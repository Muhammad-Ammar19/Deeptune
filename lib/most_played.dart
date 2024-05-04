

// class MostPlayedPage extends StatelessWidget {
//   final PlayerController controller = Get.find<PlayerController>();

//    MostPlayedPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     List<SongModel> mostPlayedSongs = controller.getMostPlayedSongs();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Most Played'),
//       ),
//       body: ListView.builder(
//         itemCount: mostPlayedSongs.length,
//         itemBuilder: (context, index) {
//           final song = mostPlayedSongs[index];
//           return ListTile(
//             leading: Card(
//               elevation: 4,
//               child: QueryArtworkWidget(
//                 id: song.id,
//                 type: ArtworkType.AUDIO,
//                 nullArtworkWidget: const Icon(
//                   Icons.music_note_rounded,
//                   size: 50,
//                 ),
//                 artworkFit: BoxFit.cover,
//                 artworkBorder: BorderRadius.circular(4),
//               ),
//             ),
//             title: Text(
//               song.displayNameWOExt,
//               overflow: TextOverflow.ellipsis,
//               maxLines: 1,
//               style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
//             ),
//             subtitle: Text(
//               "${song.artist}",
//               style: const TextStyle(fontSize: 11),
//             ),
//             trailing: controller.playIndex.value == index && controller.isPlaying.value ? const Icon(Icons.play_arrow_rounded) : null,
//             onTap: () {
//               // Play the selected song
//               controller.playSong(song.uri, index);
//               controller.updateSelectedSong(song);
//               Get.to(() => SongPage(data: mostPlayedSongs), transition: Transition.fadeIn);
//             },
//           );
//         },
//       ),
//     );
//   }
// }
