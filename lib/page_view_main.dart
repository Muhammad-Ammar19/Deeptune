import 'package:flutter/material.dart';
import 'home_page.dart';
import 'music_library.dart';



class PageViewMain extends StatelessWidget {
   PageViewMain({super.key});
   final PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: PageController(),
          children: const [HomePage(), GridViewPage()
          ],
        ),
      ),
    );
  }
}


