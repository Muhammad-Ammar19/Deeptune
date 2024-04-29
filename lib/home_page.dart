import 'package:deeptune_musicplayer/equalizer_page.dart';
import 'package:deeptune_musicplayer/main.dart';
import 'package:deeptune_musicplayer/music_library.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:get/get.dart';
import 'bottom_player.dart';
import 'package:flutter/material.dart';
import 'search_list.dart';
import 'song_list_view.dart';
import 'recently_played.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: [
            GestureDetector(
                onTap: () {
                  Get.to(() => SearchList(), transition: Transition.fadeIn);
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.search,
                    size: 25,
                  ),
                ))
          ],
          title: const Text(
            "Deeptune",
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
        ),

        drawer: const CustomDrawer(), // Drawer

        bottomNavigationBar:  const BottomMusicPlayer(), // Bottom Music Player

        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: SizedBox(
                    width: double.infinity,
                    height: Get.height * 0.2,
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
                    )),
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: 10, left: 13, right: 16, bottom: 5),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent",
                      style: TextStyle(
                          fontFamily: "Monteserrat",
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) =>  SearchList()));
                    //   }
                    //   child: const Text(
                    //     "See all >",
                    //     style: TextStyle(
                    //         fontFamily: "Monteserrat",
                    //         fontSize: 11,
                    //         color: Colors.grey,
                    //         fontWeight: FontWeight.normal),
                    //   ),
                    // ),
                  ],
                ),
              ),

              const RecentlyPlayed(), // New Page for recently played

              Container(
                margin: const EdgeInsets.only(left: 13, right: 17, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Song list",
                      style: TextStyle(
                          fontFamily: "Monteserrat",
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => SearchList(),
                            transition: Transition.fadeIn);
                      },
                      child: const Text(
                        "See all >",
                        style: TextStyle(
                            fontFamily: "Monteserrat",
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ),

              const SongListView() // Shows Song List in HomePage
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
    return Drawer(
      elevation: 5,
      width: Get.width * 0.8,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Settings",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
            ),
            const SizedBox(height: 10),
            ListTile(
              onTap: () async {
                await ThemePreference.setTheme(false);
                Get.changeThemeMode(ThemeMode.light);
              },
              title: const Text(
                "Light mode ",
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.bold), //  Light Mode
              ),
              leading: const Icon(
                Icons.light_mode_rounded,
                size: 15,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 12,
              ),
              dense: true,
            ),
            ListTile(
              onTap: () async {
                await ThemePreference.setTheme(true);
                Get.changeThemeMode(ThemeMode.dark);
              },
              title: const Text(
                "Dark mode",
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.bold), //  Dark Mode
              ),
              leading: const Icon(
                Icons.dark_mode_rounded,
                size: 15,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 12,
              ),
              dense: true,
            ),
            ListTile(
              onTap: () {},
              title: const Text(
                "Choose Language",
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.bold), // Bluetooth
              ),
              leading: const Icon(
                Icons.language_rounded,
                size: 15,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 12,
              ),
              dense: true,
            ),
            ListTile(
              title: const Text(
                "Equalizer",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              leading: const Icon(
                Icons.equalizer_rounded,
                size: 15,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 12,
              ),
              dense: true,
              onTap: () {
                Get.to(() => const EqualizerPage(),
                    transition: Transition.fadeIn);
              },
            ),
            ListTile(
              onTap: () {
                Get.to(() => const GridViewPage(),
                    transition: Transition.fadeIn);
              },
              title: const Text(
                "Music Library",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              leading: const Icon(
                Icons.music_note_rounded,
                size: 15,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 12,
              ),
              dense: true,
            ),
            ListTile(
              onTap: () {
                Get.defaultDialog(
                  titleStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  middleText:
                      'Want to support the developers?\nYou can support the developers by watching the ad.',
                  confirm: const Text(
                    "Sure",
                    style: TextStyle(color: Colors.green),
                  ),
                  radius: 10,
                  title: "Support Developers",
                  cancel: const Text(
                    "No, Thanks",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  titlePadding: const EdgeInsets.all(10),
                );
              },
              title: const Text(
                "Support the Developers",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              leading: const Icon(
                Icons.favorite,
                size: 15,
              ),
              dense: true,
              iconColor: Colors.greenAccent,
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 12,
              ),
            ),
            ListTile(
              onTap: () {
                Get.defaultDialog(
                  title: 'Deeptune From ryze.',
                  middleText:
                      'Deeptune is your ultimate music player for a seamless listening experience. Enjoy customizable playback, playlist management, offline mode, and cross-platform sync.',
                  radius: 10,
                );
              },
              title: const Text(
                "About",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              leading: const Icon(
                Icons.info_outline_rounded,
                size: 15,
              ),
              dense: true,
            ),
            const AboutDialog(
              applicationVersion: "Version 1.0.0",
              applicationName: "Deeptune",
              applicationLegalese: "Deeptune From ryze.",
            ),
          ]),
    );
  }
}
