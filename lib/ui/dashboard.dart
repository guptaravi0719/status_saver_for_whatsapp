import 'package:flutter/material.dart';
import 'package:whatsappstatussaver/ui/game_web_view.dart';
import 'package:whatsappstatussaver/ui/imageScreen.dart';
import 'package:whatsappstatussaver/ui/videoScreen.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => new DashboardState();
}

class DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return TabBarView(

      children: [
        ImageScreen(),
     // Container()
       VideoScreen(),
      //  Container()
      //GameWebView()
      ],
    );
  }
}
