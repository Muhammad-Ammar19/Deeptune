
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';





class PlayerController extends GetxController {
  final audioquery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
  final Rx<SongModel?> selectedSong = Rx<SongModel?>(null);
  var isPlaying = false.obs;
  var max = 0.0.obs; // Change to double
  var value = 0.0.obs; // Change to double
  var  playIndex = 0.obs;
  var duration =''.obs;
  var position =''.obs;
 final searchResults = <SongModel>[].obs;





 void updateSelectedSong(SongModel data) {    // song changed to data
    selectedSong.value = data;
  }

  @override
  void onInit() {
    super.onInit();
     checkPermission();
     initAudioPlayerListeners(); 
   
  }





void initAudioPlayerListeners() {
    audioPlayer.durationStream.listen((d) {
      if (d != null) {
        final durationInSeconds = d.inSeconds;
        final minutes = (durationInSeconds ~/ 60).toString().padLeft(2, '0');
        final seconds = (durationInSeconds % 60).toString().padLeft(2, '0');
        duration.value = '$minutes:$seconds';
        max.value = durationInSeconds.toDouble();
      }
    });

    audioPlayer.positionStream.listen((p) {
      final positionInSeconds = p.inSeconds;
      final minutes = (positionInSeconds ~/ 60).toString().padLeft(2, '0');
      final seconds = (positionInSeconds % 60).toString().padLeft(2, '0');
      position.value = '$minutes:$seconds';
      value.value = positionInSeconds.toDouble();
        });

    audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        playNextSong();
      }
    });
  }

  void playSong(String? uri, int index) {
    playIndex.value = index;
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
      isPlaying(true);
    
    // ignore: empty_catches
    } on Exception {
    }
  }

 void playNextSong() {
    final currentIndex = playIndex.value;
    if (currentIndex < searchResults.length - 1) {
      playSong(searchResults[currentIndex + 1].uri, currentIndex + 1);
    } else {
      // Optionally handle end of songs
      stopSong();
    }
  }

  void stopSong() {
    audioPlayer.stop();
    isPlaying.value = false;
  }

   // Play Pause
  void togglePlayPause() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
  }

   void pauseSong() {
    audioPlayer.pause();
    isPlaying.value = false;
  }

  void resumeSong() {
    audioPlayer.play();
    isPlaying.value = true;
  }
  




   // Search function to filter songs based on a search query
  Future<List<SongModel>> searchSongs(String query) async {
    try {
      var songs = await audioquery.querySongs(
        sortType: SongSortType.TITLE,
        uriType: UriType.EXTERNAL,
      );

      if (query.isEmpty) {
        return songs;
      }



// Filter songs based on the search query (case-insensitive)
      var filteredSongs = songs.where((song) {
        return song.title.toLowerCase().contains(query.toLowerCase());
      }).toList();

      return filteredSongs;
    } catch (e) {

      return [];
    }
  }

  // Update search results with filtered songs
  void updateSearchResults(List<SongModel> results) {
    searchResults.assignAll(results);
  }





  
// For starting and ending time duration 
void updatedPosition() {
  audioPlayer.durationStream.listen((d) {
    if (d != null) {
      final durationInSeconds = d.inSeconds;
      final durationValue = durationInSeconds.toDouble();
      final minutes = (durationInSeconds ~/ 60).toString().padLeft(2, '0');
      final seconds = (durationInSeconds % 60).toString().padLeft(2, '0');
      duration.value = '$minutes:$seconds';
      max.value = durationValue;
    }
  });

  audioPlayer.positionStream.listen((p) {
    final positionInSeconds = p.inSeconds;
    final positionValue = positionInSeconds.toDouble();
    final minutes = (positionInSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (positionInSeconds % 60).toString().padLeft(2, '0');
    position.value = '$minutes:$seconds';

    // Clamp positionValue to be within the valid range [0.0, max.value]
    final clampedValue = positionValue.clamp(0.0, max.value);
    value.value = clampedValue;
    });
}



 // Rewind Code 
 void rewind(int seconds) {
    final currentPosition = audioPlayer.position;
    final newPosition = currentPosition - Duration(seconds: seconds);
    audioPlayer.seek(newPosition);
  }



// FastForward Code
void fastForward(int seconds) {
  final currentPosition = audioPlayer.position;
  final newPosition = currentPosition + Duration(seconds: seconds);
  audioPlayer.seek(newPosition);
}


//  for slider seeking 
changeDurationToSeconds(seconds){
  var duration = Duration(seconds: seconds);
  audioPlayer.seek(duration);
}


// playSong(String? uri, index){
//   playIndex.value = index;
//   try{
//     audioPlayer.setAudioSource(
//       AudioSource.uri(Uri.parse(uri!)));
//       audioPlayer.play();
//       isPlaying(true);
//       updatedPosition();
//  } on Exception catch (e){ e;}
// }
// }

  @override
  void onClose() {
    audioPlayer.dispose(); // Clean up resources when controller is closed
    super.onClose();
  }

  

 checkPermission() async {
    var perm = await Permission.storage.request();
    if (perm.isGranted) {
    } else {
      checkPermission();
    }
  }
}