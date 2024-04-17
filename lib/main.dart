import 'package:deeptune_musicplayer/page_view_main.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _requestPermission();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

Future<void> _requestPermission() async {
  PermissionStatus status;
  do {
    status = await Permission.storage.request();
  } while (!status.isGranted);

  // Permission is granted. You can proceed with accessing storage.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "DeepTune",
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(useMaterial3: true,),

      theme: ThemeData(
     //   fontFamily: "Monteserrat",
        useMaterial3: true,
     //   brightness: Brightness.light,
      
      ),
      debugShowCheckedModeBanner: false,
      home:  PageViewMain(),
    );
  }
}
