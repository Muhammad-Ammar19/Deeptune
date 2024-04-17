
import 'package:flutter/material.dart';



class RecentlyPlayed extends StatefulWidget {
  const RecentlyPlayed({super.key});

  @override
  State<RecentlyPlayed> createState() => _RecentlyPlayedState();
}

class _RecentlyPlayedState extends State<RecentlyPlayed> {
  @override
  Widget build(BuildContext context) {
    return  SizedBox(height: 75,width: double.infinity,
    
           child: Center(child: Row(
            
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            
            
            children: [
    
    
                 Card(
                        elevation: 4,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              "assets/images/strangerthings.jpg",
                             height: 70,
                            )),
                      ),
    
    
    
           
                 Card(
                        elevation: 4,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              "assets/images/strangerthings.jpg",
                             height: 70,
                            )),
                      ),
    
    
    
                 Card(
                        elevation: 4,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              "assets/images/strangerthings.jpg",
                             height: 70,
                            )),
                      ),
    
    
    
                 Card(
                        elevation: 4,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              "assets/images/strangerthings.jpg",
                             height: 70,
                            )),
                      ),
    
    
    
    
    
    
    
           ],)),
    
    
    
    
    
    );
  }
}