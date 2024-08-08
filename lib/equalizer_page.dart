import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EqualizerPage extends StatefulWidget {
  const EqualizerPage({Key? key}) : super(key: key);

  @override
  EqualizerPageState createState() => EqualizerPageState();
}

class EqualizerPageState extends State<EqualizerPage> {
 
  List<double> bandValues = List.filled(5, 0.0); 

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
          IconButton(
            onPressed: () {
             
            },
            icon: const Icon(Icons.more_vert_sharp),
          )
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: Get.height * 0.07,
        child: const Center(
          child: Text("Test Ad"),
        ),
      ),
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                 
                  for (int i = 0; i < bandValues.length; i++)
                    EqualizerSlider(
                      bandId: i,
                      value: bandValues[i],
                      onChanged: (newValue) {
                        setState(() {
                          bandValues[i] = newValue;
                        });
                      },
                    ),
                  
                  ElevatedButton(
                    onPressed: () {
                    
                    },
                    child: const Text('Apply Equalizer Settings'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EqualizerSlider extends StatelessWidget {
  final int bandId;
  final double value;
  final ValueChanged<double>? onChanged;

  const EqualizerSlider({
    Key? key,
    required this.bandId,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Band $bandId',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Slider(
          value: value,
          min: -12.0,
          max: 12.0,
          divisions: 24,
          onChanged: onChanged,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}