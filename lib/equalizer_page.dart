import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EqualizerPage extends StatelessWidget {
  const EqualizerPage({super.key});

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
      bottomNavigationBar: SizedBox(
        height: Get.height *0.07,
        child: const Center(
          child: Text("Test Ad"),
        ),
      ),
      body: const SafeArea(child: Placeholder()),
    );
  }
}




