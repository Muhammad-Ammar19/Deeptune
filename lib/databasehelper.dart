import 'package:hive/hive.dart';

part 'databasehelper.g.dart';

@HiveType(typeId: 0)
class SongModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String uri;

  @HiveField(3)
  final String displayNameWOExt;

  SongModel({
    required this.id,
    required this.title,
    required this.uri,
    required this.displayNameWOExt,
  });
}