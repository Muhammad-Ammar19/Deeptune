import 'package:hive/hive.dart';
import 'databasehelper.dart';

class HiveService {
  static final HiveService _singleton = HiveService._internal();
  Box<SongModel>? _favoriteSongsBox;

  factory HiveService() {
    return _singleton;
  }

  HiveService._internal();

  Future<void> init() async {
    _favoriteSongsBox ??= await Hive.openBox<SongModel>('favoriteSongsBox');
  }

  Box<SongModel> get favoriteSongsBox {
    if (_favoriteSongsBox == null) {
      throw HiveError('The box "favoriteSongsBox" is not opened yet.');
    }
    return _favoriteSongsBox!;
  }
}
