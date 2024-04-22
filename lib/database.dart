import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'favorites_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        artist TEXT,
        uri TEXT
      )
    ''');
  }

  Future<int> insertFavorite(FavoriteSong song) async {
    final db = await database;
    return await db.insert('favorites', song.toMap());
  }

  Future<List<FavoriteSong>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return List.generate(maps.length, (i) {
      return FavoriteSong.fromMap(maps[i]);
    });
  }

  Future<int> deleteFavorite(int id) async {
    final db = await database;
    return await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isFavorite(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }
}


class FavoriteSong {
  final int id;
  final String title;
  final String artist;
  final String uri; // Update this line

  FavoriteSong({
    required this.id,
    required this.title,
    required this.artist,
    required this.uri, // Update this line
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'uri': uri,
    };
  }

  factory FavoriteSong.fromMap(Map<String, dynamic> map) {
    return FavoriteSong(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      uri: map['uri'],
    );
  }
}
