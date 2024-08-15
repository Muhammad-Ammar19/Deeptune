import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PlayerController extends GetxController {
  final audioquery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
  final Rx<SongModel?> selectedSong = Rx<SongModel?>(null);
  var isPlaying = false.obs;
  var max = 0.0.obs; 
  var value = 0.0.obs; 
  var playIndex = 0.obs;
  var duration = ''.obs;
  var position = ''.obs;
  final searchResults = <SongModel>[].obs;
  final recentlyPlayedSongs = <SongModel>[].obs;
  var favoriteSongs = <SongModel>[].obs; 
  var isLooping = false.obs;
  var isShuffling = false.obs;
  var isRepeating = false.obs;
  final playCounts = <int, int>{}.obs;


  void updateSelectedSong(SongModel song) {
    
    selectedSong.value = song;
  }
void onSongSelected(SongModel newSong) {
  final controller = Get.find<PlayerController>();
  controller.updateSelectedSong(newSong);
}

  @override
  void onInit() {
    super.onInit();
    // checkPermission();
   initAudioPlayerListeners(); 
   loadFavoriteSongs();
   loadPlayCounts(); 
   loadRecentlyPlayedSongs(); 
   
  }
 Future<void> loadSongs() async {
    var songs = await audioquery.querySongs(
      sortType: SongSortType.TITLE,
      uriType: UriType.EXTERNAL,
    );
    searchResults.assignAll(songs);
  }

  void incrementPlayCount(SongModel song) {
    playCounts[song.id] = (playCounts[song.id] ?? 0) + 1;
    savePlayCounts();
  }

  Future<void> savePlayCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final playCountsMap = playCounts.map((key, value) => MapEntry(key.toString(), value));
    prefs.setString('playCounts', jsonEncode(playCountsMap));
  }

  Future<void> loadPlayCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final playCountsString = prefs.getString('playCounts');
    if (playCountsString != null) {
      final playCountsMap = Map<int, int>.from(jsonDecode(playCountsString).map((key, value) => MapEntry(int.parse(key), value)));
      playCounts.assignAll(playCountsMap);
    }
  }
 
  Future<void> saveFavoriteSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final songIds = favoriteSongs.map((song) => song.id).toList();
    prefs.setStringList('favoriteSongs', songIds.map((id) => id.toString()).toList());
  }


  Future<void> loadFavoriteSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final songIds = prefs.getStringList('favoriteSongs');
    if (songIds != null) {
      final songs = await audioquery.querySongs(
        sortType: SongSortType.TITLE,
        uriType: UriType.EXTERNAL,
      );
      favoriteSongs.assignAll(songs.where((song) => songIds.contains(song.id.toString())).toList());
    }
  }


  void rewind(int seconds) {
    final currentPosition = audioPlayer.position;
    final newPosition = currentPosition - Duration(seconds: seconds);

    
    if (newPosition.isNegative) {
      audioPlayer.seek(Duration.zero); 
    } else {
      audioPlayer.seek(newPosition);
    }
  }


  void fastForward(int seconds) {
    final currentPosition = audioPlayer.position;
    final newPosition = currentPosition + Duration(seconds: seconds);
    final totalDuration = audioPlayer.duration ?? Duration.zero;

   
    if (newPosition >= totalDuration) {
      audioPlayer.seek(totalDuration); 
    } else {
      audioPlayer.seek(newPosition);
    }
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
    try {
      
      playIndex.value = index;

      
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
      isPlaying.value = true;
      updateSelectedSong(searchResults[index]);
       incrementPlayCount(searchResults[index]);
     
      bool alreadyPlayed =
          recentlyPlayedSongs.any((song) => song.id == searchResults[index].id);

     
      if (!alreadyPlayed) {
        recentlyPlayedSongs.insert(0, searchResults[index]);

      
        if (recentlyPlayedSongs.length > 100) {
          recentlyPlayedSongs.removeLast();
        }
        saveRecentlyPlayedSongs();
       
      }
    } catch (e) {
      
    }
  }

  void playNextSong() {
    final currentIndex = playIndex.value;
    if (currentIndex < searchResults.length - 1) {
      playSong(searchResults[currentIndex + 1].uri, currentIndex + 1);
    } else {
     
      stopSong();
    }
  }

  void stopSong() {
    audioPlayer.stop();
    isPlaying.value = false;
  }

 
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

  
  Future<List<SongModel>> searchSongs(String query) async {
    try {
      var songs = await audioquery.querySongs(
        sortType: SongSortType.TITLE,
        uriType: UriType.EXTERNAL,
      );

      if (query.isEmpty) {
        return songs;
      }


      var filteredSongs = songs.where((song) {
        return song.title.toLowerCase().contains(query.toLowerCase());
      }).toList();

      return filteredSongs;
    } catch (e) {
      return [];
    }
  }

 
  void updateSearchResults(List<SongModel> results) {
    searchResults.assignAll(results);
  }


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

     
      final clampedValue = positionValue.clamp(0.0, max.value);
      value.value = clampedValue;
    });
  }

  void deleteSong(SongModel song) {
  
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text(
          'Confirm Deletion',
          style: TextStyle(fontSize: 20),
        ),
        content: const Text('Are you sure you want to delete this song?'),
        actions: [
          TextButton(
            onPressed: () {
             
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
            
              searchResults.remove(song);
           
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Song deleted')),
              );
             
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }


  changeDurationToSeconds(seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    savePlayCounts();  
    super.onClose();
  }

  checkPermission() async {
    var perm = await Permission.storage.request();
    if (perm.isGranted) {
    } else {
      checkPermission();
    }
  }


  void toggleFavorite(SongModel song) {
    if (isFavorite(song)) {
      favoriteSongs.remove(song);
      Get.snackbar(
          "Removed", "${song.displayNameWOExt} removed from favorites");
    } else {
      favoriteSongs.add(song);

      Get.snackbar("Added", "${song.displayNameWOExt} added to favorites");
    }saveFavoriteSongs(); 
  }

  
  bool isFavorite(SongModel song) {
    return favoriteSongs.contains(song);
  }

   void toggleLoop() {
    if (isLooping.value) {
      isLooping(false);
      Get.snackbar('Order', 'Order Off');
    } else {
      isLooping(true);
      isShuffling(false);
      isRepeating(false);
      Get.snackbar('Order', 'Order On');
    }
  }

  void toggleShuffle() {
    if (isShuffling.value) {
      isShuffling(false);
      Get.snackbar('Shuffle', 'Shuffle Off');
    } else {
      isShuffling(true);
      isLooping(false);
      isRepeating(false);
      Get.snackbar('Shuffle', 'Shuffle On');
    }
  }

  void toggleRepeat() {
    if (isRepeating.value) {
      isRepeating(false);
      Get.snackbar('Repeat', 'Repeat Off');
    } else {
      isRepeating(true);
      isLooping(false);
      isShuffling(false);
      Get.snackbar('Repeat', 'Repeat On');
    }
  }Future<void> saveRecentlyPlayedSongs() async {
  final prefs = await SharedPreferences.getInstance();
  final songIds = recentlyPlayedSongs.map((song) => song.id).toList();
  prefs.setStringList('recentlyPlayedSongs', songIds.map((id) => id.toString()).toList());
}
Future<void> loadRecentlyPlayedSongs() async {
  final prefs = await SharedPreferences.getInstance();
  final songIds = prefs.getStringList('recentlyPlayedSongs');
  if (songIds != null) {
    final songs = await audioquery.querySongs(
      sortType: SongSortType.TITLE,
      uriType: UriType.EXTERNAL,
    );
    recentlyPlayedSongs.assignAll(songs.where((song) => songIds.contains(song.id.toString())).toList());
  }
}

int getFavoriteSongsCount() {
    return favoriteSongs.length;
  }

void playPreviousSong() {
  final currentIndex = playIndex.value;
  if (currentIndex > 0) {
    playSong(searchResults[currentIndex - 1].uri, currentIndex - 1);
  } else {
   
    stopSong();
  }
}
}


