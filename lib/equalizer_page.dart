import 'package:flutter/material.dart';
import 'package:deeptune_musicplayer/ad_controller.dart';
import 'package:get/get.dart';

class EqualizerPage extends StatelessWidget {
  const EqualizerPage({super.key,});

  @override
  Widget build(BuildContext context) {
    final bannerAdWidget = AdManager.getBannerAdWidget();

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
      bottomNavigationBar: bannerAdWidget != Container() ? SizedBox(
        height: Get.height * 0.06,
        child: bannerAdWidget,
      ) : null,
      body: const SafeArea(child: Placeholder()),
    );
  }
}




