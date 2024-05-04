import 'package:deeptune_musicplayer/page_view_main.dart';
import 'package:deeptune_musicplayer/player_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await _initHive();
  Get.put(PlayerController());
  await _requestPermission();
  
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

Future<void> _initHive() async {
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
}

Future<void> _requestPermission() async {
  PermissionStatus status;
  do {
    status = await Permission.storage.request();
  } while (!status.isGranted);

  // Permission is granted. You can proceed with accessing storage.
}

class ThemePreference {
  static const String _boxName = 'theme_preference';

  static Future<Box> _openBox() async {
    return await Hive.openBox(_boxName);
  }

  static Future<void> setTheme(bool isDarkMode) async {
    final box = await _openBox();
    await box.put('isDarkMode', isDarkMode);
  }

  static Future<bool> getTheme() async {
    final box = await _openBox();
    return box.get('isDarkMode', defaultValue: false);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: ThemePreference.getTheme(),
      builder: (context, snapshot) {
        final isDarkMode = snapshot.data ?? false;

        return GetMaterialApp(
          title: "DeepTune",
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
              textTheme:
                  ThemeData.dark().textTheme.apply(fontFamily: 'Monteserrat')),
          theme: ThemeData(
            fontFamily: 'Monteserrat',
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: PageViewMain(),
        );
      },
    );
  }
}
