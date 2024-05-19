import 'package:flutter/material.dart';
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
  var playIndex = 0.obs;
  var duration = ''.obs;
  var position = ''.obs;
  final searchResults = <SongModel>[].obs;
  final recentlyPlayedSongs = <SongModel>[].obs;
  var favoriteSongs = <SongModel>[].obs; // List to store favorite songs
  var isLooping = false.obs;
  var isShuffling = false.obs;
  var isRepeating = false.obs;


  void updateSelectedSong(SongModel data) {
    // song changed to data
    selectedSong.value = data;
  }

  @override
  void onInit() {
    super.onInit();
    // checkPermission();
   initAudioPlayerListeners(); 
  }
 

// Rewind Code
  void rewind(int seconds) {
    final currentPosition = audioPlayer.position;
    final newPosition = currentPosition - Duration(seconds: seconds);

    // Ensure newPosition is not negative
    if (newPosition.isNegative) {
      audioPlayer.seek(Duration.zero); // Seek to the beginning
    } else {
      audioPlayer.seek(newPosition);
    }
  }

// FastForward Code
  void fastForward(int seconds) {
    final currentPosition = audioPlayer.position;
    final newPosition = currentPosition + Duration(seconds: seconds);
    final totalDuration = audioPlayer.duration ?? Duration.zero;

    // Ensure newPosition is not greater than total duration
    if (newPosition >= totalDuration) {
      audioPlayer.seek(totalDuration); // Seek to the end
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
      // Set the index of the currently playing song
      playIndex.value = index;

      // Set the audio source and play the song
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
      isPlaying.value = true;

      // Check if the song is already in the recently played list
      bool alreadyPlayed =
          recentlyPlayedSongs.any((song) => song.id == searchResults[index].id);

      // Add the played song to the list of recently played songs if not already present
      if (!alreadyPlayed) {
        recentlyPlayedSongs.insert(0, searchResults[index]);

        // Limit the recently played songs list to 100 items
        if (recentlyPlayedSongs.length > 100) {
          recentlyPlayedSongs.removeLast();
        }

        // Save the recently played songs to local storage
      }
    } catch (e) {
      // Handle error
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

  void deleteSong(SongModel song) {
    // Ask for confirmation before deleting
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
              // Dismiss the dialog
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Remove the song from the list
              searchResults.remove(song);
              // You may need to delete from storage as well
              // Notify the user
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Song deleted')),
              );
              // Dismiss the dialog
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

//  for slider seeking
  changeDurationToSeconds(seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

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

// Method to toggle favorite status
  void toggleFavorite(SongModel song) {
    if (isFavorite(song)) {
      favoriteSongs.remove(song);
      Get.snackbar(
          "Removed", "${song.displayNameWOExt} removed from favorites");
    } else {
      favoriteSongs.add(song);

      Get.snackbar("Added", "${song.displayNameWOExt} added to favorites");
    }
  }

  // Method to check if a song is favorite
  bool isFavorite(SongModel song) {
    return favoriteSongs.contains(song);
  }

   void toggleLoop() {
    if (isLooping.value) {
      isLooping(false);
      Get.snackbar('Loop', 'Loop Off');
    } else {
      isLooping(true);
      isShuffling(false);
      isRepeating(false);
      Get.snackbar('Loop', 'Loop On');
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
  }
}
