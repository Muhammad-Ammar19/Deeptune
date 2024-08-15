import 'package:deeptune_musicplayer/ad_controller.dart';
import 'package:deeptune_musicplayer/page_view_main.dart';
import 'package:deeptune_musicplayer/player_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_preview/device_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
 
  await MobileAds.instance.initialize();
  AdManager.init();

 
  Get.put(PlayerController());
  await _requestPermission();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, 
    DeviceOrientation.portraitDown
  ]);

 
  runApp(
    DevicePreview(
      enabled: !const bool.fromEnvironment('dart.vm.product'),
      builder: (context) => const MyApp(),
    ),
  );

 
  AdManager.showAppOpenAd();
}

Future<void> _requestPermission() async {
  PermissionStatus status;
  do {
    status = await Permission.storage.request();
  } while (!status.isGranted);

 
}

class ThemePreference {
  static const String _keyIsDarkMode = 'isDarkMode';

  static Future<void> setTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsDarkMode, isDarkMode);
  }

  static Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsDarkMode) ?? false;
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
          builder: DevicePreview.appBuilder,
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
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




