import 'package:flutter/material.dart';
import 'package:deeptune_musicplayer/ad_controller.dart';
import 'package:get/get.dart';

class EqualizerPage extends StatefulWidget {
  const EqualizerPage({Key? key}) : super(key: key);

  @override
  State<EqualizerPage> createState() => _EqualizerPageState();
}

class _EqualizerPageState extends State<EqualizerPage> {
  late Widget? bannerAdWidget;

  @override
  void initState() {
    super.initState();
    loadBannerAd();
  }

  void loadBannerAd() {
    bannerAdWidget = AdManager.getBannerAdWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Equalizer",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_sharp))
        ],
      ),
      bottomNavigationBar: bannerAdWidget != null
          ? SizedBox(
              height: Get.height * 0.06,
              child: bannerAdWidget!,
            )
          : null,
      body: const SafeArea(child: Placeholder()),
    );
  }
}
