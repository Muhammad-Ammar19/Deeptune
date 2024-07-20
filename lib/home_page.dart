import 'package:deeptune_musicplayer/ad_controller.dart';
import 'package:deeptune_musicplayer/all_songs_page.dart';
import 'package:deeptune_musicplayer/equalizer_page.dart';
import 'package:deeptune_musicplayer/main.dart';
import 'package:deeptune_musicplayer/music_library.dart';
import 'package:deeptune_musicplayer/recent_page.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:get/get.dart';
import 'bottom_player.dart';
import 'package:flutter/material.dart';
import 'search_list.dart';
import 'song_list_view.dart';
import 'recently_played.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double paddingValue = Get.width * 0.03;
    double titleFontSize = Get.width * 0.06;
    double subtitleFontSize = Get.width * 0.034;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          centerTitle: true,
          actions: [
            GestureDetector(
                onTap: () {
                  Get.to(() =>  SearchList(), transition: Transition.fadeIn);
                },
                child: Padding(
                  padding: EdgeInsets.only(right: paddingValue),
                  child: Icon(
                    Icons.search,
                    size: Get.width * 0.06,
                  ),
                )),
          ],
          title: Text(
            "Deeptune",
            style: TextStyle(
              fontSize: Get.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        drawer: const CustomDrawer(), // Drawer

        bottomNavigationBar:  const BottomMusicPlayer(), // Bottom Music Player

        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: paddingValue),
                child: SizedBox(
                  width: double.infinity,
                  height: Get.height * 0.17,
                  child: DropShadowImage(
                    image: Image.asset(
                      "assets/images/cover.jpg",
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                    borderRadius: 9,
                    blurRadius: 7,
                    offset: const Offset(5, 6),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: Get.height * 0.02,
                  left: paddingValue,
                  right: paddingValue,
                  bottom: Get.height * 0.01,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent",
                      style: TextStyle(
                        fontFamily: "Monteserrat",
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const RecentPage(),transition: Transition.fadeIn);
                      },
                      child: Text(
                        "See all >",
                        style: TextStyle(
                          fontFamily: "Monteserrat",
                          fontSize: subtitleFontSize,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const RecentlyPlayed(), // New Page for recently played

              Container(
                margin: EdgeInsets.symmetric(horizontal: paddingValue),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Songs",
                      style: TextStyle(
                        fontFamily: "Monteserrat",
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const AllSongsPage(), transition: Transition.fadeIn);
                      },
                      child: Text(
                        "See all >",
                        style: TextStyle(
                          fontFamily: "Monteserrat",
                          fontSize: subtitleFontSize,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SongListView(), // Shows Song List in HomePage
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    double iconSize = Get.width * 0.04; // Adjust this as needed
    double fontSize = Get.width * 0.032; // Adjust this as needed
    double titleFontSize = Get.width * 0.06; // Adjust this as needed

    return Drawer(
      elevation: 5,
       width: Get.width *0.85,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: Get.height * 0.08),
            Text(
              "Settings",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: titleFontSize),
            ),
            SizedBox(height: Get.height * 0.02),
            ListTile(
              onTap: () async {
                await ThemePreference.setTheme(false);
                Get.changeThemeMode(ThemeMode.light);
              },
              title: Text(
                "Light mode",
                style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              ),
              leading: Icon(
                Icons.light_mode_rounded,
                size: iconSize,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: iconSize * 0.75,
              ),
              dense: true,
            ),
            ListTile(
              onTap: () async {
                await ThemePreference.setTheme(true);
                Get.changeThemeMode(ThemeMode.dark);
              },
              title: Text(
                "Dark mode",
                style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              ),
              leading: Icon(
                Icons.dark_mode_rounded,
                size: iconSize,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: iconSize * 0.75,
              ),
              dense: true,
            ),
            ListTile(
              onTap: () {
                AdManager.showRewardedAd();
              },
              title: Text(
                "Chrome Cast",
                style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              ),
              leading: Icon(
                Icons.cast_connected_rounded,
                size: iconSize,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: iconSize * 0.75,
              ),
              dense: true,
            ),
            ListTile(
              onTap: () {
                Get.to(() => const EqualizerPage(), transition: Transition.fadeIn);
              },
              title: Text(
                "Equalizer",
                style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              ),
              leading: Icon(
                Icons.equalizer_rounded,
                size: iconSize,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: iconSize * 0.75,
              ),
              dense: true,
            ),
            ListTile(
              onTap: () {
                Get.to(() => const GridViewPage(), transition: Transition.fadeIn);
              },
              title: Text(
                "Music Library",
                style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              ),
              leading: Icon(
                Icons.music_note_rounded,
                size: iconSize,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: iconSize * 0.75,
              ),
              dense: true,
            ),
            ListTile(
              onTap: () {
                
              },
              title: Text(
                "Rate us",
                style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              ),
              leading: Icon(
                Icons.favorite,
                size: iconSize,
              ),
              dense: true,
              iconColor: Colors.greenAccent,
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: iconSize * 0.75,
              ),
            ),
            ListTile(
              onTap: () {
                Get.defaultDialog(
                  title: 'Deeptune from ryze.',
                  middleText: 'Deeptune is your ultimate music player for a seamless listening experience. Enjoy customizable playback, playlist management, offline mode, and cross-platform sync.',
                  radius: 10,
                );
              },
              title: Text(
                "About",
                style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              ),
              leading: Icon(
                Icons.info_outline_rounded,
                size: iconSize,
              ),
              dense: true,
            ),
            AboutDialog(
              applicationIcon: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image(
                  image: const AssetImage("assets/images/ryze_logo.png"),
                  height: Get.height * 0.06,
                  width: Get.width * 0.13,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
              applicationVersion: "Version 1.0.0",
              applicationName: "Deeptune",
              applicationLegalese: "Deeptune from ryze.",
            ),
          ],
        ),
      ),
    );
  }
}